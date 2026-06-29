[< Späť](README.md)

# Práca na projekte lokálne v devcontaineri

Aby si mohol pracovať lokálne na projekte v devcontaineri tak urob nasledovné:

- Ak používaš systém Windows:
  - Aby sa existujúce symlinks v projekte správne naklonovali je potrebné mať `git config core.symlinks=true` a používateľ právo `SeCreateSymbolicLinkPrivilege`:
    - Nastaviť `git config --global core.symlinks true` - toto stačí urobiť raz globálne, na začiatku.
    - Zapnúť "Settings" (`Win + I`) > "System" > "Advanced" > "For developers" - toto stačí urobiť raz globálne, na začiatku.
  - v naklonovanom projekte v priečinku `.devcontainer` vytvor súbor `.env` s obsahom `HOME=C:\Users\<my_user>`. Takto pre prostredie devcontainera vytvoríme premennú `HOME`, tak ako existuje na Linuxe a MacOS.

- Nainštaluj si [Docker Desktop](https://docs.docker.com/desktop/). **POZOR:** Nestačí len nainštalovať stiahnuté inštalačky! Podrobne si prečítaj aj nasledovné inštrukcie. **POZOR:** V prípade architektúr postavených na ARM procesoroch (momentálne len MacOS) majú niektoré verzie Dockera problém. V takom prípade treba len googliť ohľadom vzniknutej chyby.

- Nainštaluj si [VS Code](https://code.visualstudio.com/download).

- Vo VS Code si nainštaluj rozšírenia [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) a [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker).

- Otvor projekt vo VS Code. Ak si v konzole v projektovom priečinku, tak stačí spustiť `code .`. Na ďalšie pohodlnejšie čítanie tohto návodu vo VS Code stlač `CTRL SHIFT V`.

- Súc vo VS Code stlač `CTRL SHIFT P` a vyber `Dev Containers: Rebuild Without Cache and Reopen in Container`. Počkaj kým sa VS Code prepne do devcontainera. Ak sa ti zobrazí VS Code upozornenie `Cannot activate the 'XYZ' extension because it depends on the 'Python' extension, which is not loaded. ...`, tak len stlač `Reload Window`. Ide len o to, že niektoré rozšírenia VS Code, už potrebujú mať nainštalované `Python` rozšírenie no a zrejme to tak kvôli súbehu okolností nie je a `Reload Window` to dá do poriadku.

## Úvodné spustenie Odoo a inicializácia databázy

- Súc vo VS Code v devcontaineri spusti v konzole príkaz `odoo`.

- V prehliadači otvor URL http://localhost:50030/. Táto URL je dostupná aj vo VS Code v záložke "Ports" (`CTRL P` > `view ports`) > "drinkcentrum-is-odoo odoo". Pri prvom spustení Odoo sa ti zobrazí konfiguračná obrazovka na nastavenie názvu databázy a prístupu do Odoo:<br><img src="./img/odoo-create-db-screen.png" style="width:400px;"><br>Zadaj si rovnaké prístupy (najmä názov databázy), aby ti projekt fungoval na základe prednastavených hodnôt v [`.devcontainer/config/odoo.conf`](../.devcontainer/config/odoo.conf) a [`.devcontainer/docker-compose.yml`](../.devcontainer/docker-compose.yml). Môžeš vybrať aj konkrétny jazyk a krajinu. Podľa vybranej krajiny sa nastaví napríklad fiškálna lokalizácia (dané, ...). Prípadne si zaškrtni aj natiahnutie demo dat.

- Po úvodnom vytvorení databázy sa ti zobrazí prihlasovacia obrazovka. Ak si zadal horeuvedené prihlasovacie údaje, tak sa prihlásiš pomocou uživateľa `test@run.sk` a hesla `odoo`.

- V zobrazenom zozname applikácií vyhľadaj modul `my_module` a aktivuj ho. Po aktivácii modulu budeš zrejme presmerovaný na obrazovku "Discuss" > "Inbox". Ak sa chceš dostať do nainštalovaného modulu `my_module`, tak klikni vľavo hore na ![Home Menu](./img/odoo-home-menu.png) a zvoľ si v ňom požadovaný modul.

### Viacere databázy

Na vytvorenie ďalšej Odoo databázy použi nasledovný postup:

- Súc vo VS Code v devcontaineri spusti v konzole príkaz `odoo`.
- Otvor si [URL správcu databáz](http://localhost:50030/web/database/manager).
- Klikni na "Create Database" a vytvor novú databázu podľa horeuvedeného návodu. Zmeň len "Database Name" napr. na `odoo_1`.

Pokiaľ sa príkaz `odoo` spustí bez explicitného určenia databázy, tak je možné databazu prepnúť pri prihlasovaní do Odoo.
Pokiaľ sa prikaz `odoo` spustí s explicitným určením databázy (napr. `odoo -d odoo_1`), tak nie je možné pri prihlásení prepnúť databázu.

Viacere databázy sa dajú využiť napr. tak, že v jednej máš natiannuté demo data Odoo a druhá je čistá, pripravená
na nahrávanie produkčných dat. Na spustenie dvoch súčasne bežiacich inštancií Odoo nad rôznymi databázami si otvor bežiacu Odoo aplikáciu v dvôch rôznych prehliadačoch (pípadne použi anonymné okno dané prehliadača) a v každom si zvoľ inú databázu.

### Reset databázy

Ak si popri testovaní rôzných možností zaplietol okolnosti v databáze tak, že by bolo najlepšie začať odznova, tak to sprav nasledovne:

- Otvor si [URL správcu databáz](http://localhost:50030/web/database/manager).
- Klikni na "Delete" a zadaj "Master password" (malo by byť nastavené na `odoo` ak si DB vytvoril podľa horeuvedeného návodu).
- Vytvor databázu odznova podľa horeuvedeného návodu.

### Export a import databázy

Toto je popísané v návode k [spusteniu projektu v produkčnom prostredí cez Docker](prodcontainer-deployment.md).

## Prístup k databáze

Na prácu s databázou sú v devcontaineri pripravené tri možnosti:

- **PgAdmin** - vo VS Code v záložke "Ports" (`CTRL P` > `view ports`) klikni na link "drinkcentrum-is-odoo pgadmin" (port tohto linku sa mení lebo PgAdmin beží ako osobitná služba - viď `docker-compose.yml`). Prístupy na prihlásenie do PgAdmina sú užívateľ `test@run.sk` a heslo `odoo` (viď viď `docker-compose.yml` > `services` > `pgadmin` > `environment`). Pri prvom prihlásení je potrebné pripojiť databázu:
  - Klikni na "Add New Server":<br>![Add New Server](./img/pgadmin-add-new-server.png).
  - Vyplň údaje pripojenia k DB (heslo je `odoo`):<br><img src="./img/pgadmin-register-server-general.png" style="width:400px;"><br><br><img src="./img/pgadmin-register-server-connection.png" style="width:400px;">
- **SQLTools** rozšírenie vo VS Code - v ľavom bočnom menu klikni na ikonu "SQLTools" rozšírenie (![SQLTools](./img/vs-code-sqltools-icon.png)) a pri dostupnom pripojení "Project DB" klikni vpravo na zelenú ikonu zásuvky:<br>![Connect](./img/vs-code-sqltools-connections.png).
- **psql** - na spustenie konzolového nástroja buď spusti vo VS Code v konzole (`CTRL SHIFT T`) príkaz `psql -h db -d odoo -U odoo` a následne zadaj heslo `odoo`. Alebo spusti v konzole príkaz `make db-cli`, ktorý je vlastne aliasom / skratkou k predošlému príkazu (viď `Makefile`). Na rýchle oboznámenie sa s prácou v `psql` si pozri napríklad tento [ťahák](https://quickref.me/postgres.html). Na ukončenie práce s `psql` zadaj `\q`.

## Popis prostredia

Inštalácia Odoo sa nachádza v `/usr/lib/python3/dist-packages/odoo` a do projektového priečinku je nalinkovaná ako `odoo-sources` (symbolický link). Nainštalované Odoo moduly sa nachádzajú v priečinku `odoo-sources/addons`. Základné moduly (`res`, `ir`) sa nachádzajú v priečinku `odoo-sources/addons/base`.

Príkaz `odoo-bin` je v devcontaineri dostupný ako `odoo`. [Popis dostupných parametrov](https://www.odoo.com/documentation/17.0/developer/reference/cli.html) pre tento príkaz.

Konfiguračný súbor je `.devcontainer/config/odoo.conf`.

Nové interné (nami napísané) moduly sa pridávajú do priečinka `extra-addons`. Nové externé (stiahnuté) moduly sa pridávajú do priečinka `vendor-addons`.

### Doinštalovanie Python balíčkov

Na doinštalovanie Python balíčkou pomocou príkazu `pip3` je potrebné zmeniť `.devcontainer/Dockerfile.dev-odoo17` a to nasledovným spôsobom:

- V sekcii `# Install following Python packages:` pridaj potrebné balíčky.
- Znovu-vystavaj Docker obraz podľa inštrukcií v `.devcontainer/Dockerfile.dev-odoo17` > `BUILD & RUN COMMANDS:`.
- Vo VS Code stlač `CTRL SHIFT P` a vyber `Dev Containers: Rebuild Without Cache...`.

Na to, aby sa urobené zmeny efektívne zdieľali s ostatnými, je potrebné nový Docker obraz potlačiť na DockerHub podľa inštrukcií v `.devcontainer/Dockerfile.dev-odoo17` > `PUBLISH ON DOCKERHUB:`.

## Bežná práca

Pri bežnej práci na projekte je postačujúce vo VS Code na prepnutie do devcotainera stlačiť `CTRL SHIFT P` a vybrať `Dev Containers: Reopen in Container`. Počkaj kým sa VS Code prepne do devcontainera.

Prí práci na `my_module` (v databaze `odoo`) vieš použiť nasledovné príkazy:

- **Spustenie Odoo** s tým že sa aktualizuje `my_module` podľa posledncýh zmien: `odoo -d odoo -u my_module`
  - Na aktualizáciu viacerých modulov naraz použi `-u my_module_1,my_module_2`.
  - **Výstup prikazu** sa zapisuje do `/var/log/odoo/odoo.log`. Nastavené je to v súbore `.devcontainer/config/odoo.conf` > `logfile` - ak by sa tento konfig zakomentoval, tak by sa výstup zapisoval priamo do konzoly. Priečinok `/var/log/odoo` je do projektového priečinku nalinkovaný ako `tmp/log`. Inou možnosťou, ako zachytiť výstup do súboru `odoo.log` priamo v projektovom priečinku, je použiť `odoo -d odoo -u my_module > odoo.log 2>&1`.
  - Ak chceš použiť **debugger** tak spusti: `python3 -m debugpy --listen 0.0.0.0:5678 /usr/bin/odoo -d odoo -u my_module` a naslédne stlač `SHIFT F5` (na zastavenie automaticky spusteného debug pripojenia) a potom stlač `F5` (na spustenie debug pripojenia na základe ['.vscode/launch.json`](../.vscode/launch.json)).
  - Prípadne môžeš k uvedeným `odoo` príkazom pripojiť aj [`--dev` parameter](https://www.odoo.com/documentation/17.0/developer/reference/cli.html#cmdoption-odoo-bin-dev)
- Na opätovnú aktualizáciu modulu `my_module` je potrebné stopnúť spustený `odoo` príkaz pomocou `CTRL C` a opäť ho spustiť horeuvedeným spôsobom.

Tieto príkazy nie je potrebné zakaždým zadávať znovu, pretože v devcontaineri je funkčná história príkazov v konzole.

Ak si chceš zobraziť logy bežiaceho `odoo` procesu, tak klikni na "Remote Explorer" (![Remote Explorer](./img/vs-code-remote-explorer-icon.png)) v bočnom menu, v zozname "Dev Containers" výhľadaj kontajner projektu, klikni naň právým tlačítkom myši a v kontextovom menu vyber "Show Container Log".

### Spustenie testov

Testy v `extra-addons/*/tests/` sú Odoo natívne unit testy (`TransactionCase`). Dajú sa spustiť dvoma spôsobmi:

#### Spôsob 1: `odoo --test-enable` (štandardný)

```bash
odoo -d odoo -u my_module --test-enable --stop-after-init --no-http
```

Výsledky testov sa zapisujú do logu (do súboru `tmp/log/odoo.log` v projektovom priečinku). Na ich rýchle vyhľadanie použi regex `(FAIL|ERROR|failed|error\(s\)|odoo\.tests\.result)`.

#### Spôsob 2: `pytest-odoo` (vhodnejší pre TDD)

`pytest-odoo` je nainštalovaný v devcontaineri (cez `requirements.txt`). Oproti `--test-enable` má tieto výhody:

- výstup priamo v konzole (farebný, prehľadný)
- filtrovanie testov cez `-k "názov_testu"` alebo `-m "marker"`
- modul sa upgraduje len raz keď je potrebné, nie pri každom spustení testov

**Postup:**

1. Najprv **upgraduj modul** (len keď sa zmenil kód modulu):

   ```bash
   odoo -d odoo -u my_module --stop-after-init
   ```

2. Spusti **testy cez pytest**:

   ```bash
   pytest --odoo-database=odoo --odoo-config=/etc/odoo/odoo.conf \
       extra-addons/my_module/tests/ -v
   ```

   Príklady filtrovania:

   ```bash
   # Len jeden testovací súbor
   pytest --odoo-database=odoo --odoo-config=/etc/odoo/odoo.conf \
       extra-addons/my_module/tests/test_something.py -v

   # Len testy obsahujúce v názve "avco"
   pytest --odoo-database=odoo --odoo-config=/etc/odoo/odoo.conf \
       extra-addons/my_module/tests/ -k "avco" -v
   ```

> **Poznámka:** `pytest-odoo` vždy spúšťa testy ako `post_install` — preto je potrebné mať modul pred spustením testov aktualizovaný.

### Pripojenie Ventor aplikácie

[Ventor PRO](https://ventor.app/) aplikáciu pripojíš k Odoo bežiacemu na notebooku/počítači nasledovným spôsobom:

- Notebook/počítač a mobil musia byť pripojené k rovnakej lokálnej sieti, t.j. najjednoduchšie k tej istej WiFi sieti.
- Zisti adresu notebooku/počítača v sieti. Napríklad pomocou príkazu (Linux) `hostname -I` v konzole. Bude to adresa typu `192.168.x.x`.
- V mobilnej aplikácii Ventor nastav adresu servera na `http://192.168.x.x:50030` (`x.x` nahraď podľa adresy notebooku/počítača, port je ten istý ako pri pristupe do Odoo z prehliadača na notebooku/počítači).
- Ak by to nešlo, tak skontroluj či nie je aktivovaný firewall na notebooku/počítači:
  - Linux (napríklad Ubuntu): `sudo ufw status` a ak je, tak ho deaktivuj príkazom `sudo ufw disable`

Ventor PRO [quickstart Guide](https://ventor.app/guides/ventor-quick-start-guide/). Testovacie čiarové kódy viď [tu](https://docs.google.com/document/d/1647nlhyQHnsKr95KXTAPdBhIgkO9sh6XzhOr-GMUIaU/edit?usp=sharing).

### Vyhľadávanie

Keďže zdrojové súbory Odoo sú do projektu "len" nalinkované, tak VS Code v nich nevyhľadáva bez toho, aby sa v "SEARCH" paneli nešpecifikovali aj "files to include". Sú nasledovné možnosti pre hodnoty "files to include":

- `./*` - ak chceš vyhľadávať **aj v Odoo zdrojových súboroch**
- `./*/**/*.py` - ak chceš vyhľadávať **len v určitom type súborov** (tu je príklad pre `.py` súbory)
- `./odoo-sources` - ak chceš vyhľadávať **len v Odoo zdrojových súboroch**
- `./odoo-sources/**/*.py` - ak chceš vyhľadávať **len v Odoo zdrojových súboroch** a **len v určitom type súborov** (tu je príklad pre `.py` súbory)

Ak chceš z vyhľadávania vylúčiť všetky súbory, ktoré sú súčasťou testov (aj v Odoo zdrojových súboroch), tak ako "files to exclude" zadaj: `./*/**/tests/`.

Na vyhľadanie modelov, ktoré dedia (rozširujú) daný model, použi regex. Napríklad pre model `res.config.settings` by to bolo: `_inherits?\s*=\s*['"]res.config.settings['"]`.

### Git

Vytvorenie novej vetvy: `git switch -c nova-vetva`.

Zoznam vetiev, ktoré ešte nie sú pripojené do `main` vetvy: `git branch -r --no-merged main`.
