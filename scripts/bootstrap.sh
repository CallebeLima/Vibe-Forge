#!/usr/bin/env bash
# Vibe Forge installer. Run it from the root of YOUR project folder.
# Steps: 1) pick the core tools  2) pick the recommended extras  3) install.
# Non-interactive: VIBE_FORGE_YES=1 installs the pre-selected items without asking.
# Pre-select optional items: WITH_SUPABASE=1  WITH_GRAPHIFY=1  WITH_NEXTJS=1  WITH_REMOTION=1
set -o pipefail

# Big repositories (e.g. diagram-design) can exceed the default 120s git timeout
export CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS="${CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS:-300000}"

vf_banner() {
  local art=(
    "  ##      ##  ##########  ########    ##########"
    "  ##+     ##+  +++##+++++ ##++++++##  ##+++++++++"
    "  ##+     ##+     ##+     ######## ++ ########"
    "   +##  ## ++     ##+     ##++++++##  ##+++++++"
    "     +## ++   ##########  ######## ++ ##########"
    "       ++      ++++++++++  ++++++++    ++++++++++"
    "  ##########    ######    ########      ########  ##########"
    "  ##+++++++++ ## +++++##  ##++++++##  ## ++++++++ ##+++++++++"
    "  ########    ##+     ##+ ######## ++ ##+   ####  ########"
    "  ##+++++++   ##+     ##+ ##++++##+   ##+    +##+ ##+++++++"
    "  ##+          +###### ++ ##+    +##   +###### ++ ##########"
    "   ++            ++++++    ++      ++    ++++++    ++++++++++"
  )
  # calor de cima para baixo: amarelo -> laranja -> vermelho; sombra em cinza escuro
  local heat=(227 226 220 214 208 208 202 202 196 196 160 160) ash=238
  local L S R="" i j row ch out
  echo ""
  for i in "${!art[@]}"; do
    row="${art[$i]}"; out=""
    if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
      L=$'\033[38;5;'"${heat[$i]:-160}"'m'; S=$'\033[38;5;'"$ash"'m'; R=$'\033[0m'
    else
      L=""; S=""; R=""
    fi
    for ((j = 0; j < ${#row}; j++)); do
      ch="${row:j:1}"
      case "$ch" in
        "#") out+="${L}█${R}" ;;
        "+") out+="${S}░${R}" ;;
        *)   out+=" " ;;
      esac
    done
    printf '%s\n' "$out"
  done
  echo ""
  if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    printf '  \033[38;5;214mSkills, plugins and agents for Claude Code, installed your way.\033[0m\n'
    printf '  \033[38;5;244mhttps://github.com/CallebeLima/Vibe-Forge\033[0m\n'
  else
    echo "  Skills, plugins and agents for Claude Code, installed your way."
    echo "  https://github.com/CallebeLima/Vibe-Forge"
  fi
  echo ""
}

vf_banner

# ---------- prerequisites ----------
MISSING=0
need() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "  Missing: $1 - $2"
    MISSING=1
  fi
}
need claude "install Claude Code: https://docs.claude.com/en/docs/claude-code"
need node   "install Node.js: https://nodejs.org"
need npx    "it comes with Node.js: https://nodejs.org"
need git    "install Git: https://git-scm.com"
if [ "$MISSING" = 1 ]; then
  echo ""
  echo "  Install the items above, open a new terminal and run this again."
  exit 1
fi

# ---------- input (works even when the script is piped from curl) ----------
INTERACTIVE=0
if [ "${VIBE_FORGE_YES:-0}" != "1" ]; then
  if [ -t 0 ]; then
    exec 3<&0
    INTERACTIVE=1
  elif { : </dev/tty; } 2>/dev/null; then
    exec 3</dev/tty
    INTERACTIVE=1
  fi
fi

# ---------- colors ----------
if [ -z "${NO_COLOR:-}" ]; then
  C_G=$'\033[32m'; C_Y=$'\033[33m'; C_C=$'\033[36m'; C_D=$'\033[90m'; C_B=$'\033[1m'; C_0=$'\033[0m'
