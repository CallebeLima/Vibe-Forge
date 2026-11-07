# Instala skills e plugins do kit no projeto atual. Rode na raiz do projeto de destino.
# Antes de rodar, confira a lista em kit.json (skills: frontend-design, webapp-testing, owasp-security,
# supabase*, e plugins: oh-my-claudecode, chrome-devtools-mcp).
$ErrorActionPreference = "Stop"

# Repositórios grandes (ex.: diagram-design) podem passar do timeout padrão de 120s
if (-not $env:CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS) { $env:CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS = "300000" }

$vfArt = @(
  "  ##      ##  ##########  ########    ##########",
  "  ##+     ##+  +++##+++++ ##++++++##  ##+++++++++",
  "  ##+     ##+     ##+     ######## ++ ########",
  "   +##  ## ++     ##+     ##++++++##  ##+++++++",
  "     +## ++   ##########  ######## ++ ##########",
  "       ++      ++++++++++  ++++++++    ++++++++++",
  "  ##########    ######    ########      ########  ##########",
  "  ##+++++++++ ## +++++##  ##++++++##  ## ++++++++ ##+++++++++",
  "  ########    ##+     ##+ ######## ++ ##+   ####  ########",
  "  ##+++++++   ##+     ##+ ##++++##+   ##+    +##+ ##+++++++",
  "  ##+          +###### ++ ##+    +##   +###### ++ ##########",
  "   ++            ++++++    ++      ++    ++++++    ++++++++++"
)
# calor de cima para baixo: amarelo -> laranja -> vermelho; sombra em cinza
$vfHeat = @("Yellow", "Yellow", "Yellow", "DarkYellow", "DarkYellow", "DarkYellow", "Red", "Red", "Red", "Red", "DarkRed", "DarkRed")
$vfBlock = [string][char]0x2588
$vfShade = [string][char]0x2591
Write-Host ""
for ($i = 0; $i -lt $vfArt.Count; $i++) {
  $row = $vfArt[$i]
  for ($j = 0; $j -lt $row.Length; $j++) {
    switch ($row[$j]) {
      "#" { Write-Host -NoNewline $vfBlock -ForegroundColor $vfHeat[$i] }
      "+" { Write-Host -NoNewline $vfShade -ForegroundColor DarkGray }
      default { Write-Host -NoNewline " " }
    }
  }
  Write-Host ""
}
Write-Host ""
Write-Host "  Skills, plugins e agentes para o Claude Code, instalados de uma vez." -ForegroundColor Yellow
Write-Host "  https://github.com/CallebeLima/Vibe-Forge" -ForegroundColor DarkGray
Write-Host ""

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
$omc = if ($env:OMC_MARKETPLACE_REPO) { $env:OMC_MARKETPLACE_REPO } else { "Yeachan-Heo/oh-my-claudecode" }
claude plugin marketplace add $omc
claude plugin install oh-my-claudecode@omc

claude plugin marketplace add cathrynlavery/diagram-design
if ($LASTEXITCODE -eq 0) { claude plugin install diagram-design@diagram-design }
if ($LASTEXITCODE -ne 0) { Write-Host "AVISO: diagram-design não foi instalado (veja 'Problemas comuns' no README). Seguindo com o resto." }

if ($env:WITH_GRAPHIFY -eq "1") {
  Write-Host "== Graphify (precisa de Python 3.10+) =="
  python -m pip install graphifyy
  graphify install --project
}

claude plugin marketplace add CallebeLima/Vibe-Forge
claude plugin install vibe-forge@vibe-forge

Write-Host "Pronto. Rode /skills e /plugin no Claude Code para conferir."
