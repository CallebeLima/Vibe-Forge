#!/usr/bin/env bash
# Instala skills e plugins do kit no projeto atual. Rode na raiz do projeto de destino.
# Antes de rodar, confira a lista em kit.json (skills: frontend-design, webapp-testing, owasp-security,
# supabase*, e plugins: oh-my-claudecode, chrome-devtools-mcp).
set -euo pipefail

# Repositórios grandes (ex.: diagram-design) podem passar do timeout padrão de 120s
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
    printf '  \033[38;5;214mSkills, plugins e agentes para o Claude Code, instalados de uma vez.\033[0m\n'
    printf '  \033[38;5;244mhttps://github.com/CallebeLima/Vibe-Forge\033[0m\n'
  else
    echo "  Skills, plugins e agentes para o Claude Code, instalados de uma vez."
    echo "  https://github.com/CallebeLima/Vibe-Forge"
  fi
  echo ""
}

vf_banner

echo "== Skills =="
npx skills add anthropics/skills --skill frontend-design --agent claude-code
npx skills add anthropics/skills --skill webapp-testing --agent claude-code
npx skills add agamm/claude-code-owasp --skill owasp-security --agent claude-code
if [ "${WITH_SUPABASE:-0}" = "1" ]; then
  npx skills add supabase/agent-skills --skill supabase --agent claude-code
  npx skills add supabase/agent-skills --skill supabase-postgres-best-practices --agent claude-code
fi

echo "== Plugins =="
claude plugin marketplace add ChromeDevTools/chrome-devtools-mcp
claude plugin install chrome-devtools-mcp@chrome-devtools-plugins
claude plugin marketplace add "${OMC_MARKETPLACE_REPO:-Yeachan-Heo/oh-my-claudecode}"
claude plugin install oh-my-claudecode@omc

claude plugin marketplace add cathrynlavery/diagram-design && claude plugin install diagram-design@diagram-design \
  || echo "AVISO: diagram-design não foi instalado (veja 'Problemas comuns' no README). Seguindo com o resto."

if [ "${WITH_GRAPHIFY:-0}" = "1" ]; then
  echo "== Graphify (precisa de Python 3.10+) =="
  python3 -m pip install graphifyy
  graphify install --project
fi

claude plugin marketplace add CallebeLima/Vibe-Forge
claude plugin install vibe-forge@vibe-forge

echo "Pronto. Rode /skills e /plugin no Claude Code para conferir."
