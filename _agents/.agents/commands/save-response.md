---
description: >-
  Doslovne ulož posledný prompt aj odpoveď agenta do .md súboru. Bez argumentu
  sa opýta, či názov vygenerovať sám alebo ho zadá používateľ; názov bez
  priečinka ide do tmp/, s priečinkom ostáva na mieste; chýbajúcu príponu
  doplní a vždy pridá sufix s názvom agenta.
---

# /save-response – ulož posledný prompt aj odpoveď do .md

Spusti postup podľa skillu **`save-response`**
(`.agents/skills/save-response/SKILL.md`). Command a skill majú rovnaký výstup;
tento command je vstupný bod pre Claude Code, Auggie a Antigravity.
(Codex slash commands nepodporuje – tam použi priamo skill `save-response`.)

V skratke (detaily v skille):

1. Zisti sufix agenta (`auggie` / `claude` / `agy` / `codex`).
2. Urči cieľovú cestu:
   - bez argumentu → opýtaj sa používateľa, či názov vygenerovať sám (slug
     `[a-zA-Z0-9\-]`, priečinok `tmp/`) alebo ho zadá používateľ,
   - názov bez priečinka → priečinok `tmp/`,
   - názov s priečinkom → ostáva v danom priečinku,
   - chýbajúca prípona → doplň `.md`.
3. Pred `.md` pridaj sufix `-<agent>` (napr. `my-tax-analyze-auggie.md`).
4. Zapíš **doslovný** (verbatim) posledný prompt aj odpoveď pod tučné hlavičky
   `**Prompt:**` / `**Odpoveď:**`, pričom **každý neprázdny riadok promptu aj
   odpovede odsaď 4 medzery doprava** (vzor:
   `.agents/user-prompts/ai-namespacing-auggie.md`, presný formát v skille); ak
   priečinok chýba, vytvor ho; ak súbor existuje, spýtaj sa na prepis; oznám
   výslednú cestu.

Tvrdé pravidlá: prompt aj odpoveď sú verbatim (jediná úprava je 4-medzerové
odsadenie riadkov), sufix agenta sa pridáva vždy, žiadne tajomstvá do súboru
(`.agents/rules/secret-safety.md`).

Ak používateľ uviedol argument (názov, príp. s priečinkom), zúž postup podľa neho.