else
  C_G=""; C_Y=""; C_C=""; C_D=""; C_B=""; C_0=""
fi

# ---------- catalog: id|name|kind|preselected|tag|description|more-link ----------
CORE=(
"omc|oh-my-claudecode|plugin|1|recommended|A team of AI specialists (architect, builder, designer, tester, security reviewer) plus a planning command.|https://github.com/Yeachan-Heo/oh-my-claudecode"
"frontend-design|frontend-design|skill|1|recommended|Helps Claude make deliberate UI design choices instead of generic templates.|https://github.com/anthropics/skills/tree/main/skills/frontend-design"
"webapp-testing|webapp-testing|skill|1|recommended|Lets Claude test your web app with Playwright: click, take screenshots, read logs.|https://github.com/anthropics/skills/tree/main/skills/webapp-testing"
"owasp-security|owasp-security|skill|1|recommended|Security review against the OWASP standard, including risks of AI apps.|https://github.com/agamm/claude-code-owasp"
"chrome-devtools|chrome-devtools-mcp|plugin|1|recommended|Lets Claude inspect your app in a real Chrome: console errors, network, performance.|https://github.com/ChromeDevTools/chrome-devtools-mcp"
"diagram-design|diagram-design|plugin|1|recommended|Draws clean diagrams (architecture, flowcharts, sequences) as HTML/SVG.|https://github.com/cathrynlavery/diagram-design"
"vibe-forge|vibe-forge|plugin|1|recommended|This kit: project rules, safe settings and agent routing (new-project-from-kit).|https://github.com/CallebeLima/Vibe-Forge"
"supabase|supabase + postgres skills|skill|0|if you use Supabase|Auth, row-level security, migrations, Postgres best practices.|https://github.com/supabase/agent-skills"
"graphify|graphify|tool|0|optional|Maps your codebase into a knowledge graph. Needs Python 3.10+ and edits CLAUDE.md and settings.json.|https://github.com/Graphify-Labs/Graphify"
)
EXTRAS=(
"vercel-react|vercel-react-best-practices|skill|0|if you use Next.js / React|Performance rules from Vercel's engineers for React and Next.js code.|https://github.com/vercel-labs/agent-skills"
"web-design|web-design-guidelines|skill|0|if you have a web UI|Audits UI code for accessibility and design rules.|https://github.com/vercel-labs/agent-skills"
"remotion|remotion-best-practices|skill|0|if you use Remotion|Best practices for making videos from React code with Remotion.|https://github.com/remotion-dev/skills"
)

load_menu() {
  M_ID=(); M_NAME=(); M_KIND=(); M_SEL=(); M_TAG=(); M_DESC=(); M_URL=()
  local entry a b c d e f g
  for entry in "$@"; do
    IFS='|' read -r a b c d e f g <<< "$entry"
    M_ID+=("$a"); M_NAME+=("$b"); M_KIND+=("$c"); M_SEL+=("$d"); M_TAG+=("$e"); M_DESC+=("$f"); M_URL+=("$g")
  done
}

preselect() {
  local i
  for ((i = 0; i < ${#M_ID[@]}; i++)); do
    case "${M_ID[$i]}" in
      supabase)     if [ "${WITH_SUPABASE:-0}" = 1 ]; then M_SEL[$i]=1; fi ;;
      graphify)     if [ "${WITH_GRAPHIFY:-0}" = 1 ]; then M_SEL[$i]=1; fi ;;
      vercel-react) if [ "${WITH_NEXTJS:-0}" = 1 ]; then M_SEL[$i]=1; fi ;;
      web-design)   if [ "${WITH_NEXTJS:-0}" = 1 ]; then M_SEL[$i]=1; fi ;;
      remotion)     if [ "${WITH_REMOTION:-0}" = 1 ]; then M_SEL[$i]=1; fi ;;
    esac
  done
}

open_url() {
  case "$(uname -s)" in
    Darwin)               open "$1" >/dev/null 2>&1 ;;
    MINGW*|MSYS*|CYGWIN*) start "" "$1" >/dev/null 2>&1 ;;
    *)                    xdg-open "$1" >/dev/null 2>&1 ;;
  esac
}

