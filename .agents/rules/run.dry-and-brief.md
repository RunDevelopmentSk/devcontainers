---
description: >-
  Avoid restating or re-summarizing the same information multiple times in
  documentation or code when it adds no value for a human reader. Applies to
  all agents and skills; duplication that serves a distinct purpose (per-tool
  instructions, checklists, DoD repeats) is exempt.
type: always_apply
trigger: always_on
---

# Rule: DRY and brief content

Applies to all agents and all skills in this workspace, for both documentation and code.

## The problem

AI agents tend to over-generate: restating what was already written, summarizing a summary, or repeating the same information (even if rephrased) several times within one document or across multiple locations. This adds volume without adding information and makes content harder, not easier, for a human to read.

## When duplication is required (allowed)

Repetition is fine, and expected, when it serves a distinct purpose:

- content that must be spelled out separately per audience/tool/role (e.g. the per-agent instructions in `docs/ai-agents.md`, per-tool config blocks),
- checklists, DoD lists, or verification steps that are only useful when self-contained,
- index/pointer entries (e.g. `MEMORY.md`) that deliberately restate a one-line reference to fuller content held elsewhere,
- structurally required repetition (e.g. an artifact's name appearing in both its frontmatter and its file path).

## When duplication is not allowed

- Do not add a closing "summary of what changed / what was written" section that restates the body in different words - the reader already has the body.
- Do not restate the same requirement, fact, or explanation in multiple sections or artifacts just rephrased. Keep one source of truth and reference it from elsewhere, unless the content must be self-contained for a distinct purpose described above.
- Do not pad responses or files with recaps of previous turns/sections "for clarity" - trust the reader to have read what came before.
- In code: do not add comments that restate what the code already says; do not duplicate logic/abstractions that already exist elsewhere in the codebase - reuse or reference them instead.

## Rule of thumb

Before adding a paragraph, section, or comment, check the current artifact and relevant existing sources: does this add information or serve a distinct purpose? If not, delete it or replace it with a reference to the source of truth.
