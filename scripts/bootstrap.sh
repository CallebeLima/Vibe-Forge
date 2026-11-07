#!/usr/bin/env bash
# Instala skills e plugins do kit no projeto atual. Rode na raiz do projeto de destino.
# Antes de rodar, confira a lista em kit.json (skills: frontend-design, webapp-testing, owasp-security,
# supabase*, e plugins: oh-my-claudecode, chrome-devtools-mcp).
set -euo pipefail

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

claude plugin marketplace add CallebeLima/Vibe-Forge
claude plugin install vibe-forge@vibe-forge

echo "Pronto. Rode /skills e /plugin no Claude Code para conferir."
