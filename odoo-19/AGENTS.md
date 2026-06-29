---
type: always_apply
trigger: always_on
---

# Project Agent Instructions

Tento súbor je **single source of truth** pre všetkých AI agentov v projekte
(Augment Code, Claude Code, Antigravity, Codex). Augment Code, Antigravity
a Codex ho čítajú natívne; Claude Code ho číta cez symlink `CLAUDE.md → AGENTS.md`.

Detaily konfigurácie jednotlivých agentov a unifikovanej štruktúry sú v
[`docs/ai-agents.md`](docs/ai-agents.md).

Pred prácou si pozri:

- `.agents/rules/*.md` – modulárne workspace pravidlá

## Všeobecný popis

Aktuálny projekt je postavený na komunitnej verzii Odoo 19.0-20251222. Funkčný kód je umiestnený v adresaroch `extra-addons` a `vendor-addons`. V adresari `odoo-sources` sú zdrojové kódy Odoo 19 CE - `odoo-sources` je symbolický link na `/usr/lib/python3/dist-packages/odoo` kde sa zdrojové kódy skutočne nachádzajú.

Ide o projekt <@todo>.

Hlavnou stratégiou pri vývoji je vyhnuť sa programovaniu, pokiaľ je to možné a namiesto programovania použiť existujúce Odoo moduly a ich konfiguráciu. Tam, kde toto nie je možné, sa požadovaná funkcionalita pridáva buď formou vlastného alebo vendor modulu.

## Moduly

### Vlastné moduly

V priečinku `extra-addons` sú podpriečinky nasledovných vlastných modulov:

- <@todo>

Väčšina vlastných modulov len obsahuje rozšírenia existujúcich Odoo modulov.
S postupom vývoja budú v priečinku `extra-addons` pridávane ďalšie moduly.

### Vendor moduly

V priečinku `vendor-addons` sú podpriečinky nasledovných vendor modulov:

- <@todo>

S postupom vývoja budú v priečinku `vendor-addons` pridávane ďalšie moduly.

## Rôzne

### Spustenie Odoo

Na spustenie Odoo sa použiva príkaz `odoo`. Na aktualizáciu daného modulu sa pridá parameter `-u`, napr. `odoo -u my_module`. Ak je viacero databáz a chceme spustiť alebo aktualizovať konkrétnu databázu, tak sa pridá parameter `-d`, napr. `odoo -d my_database`.
Avšak Odoo nespúšťaj ani neaktualizuj automaticky, len upozorni, že to treba urobiť ručne.

Skratky cez `Makefile`: `make odoo`, `make odoo-debug`, `make odoo-shell`, `make db-cli`. Pozri `make help`.

### Dokumentácia

Dokumentácia je v priečinku `docs`:

- `docs/development-in-devcontainer.md` - Informácie ohľadom vývoja a práce na projekte v devcontaineri.

Pri dopĺňaní dokumentácie je potrebné dbať na to, aby dokumentácia zapracovanej fukcionality bola stručná, vecná a pravdivá.

### Skúmanie štruktúry a údajov v PostgreSQL databáze pri vývoji

Na zistenie aktuálnej štruktúry `odoo` databázy a/alebo obsahu tabuliek v nej sa použije konzolový príkaz `psql`:

```bash
PGPASSWORD=odoo psql -h db -U odoo -d odoo -c "\dt"
PGPASSWORD=odoo psql -h db -U odoo -d odoo -c "\d res_users"
PGPASSWORD=odoo psql -h db -U odoo -d odoo -c "SELECT * FROM res_users"
```

Pozri aj skill `.agents/skills/psql-inspect/` pre ďalšie príklady.

### Logy

Odoo logy sú v `/var/log/odoo/odoo.log`. Priečinok `/var/log/odoo` je do projektového priečinku nalinkovaný ako `tmp/log`