trunc() { # text max
  if [ "${#1}" -gt "$2" ]; then printf '%s...' "${1:0:$(($2 - 3))}"; else printf '%s' "$1"; fi
}

# Arrow-key menu. Up/Down move, Enter or Space toggles, "Continue" row (or c) goes on.
run_menu() {
  local title="$1" intro="$2" n=${#M_ID[@]} cur=0 first=1 note="" i key k2 mark tagc cols
  local height=$((2 * n + 9))
  cols=$(tput cols 2>/dev/null || echo 80); [ "$cols" -lt 40 ] && cols=80
  printf '\033[?25l'
  trap 'printf "\033[?25h"' EXIT
  while true; do
    if [ "$first" = 0 ]; then printf '\033[%dA\033[J' "$height"; fi
    first=0
    printf '\n%s== %s ==%s\n%s\n\n' "$C_Y" "$title" "$C_0" "$intro"
    for ((i = 0; i < n; i++)); do
      mark="[ ]"; if [ "${M_SEL[$i]}" = 1 ]; then mark="[x]"; fi
      tagc="$C_Y"; if [ "${M_TAG[$i]}" = recommended ]; then tagc="$C_G"; fi
      if [ "$i" = "$cur" ]; then
        printf '  %s>%s %s%s %d  %s%s (%s)%s  %s[%s]%s\n' "$C_C" "$C_0" "$C_B" "$mark" "$((i + 1))" "${M_NAME[$i]}" "$C_0" "${M_KIND[$i]}" "" "$tagc" "${M_TAG[$i]}" "$C_0"
      else
        printf '    %s %d  %s (%s)  %s[%s]%s\n' "$mark" "$((i + 1))" "${M_NAME[$i]}" "${M_KIND[$i]}" "$tagc" "${M_TAG[$i]}" "$C_0"
      fi
      printf '        %s%s%s\n' "$C_D" "$(trunc "${M_DESC[$i]}" $((cols - 10)))" "$C_0"
    done
    echo ""
    if [ "$cur" = "$n" ]; then printf '  %s> %sContinue%s\n' "$C_C" "$C_B" "$C_0"; else printf '    Continue\n'; fi
    echo ""
    printf '  %s%s%s\n' "$C_D" "$(trunc "Arrows = move  Enter/Space = tick  m = more info  a = all  n = none" $((cols - 4)))" "$C_0"
    printf '  %s%s%s\n' "$C_Y" "$(trunc "$note" $((cols - 4)))" "$C_0"
    note=""
    IFS= read -rsn1 -u 3 key || key=""
    if [ "$key" = $'\033' ]; then read -rsn2 -t 1 -u 3 k2 || k2=""; key="$key$k2"; fi
    case "$key" in
      $'\033[A'|k) cur=$(( (cur + n) % (n + 1) )) ;;
      $'\033[B'|j) cur=$(( (cur + 1) % (n + 1) )) ;;
      ''|' ')
        if [ "$cur" = "$n" ]; then
          if [ -z "$key" ]; then break; fi
        elif [ "${M_SEL[$cur]}" = 1 ]; then M_SEL[$cur]=0; else M_SEL[$cur]=1; fi ;;
      c|C) break ;;
      a|A) for ((i = 0; i < n; i++)); do M_SEL[$i]=1; done ;;
      n|N) for ((i = 0; i < n; i++)); do M_SEL[$i]=0; done ;;
      m|M)
        if [ "$cur" -lt "$n" ]; then
          open_url "${M_URL[$cur]}"
          note="Opened ${M_URL[$cur]}  (if nothing opened, copy this link)"
        fi ;;
    esac
  done
  printf '\033[?25h'
}

