#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  mod_codex_app.sh preflight [--original /Applications/Codex.app]
  mod_codex_app.sh prepare --name "Gradient" [--original /Applications/Codex.app] [--replace]
  mod_codex_app.sh finalize --workdir /tmp/codex-mod.xxxxxx [--keep-workdir]

Edits must be made under <workdir>/app before finalize.
EOF
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || missing+=("$1")
}

slugify() {
  local s="$1"
  s=$(printf '%s' "$s" | tr '[:upper:]' '[:lower:]')
  s=$(printf '%s' "$s" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')
  [ -n "$s" ] || s="modded"
  printf '%s' "$s"
}

title_words() {
  local s="$1"
  printf '%s' "$s" | awk '{
    for (i=1;i<=NF;i++) {
      $i=toupper(substr($i,1,1)) substr($i,2)
    }
    print
  }'
}

first_app_dir() {
  local original="$1"
  dirname "$original"
}

preflight() {
  local original="/Applications/Codex.app"
  while [ $# -gt 0 ]; do
    case "$1" in
      --original) original="$2"; shift 2 ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown argument: $1" ;;
    esac
  done

  missing=()
  for cmd in asar ditto codesign iconutil sips plutil open osascript mdls xattr sed awk perl pgrep ps grep qlmanage killall; do
    need_cmd "$cmd"
  done
  [ -x /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister ] || missing+=("lsregister")
  [ -e "$original" ] || die "original app not found: $original"
  [ -e "$(dirname "$0")/../assets/app.png" ] || die "bundled icon missing: $(dirname "$0")/../assets/app.png"

  if [ ${#missing[@]} -gt 0 ]; then
    printf 'Missing required tools:\n' >&2
    printf '  %s\n' "${missing[@]}" >&2
    cat >&2 <<'EOF'

Fail early. Ask the user before installing anything.
Likely install commands after confirmation:
  brew install asar
Apple tools such as codesign, iconutil, sips, plutil, open, osascript, and lsregister should come from macOS/Xcode command line tools.
EOF
    exit 2
  fi

  printf 'preflight ok\n'
}

prepare() {
  local original="/Applications/Codex.app"
  local name=""
  local replace=0
  while [ $# -gt 0 ]; do
    case "$1" in
      --original) original="$2"; shift 2 ;;
      --name) name="$2"; shift 2 ;;
      --replace) replace=1; shift ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown argument: $1" ;;
    esac
  done
  [ -n "$name" ] || die "--name is required"
  preflight --original "$original" >/dev/null

  local title slug app_dir dest workdir
  slug=$(slugify "$name")
  title=$(title_words "${slug//-/ }")
  app_dir=$(first_app_dir "$original")
  dest="$app_dir/Codex-$title.app"
  workdir=$(mktemp -d "/tmp/codex-app-mod-$slug.XXXXXX")

  if [ -e "$dest" ]; then
    [ "$replace" -eq 1 ] || die "destination exists: $dest (rerun with --replace after user confirms)"
    osascript -e "tell application id \"com.openai.codex.$slug\" to quit" >/dev/null 2>&1 || true
    sleep 2
    if pgrep -f "$dest" >/dev/null 2>&1; then
      die "destination app is still running: $dest"
    fi
    rm -rf "$dest"
  fi

  ditto "$original" "$dest"
  asar extract "$dest/Contents/Resources/app.asar" "$workdir/app"

  cat > "$workdir/manifest.env" <<EOF
ORIGINAL_APP='$original'
DEST_APP='$dest'
MOD_NAME='$title'
MOD_SLUG='$slug'
BUNDLE_ID='com.openai.codex.$slug'
USER_DATA_NAME='Codex $title'
EOF

  printf 'workdir=%s\n' "$workdir"
  printf 'dest=%s\n' "$dest"
  printf 'edit_dir=%s/app\n' "$workdir"
}

