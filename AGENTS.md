---
type: always_apply
trigger: always_on
---

# Instructions for AI agents

This file is a **shared source of truth** for all AI agents in the project
(Auggie, Claude Code, Antigravity, Codex). Auggie, Antigravity
and Codex read it natively; Claude Code reads it via the symlink `CLAUDE.md → AGENTS.md`.

Configuration details of individual agents and the unified structure are in
[`docs/ai-agents.md`](docs/ai-agents.md).

Before working, check:

- `.agents/rules/*.md` – modular workspace rules

## Always applicable cross-cutting rules

- @.agents/rules/run.language-policy.md
- @.agents/rules/run.secret-safety.md

## General description

The current project contains devcontainers that can be used in other projects as development environments for a given technology. It has two top-level categories:

- `templates/` – complete, standalone devcontainer bases (e.g. `templates/odoo-19`, `templates/php-7.3_mysql-5.7`). Individual templates are independent, although sometimes quite similar, as they only update a given technology for its newer version.
- `features/` – add-ons merged into an existing devcontainer (e.g. `features/agents`, `features/agents-speckit`, `features/agents-superpowers`).
