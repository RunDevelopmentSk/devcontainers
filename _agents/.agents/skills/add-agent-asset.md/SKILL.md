---
name: add-agent-asset
description: >-
  Pridávanie a úprava agentových artefaktov (skills, rules, slash commands,
  subagentov) v súlade s unifikovanou konfiguráciou AI agentov popísanou v
  docs/ai-agents.md. Použi pri "vytvor/uprav skill | rule | command | subagent",
  "pridaj agentový artefakt".
---

# add-agent-asset

Skill na bezpečné pridávanie nových agentových artefaktov tak, aby fungovali
naprieč všetkými agentmi (Augment Code, Claude Code, Antigravity, Codex).
**Zdroj pravdy je `docs/ai-agents.md`** – tento skill je len procedúra a checklist;
detaily formátov a symlinkov needuplikuj, odkazuj naň.

## Kedy použiť

- „vytvor/uprav skill", „pridaj rule", „nový slash command", „nový subagent",
- „pridaj agentový artefakt" / „uprav konfiguráciu agentov".

## 1. Rozhodni typ artefaktu

- **rule** – vždy/často platné guardrails (`.agents/rules/*.md`),
- **skill** – opakovateľný postup/workflow (`.agents/skills/<name>/SKILL.md`),
- **command** – krátky vstupný bod `/name` (`.agents/commands/*.md`),
- **subagent** – izolovaný špecialista s vlastným promptom (`.agents/agents/*`).

Ak nejde o nový typ artefaktu, **nové symlinky netreba** – existujúce v
`docs/ai-agents.md` už zabezpečujú cross-tool discovery.

## 2. Konvencie

- názvy kebab-case (napr. `deploy-staging`, `review-pr`),
- obsah aj `description` **po slovensky**,
- `description` drž stručný a výstižný – pri `agent_requested` / `model_decision`
  podľa neho agent rozhoduje o aktivácii.

## 3. Kuchárka podľa typu

### Rule (`.agents/rules/<name>.md`)
- Kombinovaný frontmatter: `description` + `type:` (Augment:
  `always_apply|agent_requested|manual`) + `trigger:` (Antigravity:
  `always_on|glob|model_decision|manual`). Neznáme kľúče každý agent ignoruje.
- Claude Code a Codex nemajú rules priečinok → ak má `always_apply|always_on` rule platiť aj pre nich,
  pridaj `@.agents/rules/<name>.md` import do `AGENTS.md`.

### Skill (`.agents/skills/<name>/SKILL.md`)
- Adresár + `SKILL.md` s **povinným** frontmatterom `name` a `description`.
- Voliteľne podadresáre `scripts/`, `references/`, `assets/`.
- Žiadna registrácia inde netreba – agenti skills auto-objavujú.

### Command (`.agents/commands/<name>.md`)
- Súbor `<name>.md` → `/name`; podadresár = namespace (`frontend/component.md`
  → `/frontend:component`).
- Frontmatter s poľom `description` (folded scalar, napr. `description: >-`).
- **Codex** slash commands nepodporuje – tam použi priamo zodpovedajúci skill;
  command nech je tenký vstupný bod odkazujúci na skill.

### Subagent (`.agents/agents/`)
- Pridaj **oba** formáty pre toho istého agenta:
  - `<name>.md` (Claude Code, Auggie): YAML frontmatter `name`, `description`,
    voliteľne `color` (Auggie), `tools`, `model` (Claude); telo = systémový prompt,
  - `<name>.toml` (Codex): `name`, `description`, `developer_instructions`
    (systémový prompt), voliteľne `model`, `sandbox_mode`.
- Antigravity súborových subagentov zatiaľ nepodporuje (len `define_subagent`
  za behu) – needituj kvôli nemu nič navyše.

## 4. Synchronizácia dokumentácie a registrov (DoD)

- nový **subagent** → doplň riadok do tabuľky subagentov v `docs/ai-agents.md`,
- nový **always-apply rule** → doplň do zoznamu „Vždy platné prierezové pravidlá"
  v `AGENTS.md` a pridaj `@`-import,
- **nový typ artefaktu/agenta vyžadujúci nový symlink** → doplň riadok do tabuľky
  symlinkov **aj** do `ln -s` bloku v `docs/ai-agents.md`,
- ak vznikol nový command/skill, ktorý je vstupným bodom k inému, prepoj ich
  odkazom (napr. command `/<name>` ↔ skill `<name>`).

## 5. Overovací checklist (cross-tool)

Po vytvorení over, že artefakt uvidí každý relevantný agent:

- **Augment Code** – skills natívne z `.agents/skills`; commands/agents/rules cez
  `.augment/*` symlinky,
- **Claude Code** – cez `.claude/*` symlinky; rules len cez `@`-import v `AGENTS.md`,
- **Antigravity** – `.agents/*` natívne; commands cez symlink `workflows → commands`;
  subagentov zo súborov nečíta,
- **Codex** – `.agents/skills` a `AGENTS.md` natívne; subagentov z `.codex/agents`
  (`.toml`) cez symlink; commands nepodporuje; rules len odvolaním z `AGENTS.md`.

## Súvisiace

- `docs/ai-agents.md` – **zdroj pravdy** o unifikovanej konfigurácii a symlinkoch.
- `.agents/rules/secret-safety.md` – pri artefaktoch nikdy nevkladaj tajomstvá (secrets) – ani do súborov, ani do promptov.
- `.agents/commands/add-agent-asset.md` – párový command `/add-agent-asset` (vstupný bod k tomuto skillu).
