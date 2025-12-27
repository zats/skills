---
name: learn
description: "Capture durable user corrections/avoidances/preferences from the current session and record confirmed learnings in AGENTS.md so Codex follows them. When to use: user says don't do X, avoid Y, from now on do Z, or corrects behavior for future."
---

# Learn From Mistakes

## Quick flow
- Find the most recent **durable** correction/avoidance/preference in the current conversation.
- Target **global** by default unless the user explicitly says "project", "project-root", or "workspace". Do not pick local just because it exists.
- If the learning is new (not already in AGENTS.md), propose:
  - Short summary (1 line)
  - Detailed instruction (1–3 bullets)
- Confirmation should be lightweight: state what you will write and where. Assume it is durable and that global is OK unless the user says otherwise. User can reply "no", "stop", "project", or similar to change/cancel.
- If nothing new is found in context (or it already exists), run `scripts/extract_recent_transcript.py`, scan the JSONL from the last user message backward to find the most recent **durable** correction, then repeat the steps above.
- After this flow finishes, do not continue writing durable changes like we detected into the AGENTS.md directly without going through the same steps as outlined above (most imoprtantly always confirm writing into AGENTS.md if the write got triggered by durable preference detected)

## Durability filter
- Keep long-lived preferences and permanent mistake corrections.
- Exclude one-off or context-specific instructions tied only to the current task/files.

## AGENTS.md write
- Use section `## Codex Learnings` (create if missing).
- Bullets should be concise and specific ("Avoid X" / "Do Y instead of Z").
- Skip duplicates. If a conflict exists, ask how to resolve before writing.

## Target labels
- **global** (default): `~/.codex/AGENTS.md`
- **project**: `AGENTS.md` at repo root (or cwd if no repo)
- If both repo root and cwd have AGENTS.md, label them **project-root** and **workspace**.
- If the chosen target does not exist, ask to create it (still default to global unless user says otherwise).

## Script output
`scripts/extract_recent_transcript.py` returns JSON with `session_id`, `rollout_path`, `cwd`, and AGENTS.md candidates/suggestions.
