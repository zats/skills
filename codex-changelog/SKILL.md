---
name: codex-changelog
description: Check the current Codex CLI version and fetch/print the matching GitHub Releases changelog from https://github.com/openai/codex/releases when users ask for the Codex version, release notes, or changelog for their installed version.
---

# Codex Version Changelog

Print the changelog for the installed Codex CLI version.

## Workflow

1. Run `python3 scripts/print_codex_changelog.py`.
2. Share the printed changelog with the user.
3. If no matching release tag is found, tell the user which tags were attempted and offer to list recent releases.

## Script

- `scripts/print_codex_changelog.py`: Resolves the local Codex CLI version via `codex --version`, fetches the matching GitHub release, and prints its changelog body.
