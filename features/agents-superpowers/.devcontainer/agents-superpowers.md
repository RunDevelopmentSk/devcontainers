# Superpowers tools for AI agents

Devcontainer feature [`agents-superpowers`](https://github.com/RunDevelopmentSk/devcontainers). Adds [superpowers tools](https://github.com/obra/superpowers) for AI agents.

It only makes sense to add this feature if the `agents` feature is already added.

## Installation

Copy the contents of the `features/agents-superpowers` folder into the project folder.

Add the following to the end of the `.devcontainer/post-create-agents.sh` file:

```sh
# install Superpowers skills
SUPERPOWERS_INSTALL="original" # "original"|"vendor"
bash "$(dirname "${BASH_SOURCE[0]}")/post-create-superpowers.sh"
```

The `SUPERPOWERS_INSTALL` variable can have the following values:

- `original` - the original installation of `superpowers`, as described in the documentation (i.e. as a plugin). This method does not cover the `auggie` CLI.
- `vendor` - copying the tools from the GitHub repository into the `.agents` folder in the project. This also covers the `auggie` CLI, but it is questionable whether it is as functional as the `original` installation.

For the `vendor` installation, add a `.GEMINI.md` file with the following content:

```markdown
@.agents/skills/using-superpowers/SKILL.md
```

This acts as a replacement for the missing session start hook for `agy`.

Rebuild the devcontainer.

## Removal

Delete everything that was added.

In case of `vendor` installation, also delete the files that were automatically downloaded from https://github.com/obra/superpowers.
In case of `original` installation, also delete the docker volumes that store data for individual AI agents - since plugins are stored there.

Rebuild the devcontainer.
