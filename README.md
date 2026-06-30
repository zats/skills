# Skills Repo

This directory holds Codex skills—self-contained folders (each with a `SKILL.md` and optional helpers) that extend the agent's abilities.

Included skills:
- `codex-app-modifier`: creates locally modified Codex macOS app bundles with icon replacement, signing, launch, and verification.
- `codex-changelog`: checks the installed Codex CLI version and fetches the matching GitHub Releases changelog.
- `hig-docs`: answers Apple Human Interface Guidelines questions using bundled HIG markdown references.
- `learn`: captures user corrections/preferences during a session and writes durable notes to `AGENTS.md` so future turns follow them.
- `revise-instructions`: edits existing prompts, skills, and instruction files by removing contradictions first and revising in place.
