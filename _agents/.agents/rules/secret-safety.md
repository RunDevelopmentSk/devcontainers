---
description: >-
  Bezpečná práca s tajomstvami (API kľúče, tokeny, heslá, súkromné kľúče) –
  nikdy ich nevypisovať do výstupu, logov, argv ani tiketov; čítať len
  z prostredia / secret managera. Platí pre všetkých agentov a skills.
type: always_apply
trigger: always_on
---

# Pravidlo: bezpečná práca s tajomstvami

Platí pre všetkých agentov a všetky skills v tomto workspace.

## Čo je tajomstvo

- API kľúče, tokeny (OAuth/bearer), cookies, heslá, súkromné kľúče, podpisové
  tajomstvá, credential/session súbory a hodnoty zo secret managera.
- Akékoľvek hodnoty z `.env` súborov alebo z prostredia procesu.

## Pravidlá

- Tajomstvá sa **čítajú výhradne z prostredia** (napr. `.env` súbor / secret
  manager), nikdy sa nehardkódujú do skriptov ani dokumentácie.
- **Nikdy** nevypisuj hodnotu tajomstva do odpovede, logov, chybových hlások,
  argumentov príkazov, URL, názvov súborov ani do tiketov.
- Tajomstvá neodovzdávaj cez argumenty príkazového riadku (`argv`) – posielaj ich
  cez prostredie procesu; skripty ich čítajú z env, nie z parametrov.
- Pri hľadaní/grepe potenciálnych tajomstiev nevypisuj nájdené hodnoty – uveď len
  názov súboru, počet výskytov alebo stav „nájdené / nenájdené".
- Ak sa tajomstvo objaví v predchádzajúcom kontexte alebo výstupe nástroja,
  neopakuj ho – odkáž naň ako na „redacted".