make_icns() {
  local icon="$1"
  local out="$2"
  local workdir iconset
  workdir=$(mktemp -d /tmp/codex-icon.XXXXXX)
  iconset="$workdir/App.iconset"
  mkdir -p "$iconset"
  sips -z 16 16 "$icon" --out "$iconset/icon_16x16.png" >/dev/null
  sips -z 32 32 "$icon" --out "$iconset/icon_16x16@2x.png" >/dev/null
  sips -z 32 32 "$icon" --out "$iconset/icon_32x32.png" >/dev/null
  sips -z 64 64 "$icon" --out "$iconset/icon_32x32@2x.png" >/dev/null
  sips -z 128 128 "$icon" --out "$iconset/icon_128x128.png" >/dev/null
  sips -z 256 256 "$icon" --out "$iconset/icon_128x128@2x.png" >/dev/null
  sips -z 256 256 "$icon" --out "$iconset/icon_256x256.png" >/dev/null
  sips -z 512 512 "$icon" --out "$iconset/icon_256x256@2x.png" >/dev/null
  sips -z 512 512 "$icon" --out "$iconset/icon_512x512.png" >/dev/null
  cp "$icon" "$iconset/icon_512x512@2x.png"
  iconutil -c icns "$iconset" -o "$out"
  rm -rf "$workdir"
}

shell_quote_sed() {
  printf '%s' "$1" | sed "s/[\\&]/\\\\&/g"
}

patch_bootstrap_identity() {
  local app_dir="$1"
  local display_name="$2"
  local user_data_name="$3"
  local bootstrap="$app_dir/.vite/build/bootstrap.js"
  [ -e "$bootstrap" ] || return 0

  local display_esc user_esc
  display_esc=$(shell_quote_sed "$display_name")
  user_esc=$(shell_quote_sed "$user_data_name")
  perl -0pi -e "s/i\\.app\\.setName\\(t\\.Ca\\(Q,se\\)\\),i\\.app\\.setPath\\(\`userData\`,C\\(\\{appDataPath:i\\.app\\.getPath\\(\`appData\`\\),buildFlavor:Q,env:process\\.env\\}\\)\\)/i.app.setName(\`$display_esc\`),i.app.setPath(\`userData\`,a.join(i.app.getPath(\`appData\`),\`$user_esc\`))/g" "$bootstrap"
}

replace_icons() {
  local dest="$1"
  local icon="$2"
  local icns
  icns=$(mktemp /tmp/codex-app-icon.XXXXXX.icns)
  make_icns "$icon" "$icns"

  for name in electron.icns app.icns icon.icns; do
    cp "$icns" "$dest/Contents/Resources/$name"
  done
  rm -rf "$icns"

  plutil -remove CFBundleIconName "$dest/Contents/Info.plist" >/dev/null 2>&1 || true
  plutil -replace CFBundleIconFile -string "electron.icns" "$dest/Contents/Info.plist"

  sips -s format png "$icon" --out "$dest/Contents/Resources/icon.png" >/dev/null || true
  sips -z 512 512 "$icon" --out "$dest/Contents/Resources/icon-codex-light.png" >/dev/null 2>&1 || true
  sips -z 512 512 "$icon" --out "$dest/Contents/Resources/icon-codex-dark-color.png" >/dev/null 2>&1 || true
  sips -z 256 256 "$icon" --out "$dest/Contents/Resources/codexTemplate.png" >/dev/null 2>&1 || true
  sips -z 512 512 "$icon" --out "$dest/Contents/Resources/codexTemplate@2x.png" >/dev/null 2>&1 || true
  sips -z 512 512 "$icon" --out "$dest/Contents/Resources/default_app/icon.png" >/dev/null 2>&1 || true
}

