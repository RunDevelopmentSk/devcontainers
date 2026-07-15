# Devcontainers

This project serves as a shared specification for devcontainers (VS Code) used in other projects as development environments for a given technology. Currently, the following technologies are covered:

- `odoo-19`
- `php-7.3_mysql-5.7`
- `php-8.0_mysql-5.7`
- `php-8.3_mysql-5.7`
- `ubuntu-noble` - Python or other "general" projects running on Linux.

To add a devcontainer to a given project, simply copy the contents of the folder (corresponding to the project's technology) into the project folder.

## Add-ons

The project also includes add-ons that can be added to devcontainers. These are contained in directories starting with an underscore. Currently, the following add-ons are available:

- `_agents` - adds `claude`, `codex`, `agy`, and `auggie` CLI AI agents via a [unified configuration](docs/ai-agents.md).
- `_agents-specskit` - adds [speckit tools](https://github.com/github/spec-kit) for AI agents.
- `_agents-superpowers` - adds [superpowers tools](https://github.com/obra/superpowers) for AI agents.

To add an add-on to a devcontainer in a given project:

- Copy the contents of the add-on folder into the project folder.
- Following the instructions in `.devcontainers/<add-on-name>.md` > `## Adding`, integrate it into the existing files of the devcontainer/project.

If the add-on contains a folder named after one of the devcontainers but starting with an underscore (e.g., `_odoo-19`), and you are applying the add-on to the corresponding devcontainer (i.e., to `odoo-19`), also copy this technology-specific add-on content (i.e., the content of the `_odoo-19` folder) into the project folder. Afterwards, you can delete the newly added top-level folders starting with an underscore.
