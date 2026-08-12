---
description: >-
  Literally save the last prompt and agent response to a .md file. Without arguments,
  it asks whether to auto-generate the name or have the user enter it; names without
  a folder go to tmp/, with a folder stay in place; appends missing extension
  and always adds a suffix with the agent's name.
---

# /run.save-response – Save last prompt and response to .md

Follow the procedure according to the **`run-save-response`** skill (`.agents/skills/run-save-response/SKILL.md`). The command and the skill have the same output; this command is the entry point for Claude Code, Auggie, and Antigravity. (Codex does not support slash commands – use the `run-save-response` skill directly there.)

In short (details in the skill):

1. Determine the agent's suffix (`auggie` / `claude` / `agy` / `codex`).
2. Determine the target path:
   - without an argument -> ask the user whether to auto-generate the name (slug from the topic of the last response, folder `tmp/`) or if they want to enter it,
   - name without a folder -> folder `tmp/`,
   - name with a folder -> stays in that folder,
   - missing extension -> append `.md`.
3. Add the suffix `-<agent>` before `.md` (e.g., `my-tax-analyze-auggie.md`).
4. Write the **literal** (verbatim) last prompt and response under `**Prompt:**` / `**Response:**` headers (exact file format in the skill) – and announce the resulting path.

Hard rules: the prompt and response are verbatim, the agent suffix is always added, no secrets in the file (`.agents/rules/run.secret-safety.md`).

If the user provided an argument (name, potentially with a folder), narrow the procedure accordingly.