PICKED=()
collect() {
  local i
  for ((i = 0; i < ${#M_ID[@]}; i++)); do
    if [ "${M_SEL[$i]}" = 1 ]; then PICKED+=("${M_ID[$i]}|${M_NAME[$i]}|${M_KIND[$i]}"); fi
  done
}

# ---------- step 1: core ----------
load_menu "${CORE[@]}"; preselect
if [ "$INTERACTIVE" = 1 ]; then
  run_menu "Step 1 of 2: choose what to install" "  Items tagged [recommended] are ticked for you. Untick anything you do not want."
fi
collect

# ---------- step 2: recommended extras ----------
load_menu "${EXTRAS[@]}"; preselect
if [ "$INTERACTIVE" = 1 ]; then
  run_menu "Step 2 of 2: extras that depend on your project" "  Each tag says when it is useful. Tick only what matches what you are building."
fi
collect

# ---------- confirm ----------
if [ "${#PICKED[@]}" -eq 0 ]; then
  echo ""
  echo "  Nothing selected. Nothing was installed."
  exit 0
fi
echo ""
echo "== Ready to install =="
for item in "${PICKED[@]}"; do
  IFS='|' read -r _id name kind <<< "$item"
  echo "  - $name ($kind)"
done
if [ "$INTERACTIVE" = 1 ]; then
  echo ""
  printf '  Press Enter to start, or Ctrl+C to cancel. '
  IFS= read -r -u 3 _ignore || true
fi

# ---------- install ----------
FAILED=()
step() {
  local label="$1"; shift
  echo "  > $label"
  if [ "$INTERACTIVE" = 1 ]; then "$@" <&3; else "$@" </dev/null; fi
  if [ $? -ne 0 ]; then
    echo "  ! failed: $label"
    FAILED+=("$label")
    return 1
  fi
  return 0
}
plugin() { # marketplace-repo marketplace-name plugin-name
  step "add marketplace $1" claude plugin marketplace add "$1" \
    && step "install $3@$2" claude plugin install "$3@$2"
}
skill() { # repo skill-name
  step "install skill $2" npx --yes skills add "$1" --skill "$2" --agent claude-code
}
graphify_install() {
  local py=""
  if command -v python3 >/dev/null 2>&1; then py=python3; elif command -v python >/dev/null 2>&1; then py=python; fi
  if [ -z "$py" ]; then
    echo "  ! graphify needs Python 3.10+ (https://python.org). Install it and run this again."
    FAILED+=("graphify (Python not found)")
    return 1
  fi
  step "install graphify package" "$py" -m pip install graphifyy \
    && step "set up graphify in this project" graphify install --project
}

echo ""
echo "== Installing =="
for item in "${PICKED[@]}"; do
  IFS='|' read -r id _name _kind <<< "$item"
  case "$id" in
    omc)             plugin "${OMC_MARKETPLACE_REPO:-Yeachan-Heo/oh-my-claudecode}" omc oh-my-claudecode ;;
    frontend-design) skill anthropics/skills frontend-design ;;
    webapp-testing)  skill anthropics/skills webapp-testing ;;
    owasp-security)  skill agamm/claude-code-owasp owasp-security ;;
    chrome-devtools) plugin ChromeDevTools/chrome-devtools-mcp chrome-devtools-plugins chrome-devtools-mcp ;;
    diagram-design)  plugin cathrynlavery/diagram-design diagram-design diagram-design ;;
    vibe-forge)      plugin CallebeLima/Vibe-Forge vibe-forge vibe-forge ;;
    supabase)        skill supabase/agent-skills supabase; skill supabase/agent-skills supabase-postgres-best-practices ;;
    graphify)        graphify_install ;;
    vercel-react)    skill vercel-labs/agent-skills vercel-react-best-practices ;;
    web-design)      skill vercel-labs/agent-skills web-design-guidelines ;;
    remotion)        skill remotion-dev/skills remotion-best-practices ;;
  esac
done

echo ""
if [ "${#FAILED[@]}" -gt 0 ]; then
  echo "== Finished with problems =="
  for f in "${FAILED[@]}"; do echo "  ! $f"; done
  echo "  See 'Common problems' in the README: https://github.com/CallebeLima/Vibe-Forge#readme"
else
  echo "== Done =="
fi
echo ""
echo "  Next: restart Claude Code in this folder, then ask:"
echo "    Use new-project-from-kit to set up this project"
echo ""
