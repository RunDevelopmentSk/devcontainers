#!/usr/bin/env bash
# Fan-out orchestrátor pre sub-agenta compare-solutions.
# Spustí viacero CLI agentov (claude/auggie/codex/agy) headless nad rovnakým
# promptom, výstupy uloží do tmp/ (ponecháva ich na kontrolu). auggie beží
# read-only (--ask); claude má navyše WebFetch/WebSearch/Bash a codex beží bez
# interného sandboxu (bypass) – read-only charakter zaisťuje prompt + kontajner.
# Prompt sa claude/codex/auggie odovzdáva SÚBOROM/STDIN (nie cez argv); agy je
# výnimka (jeho CLI nemá file/stdin vstup) – prompt mu ide ako argument cez
# prostredie. Do promptu nikdy nevkladaj tajomstvá – .agents/rules/secret-safety.md.
# Po behu zapíše prehľad do <out-dir>/manifest.tsv (agent, model, status, exit,
# trvanie, riadky) a označí podozrivo krátke výstupy statusom SHORT.
# Do <agent>[_<model>].md ide LEN stdout (čistá analýza na porovnanie); stderr
# smeruje do sidecaru <agent>[_<model>].stderr (prázdny sa zmaže). Pri zlyhaní sa
# do .md pridá chvost stderr, nech je dôvod viditeľný. Codex je výnimka – jeho
# stdout-log (reasoning + tool) je v sidecar <agent>.transcript, v .md len -o správa.
set -uo pipefail

# --- recursion guard: orchestrátor nikdy nesmie spustiť sám seba ---
if [[ "${COMPARE_SOLUTIONS_ACTIVE:-}" == "1" ]]; then
  echo "compare-solutions: rekurzívne spustenie je zakázané (COMPARE_SOLUTIONS_ACTIVE=1)." >&2
  exit 3
fi
export COMPARE_SOLUTIONS_ACTIVE=1

usage() {
  cat >&2 <<'EOF'
Použitie:
  compare-solutions-fanout.sh --prompt-file <súbor> [--out-dir <dir>] [agent[:model] ...]
  compare-solutions-fanout.sh --check [agent[:model] ...]

  --prompt-file   povinné (okrem --check); súbor so zadaním pre subagentov
  --out-dir       voliteľné; default tmp/compare-solutions/<timestamp>
  --check         self-test: over auth + platnosť flagov lacným promptom (bez fan-outu)
  agent[:model]   voliteľné; default "claude auggie" (modely podľa konfigurácie CLI)
                  podporované agenty: claude, auggie, codex, agy
EOF
}

PROMPT_FILE=""; OUT_DIR=""; SPECS=(); CHECK_MODE=""; CHECK_TMP_PROMPT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --prompt-file) PROMPT_FILE="${2:-}"; shift 2;;
    --out-dir) OUT_DIR="${2:-}"; shift 2;;
    --check) CHECK_MODE=1; shift;;
    -h|--help) usage; exit 0;;
    --*) echo "Neznámy prepínač: $1" >&2; usage; exit 2;;
    *) SPECS+=("$1"); shift;;
  esac
done

if [[ "$CHECK_MODE" == "1" ]]; then
  # self-test: lacný prompt (ignoruje --prompt-file), len overenie auth + flagov
  CHECK_TMP_PROMPT="$(mktemp)"; printf 'Odpovedz presne jedným slovom: OK\n' > "$CHECK_TMP_PROMPT"
  PROMPT_FILE="$CHECK_TMP_PROMPT"
  [[ -z "$OUT_DIR" ]] && OUT_DIR="tmp/compare-solutions/check-$(date +%Y%m%d-%H%M%S)"
else
  [[ -z "$PROMPT_FILE" || ! -f "$PROMPT_FILE" ]] && { echo "Chýba platný --prompt-file." >&2; usage; exit 2; }
  [[ -z "$OUT_DIR" ]] && OUT_DIR="tmp/compare-solutions/$(date +%Y%m%d-%H%M%S)"
