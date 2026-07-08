Refactor the repository-wide naming of local/shared AI agent assets to use the namespace prefix `run.` / `run-`.

Goal:
All project-owned AI agent skills, commands, and rules should be clearly namespaced with `run.` or `run-`, and all textual references to those assets should be updated consistently.

Scope:
Search the entire repository for AI agent related assets, especially directories and files related to Claude, Codex, Agy, Auggie, agent skills, slash commands, rules, prompts, instructions, workflows, and documentation.

Use this naming convention:

1. Command markdown files:

   * Rename command files to start with `run.`
   * Example:

     * `review.md` → `run.review.md`
     * `commit.md` → `run.commit.md`
     * `team-code-review.md` → `run.team-code-review.md`
     * `project-plan.md` → `run.project-plan.md`

2. Skill directories:

   * Rename skill folders to start with `run-`
   * Example:

     * `code-review/` → `run-code-review/`
     * `team-code-review/` → `run-team-code-review/`
     * `project-pr-summary/` → `run-project-pr-summary/`

3. Rule files:

   * Rename rule files to start with `run.`
   * Example:

     * `python.md` → `run.python.md`
     * `testing.md` → `run.testing.md`
     * `team-security.md` → `run.team-security.md`

4. Subagent files:

   * Rename subagent definition files (typically in `.agents/agents/`) to start with `run.`
   * Example:

     * `compare-solutions.md` → `run.compare-solutions.md`
     * `compare-solutions.toml` → `run.compare-solutions.toml`

Important rules:

* Rename only assets that are local/shared/project-owned.
* Do not rename third-party or externally installed assets such as `speckit.*`, `speckit-*`, vendor-provided files, package-managed files, lockfiles, generated files, or vendored dependencies.
* Do not change unrelated source code identifiers unless they are clearly references to these skills, commands, or rules.
* Avoid double-prefixing. For example, keep `run.review.md` as-is, do not rename it to `run.run.review.md`.
* Preserve the meaningful part of the name after replacing the old prefix.
* Use `git mv` or an equivalent rename-preserving operation where possible.

Update all references:
After renaming files and folders, search the repository and update every reference to the old names, including:

* Markdown documentation
* Agent instruction files
* README files
* Slash command references
* Skill references
* Rule references
* Subagent references
* YAML, JSON, TOML, and config files
* Scripts or setup instructions
* Relative paths
* Inline examples
* Lists of available commands, skills, or rules

Examples of reference updates:

* `/review` → `/run.review` only if it refers to the renamed command
* `/team-review` → `/run.team-review`
* `team-code-review` → `run-team-code-review`
* `project-pr-summary` → `run-project-pr-summary`
* `rules/python.md` → `rules/run.python.md`
* `.claude/skills/code-review` → `.claude/skills/run-code-review`
* `agents/compare-solutions.md` → `agents/run.compare-solutions.md`

Process:

1. Inspect the repository structure and identify all AI agent related locations.
2. Build a mapping from old asset names/paths to new `run.` / `run-` names.
3. Rename the files and directories.
4. Update all references to the old names and paths.
5. Check for leftover references to the old names.
6. Check for accidental double-prefixes such as `run.run.`, `run-run-`, or `run.run-`.
7. Run available formatting, linting, or test commands if the repository provides them.
8. Summarize exactly what was renamed and what references were updated.

Before finishing:

* Show the old → new rename mapping.
* Confirm that no stale references remain.
* Confirm that third-party namespaces such as `speckit.` and `speckit-` were left unchanged.
* Mention any ambiguous files that were intentionally not renamed.
