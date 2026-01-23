#!/usr/bin/env python3
import json
import re
import subprocess
import sys
import urllib.error
import urllib.request

API_BASE = "https://api.github.com/repos/openai/codex/releases/tags/"


def get_codex_version() -> str:
    try:
        output = subprocess.check_output(["codex", "--version"], text=True).strip()
    except Exception as exc:
        raise RuntimeError("Failed to run 'codex --version'.") from exc

    match = re.search(r"(\d+\.\d+\.\d+(?:[-+][0-9A-Za-z_.]+)?)", output)
    if not match:
        raise RuntimeError(f"Unable to parse version from output: {output}")

    version = match.group(1)
    if version.startswith("v"):
        version = version[1:]
    return version


def fetch_release(tag: str) -> dict:
    url = f"{API_BASE}{tag}"
    req = urllib.request.Request(
        url,
        headers={
            "Accept": "application/vnd.github+json",
            "User-Agent": "codex-version-changelog",
        },
    )
    with urllib.request.urlopen(req, timeout=20) as response:
        return json.loads(response.read().decode("utf-8"))


def main() -> int:
    try:
        version = get_codex_version()
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    tags_to_try = [f"rust-v{version}", f"v{version}", version]
    release = None
    last_error = None

    for tag in tags_to_try:
        try:
            release = fetch_release(tag)
            break
        except urllib.error.HTTPError as exc:
            if exc.code == 404:
                last_error = exc
                continue
            print(f"GitHub API error for tag {tag}: {exc}", file=sys.stderr)
            return 1
        except Exception as exc:
            print(f"Failed to fetch release for tag {tag}: {exc}", file=sys.stderr)
            return 1

    if release is None:
        detail = ""
        if last_error is not None:
            detail = f" ({last_error})"
        print(
            "No matching release found for tags: "
            + ", ".join(tags_to_try)
            + detail,
            file=sys.stderr,
        )
        return 1

    print(f"Codex CLI version: {version}")
    name = release.get("name") or release.get("tag_name") or "(unknown)"
    published = release.get("published_at") or "(unknown)"
    print(f"Release: {name}")
    print(f"Published: {published}")
    print("\nChangelog:\n")
    body = release.get("body") or "(no changelog body)"
    print(body)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
