# Instala skills e plugins do kit no projeto atual. Rode na raiz do projeto de destino.
# Antes de rodar, confira a lista em kit.json (skills: frontend-design, webapp-testing, owasp-security,
# supabase*, e plugins: oh-my-claudecode, chrome-devtools-mcp).
$ErrorActionPreference = "Stop"

Write-Host "== Skills =="
npx skills add anthropics/skills --skill frontend-design --agent claude-code
npx skills add anthropics/skills --skill webapp-testing --agent claude-code
npx skills add agamm/claude-code-owasp --skill owasp-security --agent claude-code
if ($env:WITH_SUPABASE -eq "1") {
  npx skills add supabase/agent-skills --skill supabase --agent claude-code
  npx skills add supabase/agent-skills --skill supabase-postgres-best-practices --agent claude-code
}

Write-Host "== Plugins =="
claude plugin marketplace add ChromeDevTools/chrome-devtools-mcp
claude plugin install chrome-devtools-mcp@chrome-devtools-plugins
if ($env:OMC_MARKETPLACE_REPO) {
  claude plugin marketplace add $env:OMC_MARKETPLACE_REPO
  claude plugin install oh-my-claudecode@omc
} else {
  Write-Host "AVISO: defina OMC_MARKETPLACE_REPO (owner/repo do marketplace 'omc') para instalar o oh-my-claudecode."
}

Write-Host "Pronto. Rode /skills e /plugin no Claude Code para conferir."
