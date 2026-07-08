# AI agenti

Devcontainer doplnok [`_agents`](https://github.com/RunDevelopmentSk/devcontainers).
Prídáva `claude`, `codex`, `agy` a `auggie` CLI AI agentov formou [zjednotenej konfigurácie](../docs/ai-agents.md).

## Pridanie

Skopíruj obsah priečinka `_agents` do projektového priečiku.

Na koniec súboru `.devcontainer/.post-create.sh` pridaj:

```sh
# install AI agents
bash "$(dirname "${BASH_SOURCE[0]}")/post-create-agents.sh"
```

Do súboru `.gitignore` pridaj:

```sh
#
# AI agents
#
# ignore local overrides (per-developer notes/settings, never commit)
*.local.md
*.local.json
*.local.toml
```

Urob rebuild devcontainera.

## Zmazanie

Zmaž, čo bolo pridané.

Urob rebuild devcontainera.