install_launcher_wrapper() {
  local dest="$1"
  local user_data_name="$2"
  local macos="$dest/Contents/MacOS"
  local exe="$macos/Codex"
  local real="$macos/Codex-bin"
  if [ ! -e "$real" ]; then
    mv "$exe" "$real"
  fi
  cat > "$exe" <<EOF
#!/bin/sh
DIR=\$(CDPATH= cd -- "\$(dirname -- "\$0")" && pwd)
exec "\$DIR/Codex-bin" --user-data-dir="\$HOME/Library/Application Support/$user_data_name" "\$@"
EOF
  chmod +x "$exe"
}

finalize() {
  local workdir=""
  local keep=0
  while [ $# -gt 0 ]; do
    case "$1" in
      --workdir) workdir="$2"; shift 2 ;;
      --keep-workdir) keep=1; shift ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown argument: $1" ;;
    esac
  done
  [ -n "$workdir" ] || die "--workdir is required"
  [ -e "$workdir/manifest.env" ] || die "manifest missing: $workdir/manifest.env"
  # shellcheck disable=SC1090
  source "$workdir/manifest.env"
  preflight --original "$ORIGINAL_APP" >/dev/null

  local icon app_json
  icon="$(dirname "$0")/../assets/app.png"

  osascript -e "tell application id \"$BUNDLE_ID\" to quit" >/dev/null 2>&1 || true
  sleep 2
  if pgrep -f "$DEST_APP" >/dev/null 2>&1; then
    die "destination app is still running: $DEST_APP"
  fi

  app_json="$workdir/app/package.json"
  if [ -e "$app_json" ]; then
    perl -0pi -e "s/\"productName\": \"Codex\"/\"productName\": \"$MOD_NAME\"/" "$app_json"
    perl -0pi -e "s/\"description\": \"Codex\"/\"description\": \"$MOD_NAME\"/" "$app_json"
  fi
  patch_bootstrap_identity "$workdir/app" "$MOD_NAME" "$USER_DATA_NAME"
  asar pack "$workdir/app" "$DEST_APP/Contents/Resources/app.asar"

  replace_icons "$DEST_APP" "$icon"
  plutil -replace CFBundleDisplayName -string "$MOD_NAME" "$DEST_APP/Contents/Info.plist"
  plutil -replace CFBundleName -string "$MOD_NAME" "$DEST_APP/Contents/Info.plist"
  plutil -replace CFBundleIdentifier -string "$BUNDLE_ID" "$DEST_APP/Contents/Info.plist"
  install_launcher_wrapper "$DEST_APP" "$USER_DATA_NAME"

  xattr -dr com.apple.quarantine "$DEST_APP" >/dev/null 2>&1 || true
  codesign --force --deep --sign - "$DEST_APP" >/dev/null
  codesign --verify --deep --strict --verbose=2 "$DEST_APP" >/dev/null

  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$DEST_APP" >/dev/null 2>&1 || true
  qlmanage -r cache >/dev/null 2>&1 || true
  killall Dock >/dev/null 2>&1 || true
  touch "$DEST_APP"

  open -n "$DEST_APP"
  sleep 8
  if ! pgrep -f "$DEST_APP" >/dev/null 2>&1; then
    die "launch verification failed: no process from $DEST_APP"
  fi
  if ! ps -axo args | grep -F "$HOME/Library/Application Support/$USER_DATA_NAME" | grep -v grep >/dev/null 2>&1; then
    die "launch verification failed: expected user-data-dir was not observed"
  fi

  if [ "$keep" -eq 0 ]; then
    rm -rf "$workdir"
  fi

  printf 'finalized=%s\n' "$DEST_APP"
  printf 'bundle_id=%s\n' "$BUNDLE_ID"
  printf 'user_data=%s\n' "$HOME/Library/Application Support/$USER_DATA_NAME"
}

cmd="${1:-}"
[ -n "$cmd" ] || { usage; exit 1; }
shift || true
case "$cmd" in
  preflight) preflight "$@" ;;
  prepare) prepare "$@" ;;
  finalize) finalize "$@" ;;
  -h|--help) usage ;;
  *) die "unknown command: $cmd" ;;
esac
