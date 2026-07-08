# Devcontainer-y

Tento projekt slúži ako zdieľaná špecifikácia pre devcontainer-y (VS Code) používané v iných projektoch ako vývojové prostredia pre danú technológiu. Aktuálne sú pokryté nasledovné technológie:

- `odoo-19`
- `php-7.3_mysql-5.7`
- `php-8.0_mysql-5.7`
- `php-8.3_mysql-5.7`
- `ubuntu-noble` - Python prípadne iné "všeobecné" projekty bežiace na Linuxe.

Na pridanie devcontainer-a do daného projektu stačí skopírovať obsah priečinka (korešpondujúceho s technológiou projektu) do projektového priečinka.

## Doplnky

V projekte sú obsiahnuté aj doplnky, ktoré možno do devcontainerov pridať. Tieto sú obsiahnuté v adresároch začínajúcich podtržítkom. Aktuálne ide o nasledovné doplnky:

- `_agents` - prídáva `claude`, `codex`, `agy` a `auggie` CLI AI agentov formou [zjednotenej konfigurácie](../docs/ai-agents.md).
- `_agents-specskit` - pridáva [speckit nástroje](https://github.com/github/spec-kit) pre AI agentov.
- `_agents-superpowers` - pridáva [superpowers nástroje](https://github.com/obra/superpowers) pre AI agentov.

Na pridanie doplnku do devcontainer-a v danom projekte je potrebné:

- Skopírovať obsah priečinka doplnku do projektového priečinka.
- Poďľa pokynov `.devcontainers/<nazov-doplnku>.md` > `## Pridanie` zapracovať do existujúcich súborov devcontainera/projektu.

Ak doplnok obsahuje priečinok s názvom niektorého devcontainer-a začínajúci podtržítkom (napr. `_odoo-19`), tak v prípade, že doplnok nahrávaš do korešpondujúceho devcontainer-a (t.j. do `odoo-19`), tak do projektového priečinku nakopíruj ešte aj tento špecifiký obsah doplnku pre danú technológiu (t.j. obsah priečinku `_odoo-19`). Následne môžeš priečinky začínajúce podtržítkom zmazať.
