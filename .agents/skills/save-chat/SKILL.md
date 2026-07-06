---
name: save-chat
description: >-
  Doslovne (verbatim) ulož celú históriu chatu – všetky prompty aj odpovede
  agenta – do .md súboru. Bez zadaného názvu sa opýta, či ho vygenerovať sám
  alebo ho zadá používateľ; rieši priečinok (default tmp/), doplní príponu .md
  a vždy pridá sufix s názvom agenta. Použi pri "ulož chat", "ulož celú
  konverzáciu do .md", "save chat".
---

# save-chat

Skill na **doslovné uloženie celej histórie chatu** – všetkých promptov a
odpovedí agenta – do Markdown súboru. Obsah sa ukladá **verbatim** – presne
tak, ako bol napísaný/vypísaný, bez sumarizácie, skracovania či úprav.

## Kedy použiť

- „ulož chat", „ulož celú konverzáciu do .md", „save chat",
- vstupný bod je aj command `/save-chat`.

## Vstup

- Voliteľný argument = špecifikácia cieľového súboru (názov, príp. s priečinkom).
- Ak argument chýba, agent sa **opýta používateľa**, či má názov súboru
  vygenerovať sám, alebo ho zadá používateľ (viď nižšie).

## 1. Zisti identifikátor agenta (sufix)

Sufix = krátky identifikátor bežiaceho agenta/CLI:

| Agent            | Sufix    |
| ---------------- | -------- |
| Auggie           | `auggie` |
| Claude Code      | `claude` |
| Antigravity      | `agy`    |
| Codex            | `codex`  |

## 2. Urči cieľovú cestu (algoritmus)

Postupuj v tomto poradí:

1. **Bez argumentu** → opýtaj sa používateľa, či má agent názov súboru
   vygenerovať sám, alebo ho zadá používateľ:
   - **Agent vygeneruje** → vytvor krátky výstižný názov (slug) z hlavnej témy
     celej konverzácie, iba znaky `[a-zA-Z0-9\-]` (kebab-case, napr.
     `tax-analyze`). Berie sa ako „názov bez priečinka" → cieľový priečinok
     je `tmp/`.
   - **Používateľ zadá** → počkaj na názov (príp. s priečinkom) a pokračuj
     bodom 2 nižšie, akoby to bol pôvodný argument.
2. **S argumentom** → rozdeľ ho na časť s priečinkom a názov súboru:
   - obsahuje `/` (má priečinok) → cieľový priečinok = zadaný priečinok,
   - neobsahuje `/` (len názov) → cieľový priečinok = `tmp/`.
3. **Prípona**: z názvu odstráň koncové `.md`, ak tam je → dostaneš `stem`.
   Ak názov príponu nemal, aj tak pokračuj so `stem` (rovnaký postup); `.md`
   sa doplní až v kroku 5. (Rieši to bod „bez prípony → doplň `.md`".)
4. **Sufix agenta**: k `stem` pridaj `-<sufix>` (napr. `-auggie`). Ak `stem`
   už na `-<sufix>` končí, sufix nezdvojuj.
5. **Finálna cesta** = `<cieľový priečinok>/<stem>-<sufix>.md`.
6. Ak cieľový priečinok neexistuje, vytvor ho.

### Príklady

| Argument                                  | Sufix    | Výsledná cesta                                       |
| ----------------------------------------- | -------- | ---------------------------------------------------- |
| *(žiadny)*                                | `auggie` | `tmp/tax-analyze-auggie.md` (slug vygenerovaný)      |
| `my-chat.md`                              | `auggie` | `tmp/my-chat-auggie.md`                              |
| `my-chat`                                 | `auggie` | `tmp/my-chat-auggie.md`                              |
| `.agents/user-prompts/my-chat.md`         | `auggie` | `.agents/user-prompts/my-chat-auggie.md`             |
| `.agents/user-prompts/my-chat`            | `claude` | `.agents/user-prompts/my-chat-claude.md`             |

## 3. Ulož všetky prompty aj odpovede

Do finálnej cesty zapíš **doslovný** (verbatim) obsah celej konverzácie v
chronologickom poradí. **Pre každý ťah** (prompt používateľa a naň nadväzujúcu
odpoveď agenta) zopakuj rovnaký formát ako nižšie – teda toľko blokov
`**Prompt:**` / `**Odpoveď:**`, koľko bolo v chate ťahov. Prvý riadok súboru je
prázdny, hlavičky sú tučné a **každý neprázdny riadok promptu aj odpovede je
odsadený 4 medzery doprava**:

```

**Prompt:**

    <doslovný text 1. promptu – každý riadok odsadený 4 medzery>

**Odpoveď:**

    <doslovný text 1. odpovede – každý riadok odsadený 4 medzery>

**Prompt:**

    <doslovný text 2. promptu – každý riadok odsadený 4 medzery>

**Odpoveď:**

    <doslovný text 2. odpovede – každý riadok odsadený 4 medzery>
```

- **Uloží sa celá história chatu** – všetky prompty aj odpovede od začiatku
  konverzácie po posledný ťah, v poradí, v akom prebehli.
- Prompty aj odpovede sa zapisujú **doslovne** (Markdown as-is), bez
  sumarizácie, skracovania či úprav – len s pridaným 4-medzerovým odsadením
  na začiatku každého ich neprázdneho riadka (prázdne riadky ostávajú prázdne).
- 4-medzerové odsadenie sa aplikuje na **všetky** riadky obsahu vrátane
  nadpisov, zoznamov, tabuliek a code blokov – aby sa dali vizuálne odlíšiť od
  orientačných hlavičiek `**Prompt:**` a `**Odpoveď:**`.
- Okrem hlavičiek `**Prompt:**` a `**Odpoveď:**` (a prázdnych oddeľovacích
  riadkov) nič iné nepridávaj (žiadny ďalší nadpis, metadáta, komentár).
- Vzor formátu jedného bloku: `.agents/user-prompts/ai-namespacing-auggie.md`.
- Ak súbor už existuje, upozorni používateľa a spýtaj sa, či prepísať.
- Po uložení oznám používateľovi výslednú cestu.

## Tvrdé pravidlá

- Prompty aj odpovede sú **verbatim** – žiadne parafrázovanie ani doplnky
  (jediná povolená úprava je 4-medzerové odsadenie riadkov).
- Uloží sa **celá** história chatu, nie iba posledný ťah.
- Sufix agenta sa pridáva **vždy**.
- Nikdy neukladaj tajomstvá (secrets) do súboru (`.agents/rules/secret-safety.md`).

## Súvisiace

- `.agents/commands/save-chat.md` – párový command `/save-chat`
  (vstupný bod k tomuto skillu).
- `.agents/skills/save-response/SKILL.md` – obdoba pre uloženie iba posledného
  promptu a odpovede.
- `docs/ai-agents.md` – zdroj pravdy o unifikovanej konfigurácii agentov.
- `.agents/rules/secret-safety.md` – žiadne tajomstvá do súborov ani promptov.
