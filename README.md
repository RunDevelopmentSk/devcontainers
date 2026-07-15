# Devcontainers

This project serves as a shared specification for devcontainers (VS Code) used in other projects as development environments for a given technology. Currently, the following technologies are covered in `templates/`:

- `templates/odoo-19`
- `templates/php-7.3_mysql-5.7`
- `templates/php-8.0_mysql-5.7`
- `templates/php-8.3_mysql-5.7`
- `templates/ubuntu-noble` - Python or other "general" projects running on Linux.

To add a devcontainer to a given project, simply copy the contents of the template folder (corresponding to the project's technology) into the project folder.

## Features

The project also includes features that can be added to templates. These are contained in `features/`. Currently, the following features are available:

- `features/agents` - adds `claude`, `codex`, `agy`, and `auggie` CLI AI agents via a [unified configuration](docs/ai-agents.md).
- `features/agents-speckit` - adds [speckit tools](https://github.com/github/spec-kit) for AI agents.
- `features/agents-superpowers` - adds [superpowers tools](https://github.com/obra/superpowers) for AI agents.

To add a feature to a devcontainer in a given project:

- Copy the contents of the feature folder into the project folder.
- Following the instructions in `.devcontainer/<feature-name>.md` > `## Installation`, integrate it into the existing files of the devcontainer/project.

If the feature contains a folder named after one of the templates (e.g., `features/agents/odoo-19`), and you are applying the feature to the corresponding template (i.e., to `templates/odoo-19`), also copy this technology-specific feature content (i.e., the content of the `odoo-19` folder) into the project folder. Afterwards, you can delete the newly added top-level `odoo-19` folder.