fi
[[ ${#SPECS[@]} -eq 0 ]] && SPECS=(claude auggie)
mkdir -p "$OUT_DIR"
# vstupný prompt KOPÍRUJEME do out-dir → v <timestamp>/prompt.md je vždy kópia
# zadania a zdrojový súbor sa štandardne nezmaže (nedeštruktívne cp).
# Výnimka – throwaway prompt, ktorý pripravuje orchestrátor
# (tmp/compare-solutions/prompt.md): ten po skopírovaní zmažeme (net efekt = mv),
# aby na vrchnej úrovni tmp/compare-solutions/ nič nezostalo.
# Poistka: ak už PROMPT_FILE JE cieľ (napr. cez --out-dir), kopírovanie preskoč.
THROWAWAY_PROMPT="tmp/compare-solutions/prompt.md"
if [[ "$(readlink -f "$PROMPT_FILE")" != "$(readlink -f "$OUT_DIR/prompt.md")" ]]; then
  cp "$PROMPT_FILE" "$OUT_DIR/prompt.md"
  # len throwaway zdroj zmažeme; vlastný --prompt-file na inej ceste ostane
  if [[ "$(readlink -f "$PROMPT_FILE")" == "$(readlink -f "$THROWAWAY_PROMPT")" ]]; then
    rm -f "$PROMPT_FILE"
  fi
fi
PROMPT_FILE="$OUT_DIR/prompt.md"   # ďalej pracujeme s kópiou v out-dir
printf '%s\n' "${SPECS[@]}" > "$OUT_DIR/specs.txt"

run_agent() {
  local agent="$1" model="$2" out="$3" meta="$4"
  local start ec=0 dur stderr="${out%.md}.stderr"
  start=$(date +%s)
  if ! command -v "$agent" >/dev/null 2>&1; then
    echo "SKIP: '$agent' nie je nainštalovaný/dostupný." > "$out"
    dur=$(( $(date +%s) - start ))
    # placeholder '-' pre prázdny model: tab je pre `read` whitespace a prázdne
    # polia by kolabovali (posun stĺpcov v manifeste)
    printf '%s\t%s\t%s\t%s\n' "$agent" "${model:--}" "SKIP" "$dur" > "$meta"
    return 0
  fi
  case "$agent" in
    claude)
      # nástroje: čítacie (Read/Grep/Glob) + WebFetch/WebSearch/Bash na overovanie;
      # --allowedTools ich predschváli, aby v -p bežali bez interaktívneho promptu.
      # Analýza sa stane finálnou správou, takže -p/text output ju správne zachytí.
      # --permission-mode plan sa NEPOUŽÍVA: v plan móde je finálna správa len stub
      # ("analýza doručená vyššie") a celý obsah sa zahodí.
      # POZN.: tieto --tools sú nástroje SPÚŠŤANÉHO claude subagenta –
      # nesúvisia s `tools:` vo frontmatteri orchestrátora (compare-solutions.md).
      local ctools="Read,Grep,Glob,WebFetch,WebSearch,Bash"
      local a=(--permission-mode default --tools "$ctools" --allowedTools "$ctools")
      [[ -n "$model" ]] && a+=(--model "$model")
      # stdout → .md (analýza), stderr → sidecar; pri zlyhaní chvost stderr do .md
      claude -p "${a[@]}" < "$PROMPT_FILE" > "$out" 2>"$stderr"; ec=$?
      if [[ $ec -ne 0 ]]; then
        [[ -s "$stderr" ]] && tail -n 20 "$stderr" >> "$out"
        echo "[claude zlyhal, exit $ec]" >> "$out"
      fi
      ;;
    auggie)
      # --ask = len retrieval/non-editing nástroje (read-only beh)
      # --allow-indexing = preskoč potvrdenie indexovania; --wait-for-indexing =
      # počkaj na dokončenie indexu pred retrieval (rovnaký kontext ako z konzoly)
      local a=(--print --quiet --ask --allow-indexing --wait-for-indexing)
      [[ -n "$model" ]] && a+=(--model "$model")
      # Prihlásenie: prevezmi uloženú session (`auggie token print`) a odovzdaj ju
      # cez PROSTREDIE (AUGMENT_SESSION_AUTH), nie cez argv – secret-safety.
      # Hodnotu session NIKDY nevypisuj.
      # `auggie token print` vracia viaceriadkový výstup; JSON je na riadku SESSION=<json>.
      # cut -d= -f2- zachová prípadné '=' vo vnútri hodnoty (base64 padding a pod.).
      local sess=""; sess="$(auggie token print 2>/dev/null | grep -m1 '^SESSION=' | cut -d= -f2-)" || sess=""
      # stdout → .md (analýza), stderr → sidecar; pri zlyhaní chvost stderr do .md
      if [[ -n "$sess" ]]; then
        AUGMENT_SESSION_AUTH="$sess" auggie "${a[@]}" --instruction-file "$PROMPT_FILE" > "$out" 2>"$stderr"; ec=$?
        [[ $ec -ne 0 ]] && { [[ -s "$stderr" ]] && tail -n 20 "$stderr" >> "$out"; echo "[auggie zlyhal, exit $ec – over prihlásenie alebo enterprise gating non-interactive režimu]" >> "$out"; }
      else
        auggie "${a[@]}" --instruction-file "$PROMPT_FILE" > "$out" 2>"$stderr"; ec=$?
        [[ $ec -ne 0 ]] && { [[ -s "$stderr" ]] && tail -n 20 "$stderr" >> "$out"; echo "[auggie zlyhal, exit $ec – nepodarilo sa získať session (auggie token print); over prihlásenie]" >> "$out"; }
      fi
      ;;
    codex)
      # Kontext: dev-kontajner je externý sandbox, takže interný sandbox codexu
      # nepotrebujeme (a v kontajneri bez unprivileged userns by bwrap aj tak
      # zlyhal – "No permissions to create new namespace"). Preto beží štandardne
      # cez --dangerously-bypass-approvals-and-sandbox (presne na externé sandboxové
      # prostredia); read-only charakter zaisťuje prompt + externý kontajner.
      # -a/--ask-for-approval bol z codex CLI odstránený (>=0.14x).
      local a=(exec --skip-git-repo-check --dangerously-bypass-approvals-and-sandbox)
      [[ -n "$model" ]] && a+=(-m "$model")
      local last_msg; last_msg="$(mktemp)"
      # transcript (reasoning + tool log) ide do sidecar .transcript; do hlavného
      # .md dávame LEN finálnu správu (-o) → čistý, porovnateľný výstup ako claude -p
      local transcript="${out%.md}.transcript"
      codex "${a[@]}" -o "$last_msg" < "$PROMPT_FILE" > "$transcript" 2>&1; ec=$?
      if [[ -s "$last_msg" ]]; then
        cat "$last_msg" >> "$out"
      fi
      rm -f "$last_msg"
      if [[ $ec -ne 0 ]]; then
        # pri zlyhaní nie je finálna správa → zviditeľni dôvod z transcriptu v .md
        [[ -s "$transcript" ]] && tail -n 20 "$transcript" >> "$out"
        echo "[codex zlyhal, exit $ec]" >> "$out"
      fi
      ;;
    agy)
      # agy CLI nemá vstup promptu súborom ani zo stdin (viď `agy --help`) → prompt
      # aj model idú cez PROSTREDIE (AGY_PROMPT, AGY_MODEL) a v PTY príkaze na ne iba
      # ODKÁŽEME ("$AGY_PROMPT" / "$AGY_MODEL"); do -c reťazca sa nič nevkladá doslova,
      # takže sa žiadny obsah (prompt ani model) nereparsuje shellom (robustné voči
      # úvodzovkám/metaznakom v oboch). Prompt NESMIE obsahovať tajomstvá.
      # agy -p pri non-TTY mlčky zahodí stdout (issue #76) → spúšťame cez PTY (script).
      # PTY zlučuje stdout+stderr agy do typescriptu (→ .md); sidecar .stderr tu drží
      # len chyby samotného `script`. Pri zlyhaní pridáme chvost stderr do .md.
      # --model pridá vnútorný shell len ak je AGY_MODEL neprázdny.
      local agy_cmd='if [ -n "$AGY_MODEL" ]; then agy -p --model "$AGY_MODEL" "$AGY_PROMPT"; else agy -p "$AGY_PROMPT"; fi'
      AGY_MODEL="$model" AGY_PROMPT="$(cat "$PROMPT_FILE")" script -qec "$agy_cmd" /dev/null > "$out" 2>"$stderr"; ec=$?
      if [[ $ec -ne 0 ]]; then
        [[ -s "$stderr" ]] && tail -n 20 "$stderr" >> "$out"
        echo "[agy zlyhal, exit $ec]" >> "$out"
      fi
      [[ -s "$out" ]] || echo "[agy: prázdny výstup – pozri issue #76 (non-TTY stdout)]" >> "$out"
      ;;
    *)
      echo "SKIP: neznámy agent '$agent'." > "$out"
      dur=$(( $(date +%s) - start ))
      printf '%s\t%s\t%s\t%s\n' "$agent" "${model:--}" "SKIP" "$dur" > "$meta"
      return 0
      ;;
  esac
  # prázdny stderr sidecar nenechávaj v out-dir
  [[ -f "$stderr" && ! -s "$stderr" ]] && rm -f "$stderr"
  dur=$(( $(date +%s) - start ))
  printf '%s\t%s\t%s\t%s\n' "$agent" "${model:--}" "$ec" "$dur" > "$meta"
  return 0
}

