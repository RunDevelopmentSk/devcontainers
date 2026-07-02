---
description: >-
  Vyrieš komplexnú úlohu porovnaním návrhov viacerých CLI subagentov
  (claude/auggie/codex/agy) s rôznymi LLM modelmi a predlož odporúčané riešenie.
  Spúšťa sa len na požiadanie; čiastkové výstupy ostávajú v tmp/ na kontrolu.
---

# /compare-solutions – porovnaj návrhy viacerých subagentov

Tenký vstupný bod – **celý postup, CLI tabuľka aj Output Contract sú v
`.agents/agents/compare-solutions.md`** (needuplikuj ich sem). Command a sub-agent
majú rovnaký výstup; tento command je vstupný bod pre Claude Code, Augment
a Antigravity. (Codex slash commands nepodporuje – tam vyvolaj priamo sub-agenta
`compare-solutions`. Antigravity súborových sub-agentov nečíta – riaď sa obsahom
`.agents/agents/compare-solutions.md`.)

V skratke (detaily v sub-agentovi):

1. Zisti dostupnosť CLI a **over platné model-ID** (`auggie model list`,
   `agy models`; `claude`/`codex` cez `--help`).
2. Navrhni maticu agent × model (**default `claude` a `auggie`**), upozorni na
   násobenie kreditov a **počkaj na potvrdenie** používateľa.
3. Priprav prompt do súboru s **Output Contract** (presné znenie v sub-agentovi)
   a spusti orchestračný skript (`--check` pred fan-outom lacno overí auth/flagy):
   ```bash
   .agents/agents/scripts/compare-solutions-fanout.sh \
     --prompt-file tmp/compare-solutions/prompt.md  claude auggie
   ```
4. Porovnaj a zanalyzuj výstupy; predlož **odporúčané riešenie** (návrh, nie
   vykonanie zmien) a uveď cestu k `tmp/` priečinku s čiastkovými riešeniami.

Tvrdé pravidlá: len na požiadanie (nikdy automaticky), **žiadne rekurzívne
spúšťanie** orchestrátora, subagenti len navrhujú (needitujú repo), tajomstvá
nikdy do promptu ani argv (`.agents/rules/secret-safety.md`).

Ak používateľ uviedol argument (zadanie, ktoré CLI, koľko, aké modely), zúž
postup podľa neho.
