# Superpowers nástroje pre AI agentov

Devcontainer doplnok [`_agents-superpowers`](https://github.com/RunDevelopmentSk/devcontainers). Pridáva [superpowers nástroje](https://github.com/obra/superpowers) pre AI agentov.

Tento doplnok má zmysel pridávať, len ak je už pridaný doplnok `_agents`.

## Pridanie

Skopíruj obsah priečinka `_agents-superpowers` do projektového priečiku.

Na koniec súboru `.devcontainer/post-create-agents.sh` pridaj:

```sh
# install Superpowers skills
SUPERPOWERS_INSTALL="original" # "original"|"vendor"
bash "$(dirname "${BASH_SOURCE[0]}")/post-create-superpowers.sh"
```

Premenná `SUPERPOWERS_INSTALL` môže mať nasledové hodonoty:

- `original` - originálna inštalácia `superpowers`, tak ako je popísaná v dokumentácii (t.j. formou pluginu). Týmto spôsobom nie je pokryté `auggie` CLI.
- `vendor` - prekopírovanie nástrojov z github repozitára do `.agents` priečinka v projekte. Takto je pokryté aj `auggie` CLI, je však zas otázne či to je rovnako funkčné ako pri `original` inštalácii.

V prípade `vendor` inštalácie pridaj súbor `.GEMINI.md` s obsahom:

```markdown
@.agents/skills/using-superpowers/SKILL.md
```

Ide o náhradu chýbajúceho session start hooku pre `agy`.

Urob rebuild devcontainera.

## Zmazanie

Zmaž, čo bolo pridané.

V prípade `vendor` inštalácie zmaž aj súbory, ktoré boli automaticky stiahnuté z https://github.com/obra/superpowers.
V prípade `original` inštalácie zmaž aj docker volumes, ktoré uchovávajú data jednotlivých AI agentov - pluginy sú totiž uložené tam.


Urob rebuild devcontainera.