# --- self-test režim (--check): over auth + platnosť flagov, bez drahého fan-outu ---
if [[ "$CHECK_MODE" == "1" ]]; then
  echo "compare-solutions --check: overujem ${#SPECS[@]} agentov lacným promptom → $OUT_DIR" >&2
  mkdir -p "$OUT_DIR/.meta"
  cpids=(); clabels=()
  for spec in "${SPECS[@]}"; do
    agent="${spec%%:*}"; model=""
    [[ "$spec" == *:* ]] && model="${spec#*:}"
    label="$agent"; [[ -n "$model" ]] && label="${agent}_$(echo "$model" | tr ' /' '__')"
    run_agent "$agent" "$model" "$OUT_DIR/${label}.md" "$OUT_DIR/.meta/${label}.meta" &
    cpids+=("$!"); clabels+=("$label")
  done
  for pid in "${cpids[@]}"; do wait "$pid" || true; done

  echo "" >&2
  crc=0; CHK="$OUT_DIR/check.tsv"
  printf 'agent\tmodel\tstatus\texit\n' > "$CHK"
  for label in "${clabels[@]}"; do
    meta="$OUT_DIR/.meta/${label}.meta"; cout="$OUT_DIR/${label}.md"
    a=""; m=""; e=""; d="0"
    [[ -f "$meta" ]] && IFS=$'\t' read -r a m e d < "$meta"
    [[ "$m" == "-" ]] && m=""
    status="OK"
    if [[ "$e" == "SKIP" ]]; then status="SKIP"
    elif [[ "$e" != "0" || ! -s "$cout" ]]; then status="FAIL"; crc=1; fi
    printf '%s\t%s\t%s\t%s\n' "${a:-?}" "$m" "$status" "${e:-?}" >> "$CHK"
  done
  column -t -s "$(printf '\t')" "$CHK" >&2 2>/dev/null || cat "$CHK" >&2
  [[ -n "$CHECK_TMP_PROMPT" ]] && rm -f "$CHECK_TMP_PROMPT"
  echo "$OUT_DIR"
  exit $crc
