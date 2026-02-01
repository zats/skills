---
name: hig-docs
description: Answer questions about Apple Human Interface Guidelines using the bundled HIG markdown set from sosumi.ai. Use when users ask about Apple design guidance, components, patterns, or platform-specific HIG topics.
---

# HIG Docs

This skill provides offline access to Apple Human Interface Guidelines content.

## Quick start

1. Open the table of contents in [references/hig.md](references/hig.md) to find the right section.
2. Read the referenced topic file in `references/` (files are prefixed with `hig_`).
3. Answer using the wording in the doc, summarizing when helpful.

## Finding topics fast

- Use ripgrep to locate a topic if you’re unsure which file to open:
  ```bash
  rg -n "<keyword>" references
  ```
- Prefer files that match the exact topic title from the table of contents.

## Notes

- Each file includes frontmatter with `title`, `description`, and `source`.
- Content is unofficial and mirrors Apple’s HIG; include the source URL when citing specifics.
