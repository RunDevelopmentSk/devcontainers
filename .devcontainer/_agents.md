# AI agents

Devcontainer feature [`_agents`](https://github.com/RunDevelopmentSk/devcontainers).
Adds `claude`, `codex`, `agy` and `auggie` CLI AI agents in the form of a [unified configuration](../docs/ai-agents.md).

## Installation

Copy the contents of the `_agents` folder into the project folder.

Add the following to the end of the `.devcontainer/.post-create.sh` file:

```sh
# AI agents: install
bash "$(dirname "${BASH_SOURCE[0]}")/post-create-agents.sh"
```

Add the following to the end of the `.devcontainer/post-start.sh` file:

```sh
# AI agents: materialize symlinked rules/workflows dirs that some agents can't read as symlinks
bash "$(dirname "${BASH_SOURCE[0]}")/post-start-agents.sh"
```

Add the following to the `.gitignore` file:

```sh
#
# AI agents
#
# ignore local overrides (per-developer notes/settings, never commit)
*.local.md
*.local.json
*.local.toml
```

Rebuild the devcontainer.

## Known limitation

`post-start-agents.sh` > `materialize_dir` is a **temporary workaround**: `auggie` and `agy` currently fail to read any files through a symlinked directory (`.augment/rules` and `.agents/workflows` respectively silently report zero entries), so this script replaces those two symlinks with real, gitignored directories containing a fresh copy of the source files on every container start. After editing `.agents/rules/` or `.agents/commands/`, reopen the devcontainer to get the changes copied over. See the [temporary workaround note](../docs/ai-agents.md#temporary-workaround-materialized-rules-and-workflows) in `docs/ai-agents.md` for details. Once both tools resolve symlinked directories correctly, drop `post-start-agents.sh`, its call in `post-start.sh`, and go back to plain symlinks for `.augment/rules` and `.agents/workflows`.

## Removal

Delete everything that was added.

Rebuild the devcontainer.
