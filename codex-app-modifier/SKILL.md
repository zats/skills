---
name: codex-app-modifier
description: Create a locally modified copy of the Codex macOS desktop app. Use when the user wants Codex.app cracked open, renderer/main/resources changed, the app icon replaced with the bundled skill icon, then repacked, ad-hoc signed, placed next to the original as a Codex change-named app bundle, launched, and verified without modifying the original app.
---

# Codex App Modifier

## Rules

- Never modify the original Codex app.
- Always produce a sibling app bundle named `Codex-<one-or-two-words>.app`.
- Always make app/resource edits in the temporary extracted ASAR folder created by the script.
- Always use the bundled icon at `assets/app.png`.
- Always launch the finished app and verify it is running.
- Before finalizing an existing modified app bundle, force quit that modified app and its helper/background processes. A running bundle can keep old `app.asar` contents or workers alive, making edits appear to miss.
- After finalizing, verify the packed app bundle contains the intended edits by extracting or grepping `/Applications/Codex-<Name>.app/Contents/Resources/app.asar`, not only the temp edit directory.
- On the first use in a session, run preflight before doing anything else.
- For UI changes, support both light and dark mode by matching the app's existing theme variables/selectors.
- For added UI, match the closest existing in-app precedent so fonts, sizes, spacing, colors, states, and density feel native to Codex.

## Workflow

1. Pick a short change name from the user request, e.g. `Gradient`, `Compact Sidebar`, `Blue Theme`.
2. Run preflight:

```bash
~/.codex/skills/codex-app-modifier/scripts/mod_codex_app.sh preflight --original /Applications/Codex.app
```

If preflight reports missing tools, stop. Ask the user before installing anything. If they approve, install only the missing tools; otherwise report the missing commands and suggested install path from the script output.

3. Prepare the copied bundle and temp extraction:

```bash
~/.codex/skills/codex-app-modifier/scripts/mod_codex_app.sh prepare --name "Gradient" --original /Applications/Codex.app
```

If the destination exists, ask before replacing it, then rerun with `--replace`. Existing bundles are removed.

4. Edit only the printed `edit_dir` (`<workdir>/app`). Search with `rg`; patch extracted files with `apply_patch` or narrow mechanical commands. For renderer CSS/JS, expect Vite assets under `webview/assets`. For Electron bootstrap, expect `.vite/build/bootstrap.js`.

For UI-related requests, first find the most similar existing UI in the extracted bundle and mirror its implementation style. Reuse its typography scale, padding, gaps, color tokens, borders, hover/focus states, disabled states, and dark-mode selectors. Prefer existing app tokens and classes over new raw values. Do not add UI that visually feels separate from Codex. Verify the final behavior in both appearances when possible.

5. Finalize:

```bash
~/.codex/skills/codex-app-modifier/scripts/mod_codex_app.sh finalize --workdir /tmp/codex-app-mod-...
```

If replacing an already-running modified app, kill the bundle and helpers first:

```bash
pgrep -f '^/Applications/Codex-<Name>\.app|/Applications/Codex-<Name>\.app/Contents|/Applications/Codex-<Name>\.app/Contents/Resources/codex app-server|/Applications/Codex-<Name>\.app/Contents/Resources/native' | while read pid; do kill -9 "$pid"; done
```

Then finalize. The script repacks `app.asar`, replaces icons, updates `Info.plist`, installs the launch wrapper, signs, refreshes macOS app/icon caches, launches, verifies the process and unique profile path, then removes the temp folder.

For renderer/resource edits, confirm the live bundle was updated:

```bash
tmpdir=$(mktemp -d)
npx --yes asar extract /Applications/Codex-<Name>.app/Contents/Resources/app.asar "$tmpdir/app"
rg '<expected-edit-marker>' "$tmpdir/app"
rm -rf "$tmpdir"
```

## Dry-Run Learnings

- Replacing only `electron.icns` is insufficient when `CFBundleIconName = Icon` points macOS at `Assets.car`. Remove `CFBundleIconName`, set `CFBundleIconFile = electron.icns`, replace all `.icns`, and refresh LaunchServices/QuickLook/Dock.
- Loose PNGs can still appear in app UI/about/default surfaces. Replace `icon.png`, `icon-codex-light.png`, `icon-codex-dark-color.png`, `codexTemplate*.png`, and `default_app/icon.png` when present.
- Changing `CFBundleIdentifier` and Electron `app.setName()` is insufficient for concurrent launch. Chromium claims the original profile before app JS runs. The wrapper must launch the real binary with:

```bash
--user-data-dir="$HOME/Library/Application Support/Codex <Name>"
```

- Patch `.vite/build/bootstrap.js` to set the display name and `userData` path as well, but rely on the wrapper for the early Chromium singleton.
- `asar extract-file` can be unreliable with this archive layout; verify packed changes by extracting the full ASAR to a temp folder if needed.
- `codesign --verify --deep --strict` passing does not prove launch. Always run the app and check the process path plus `--user-data-dir`.

## Script Notes

`scripts/mod_codex_app.sh` is intentionally deterministic because this operation is fragile. Read or patch it only if the app layout changes. It uses `rm -rf` for removals and temp cleanup.
