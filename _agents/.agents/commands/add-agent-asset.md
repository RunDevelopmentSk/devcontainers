---
description: >-
  Pridaj nový agentový artefakt (skill, rule, slash command alebo subagent)
  v súlade s unifikovanou konfiguráciou AI agentov (docs/ai-agents.md).
---

# /add-agent-asset – pridaj agentový artefakt

Spusti postup podľa skillu **`add-agent-asset`**
(`.agents/skills/add-agent-asset/SKILL.md`). Command a skill majú rovnaký
výstup; tento command je vstupný bod pre Claude Code, Augment a Antigravity.
(Codex slash commands nepodporuje – tam použi priamo skill `add-agent-asset`.)

Postupuj podľa skillu `add-agent-asset`:

1. Rozhodni typ artefaktu (rule / skill / command / subagent).
2. Vytvor súbor(y) na správnom mieste s povinným frontmatterom podľa
   `docs/ai-agents.md` (zdroj pravdy); rešpektuj konvencie názvov a slovenčinu.
3. Zosynchronizuj dokumentáciu/registre podľa DoD checklistu v skille (tabuľka
   subagentov, zoznam rules v `AGENTS.md`; nové symlinky len pri novom type
   artefaktu).
4. Over cross-tool discovery (Augment / Claude / Antigravity / Codex).

Ak používateľ uviedol argument (typ artefaktu, názov, účel), zúž postup podľa neho.