fi

echo "compare-solutions: spúšťam ${#SPECS[@]} subagentov, výstup → $OUT_DIR" >&2
mkdir -p "$OUT_DIR/.meta"
PIDS=(); LABELS=()
for spec in "${SPECS[@]}"; do
  agent="${spec%%:*}"; model=""
  [[ "$spec" == *:* ]] && model="${spec#*:}"
  label="$agent"; [[ -n "$model" ]] && label="${agent}_$(echo "$model" | tr ' /' '__')"
  out="$OUT_DIR/${label}.md"
  run_agent "$agent" "$model" "$out" "$OUT_DIR/.meta/${label}.meta" &
  PIDS+=("$!"); LABELS+=("$label")
done

for pid in "${PIDS[@]}"; do wait "$pid" || true; done

# --- agregácia: manifest.tsv + detekcia skrátených výstupov ---
labels=(); ag=(); mo=(); ecf=(); du=(); ln=()
for label in "${LABELS[@]}"; do
  meta="$OUT_DIR/.meta/${label}.meta"; out="$OUT_DIR/${label}.md"
  a=""; m=""; e=""; d="0"
  [[ -f "$meta" ]] && IFS=$'\t' read -r a m e d < "$meta"
  [[ "$m" == "-" ]] && m=""   # spätné premapovanie placeholdera na prázdny model
  l=$(wc -l < "$out" 2>/dev/null || echo 0); l="${l//[^0-9]/}"; l="${l:-0}"
  labels+=("$label"); ag+=("${a:-?}"); mo+=("$m"); ecf+=("${e:-?}"); du+=("${d:-0}"); ln+=("$l")
