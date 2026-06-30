---
name: revise-instructions
description: Edit existing prompts, system instructions, AGENTS.md files, Codex skills, or other AI instruction documents. Use whenever the user asks to change, update, improve, simplify, rewrite, revise, or make an existing prompt/skill/instruction file follow new guidance. Requires contradiction removal and in-place editing before adding new text.
---

# Revise Instructions

Use this skill when changing an existing prompt, skill, or instruction document.

## Core Rule

Prefer subtraction and in-place revision.

Do not append new guidance until you have:

1. Found existing text that conflicts with the latest user intent.
2. Deleted contradictory, stale, or superseded guidance.
3. Edited existing nearby text so it says the new thing directly.
4. Checked whether the result is already sufficient.

Add new text only when no existing section can carry the requirement cleanly.

## Workflow

1. Read the relevant instruction files before editing.
2. Identify the latest requested behavior in concrete terms.
3. Search for contradictions, duplicates, and weaker older guidance.
4. Remove contradictions first.
5. Rewrite existing bullets, sections, examples, descriptions, and metadata in place.
6. Add a new section or bullet only as a last resort.
7. Re-read the final document for internal consistency and unnecessary length.
8. Validate the file if it is a skill.

## Editing Standards

- Keep instructions short and imperative.
- Preserve the document's existing structure unless that structure is the problem.
- Update trigger metadata when changing a skill's intended use.
- Remove examples that now teach the wrong behavior.
- Avoid “also remember” patches that leave old behavior intact.
- Prefer one clear rule over multiple overlapping rules.

## Skill Files

When editing a skill:

- Update `description` first if the trigger conditions changed.
- Keep “when to use this skill” guidance in frontmatter, because the body loads only after trigger.
- Keep `SKILL.md` lean.
- Regenerate or update `agents/openai.yaml` when the UI-facing description is stale.
- Run the skill validator after changes.