done

# medián riadkov cez použiteľné výstupy (exit 0) → relatívny prah pre "SHORT"
elig=(); for i in "${!labels[@]}"; do [[ "${ecf[$i]}" == "0" ]] && elig+=("${ln[$i]}"); done
median=0
if [[ ${#elig[@]} -gt 0 ]]; then
  mapfile -t sorted < <(printf '%s\n' "${elig[@]}" | sort -n)
  n=${#sorted[@]}; mid=$((n/2))
  if (( n % 2 == 1 )); then median="${sorted[$mid]}"; else median=$(( (sorted[mid-1] + sorted[mid]) / 2 )); fi
fi
thr=$(( median / 5 ))   # 20 % mediánu

MAN="$OUT_DIR/manifest.tsv"
printf 'agent\tmodel\tstatus\texit\tduration_s\tlines\n' > "$MAN"
rc=0; short_list=""
for i in "${!labels[@]}"; do
  status="OK"
  if [[ "${ecf[$i]}" == "SKIP" ]]; then status="SKIP"
  elif [[ "${ecf[$i]}" != "0" ]]; then status="FAIL"; rc=1
  elif (( ln[i] < 8 )) || { (( median > 0 )) && (( ln[i] < thr )); }; then status="SHORT"; short_list+=" ${ag[$i]}${mo[$i]:+:${mo[$i]}}"
  fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "${ag[$i]}" "${mo[$i]}" "$status" "${ecf[$i]}" "${du[$i]}" "${ln[$i]}" >> "$MAN"
done

echo "" >&2
echo "Hotovo. Čiastkové riešenia (ponechané na kontrolu):" >&2
ls -1 "$OUT_DIR"/*.md >&2 || true
echo "" >&2
echo "Prehľad (manifest.tsv):" >&2
column -t -s "$(printf '\t')" "$MAN" >&2 2>/dev/null || cat "$MAN" >&2
[[ -n "$short_list" ]] && echo "⚠️  Podozrivo krátky výstup (možno sumarizovaný – over ručne):${short_list}" >&2
echo "$OUT_DIR"   # cesta na stdout pre orchestrátora
exit $rc
