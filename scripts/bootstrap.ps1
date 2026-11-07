# Vibe Forge installer (PowerShell). Run it from the root of YOUR project folder.
# Steps: 1) pick the core tools  2) pick the recommended extras  3) install.
# Non-interactive: $env:VIBE_FORGE_YES = "1" installs the pre-selected items without asking.
# Pre-select optional items: WITH_SUPABASE, WITH_GRAPHIFY, WITH_NEXTJS, WITH_REMOTION = "1"
$ErrorActionPreference = "Continue"

# Big repositories (e.g. diagram-design) can exceed the default 120s git timeout
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
Write-Host "  Skills, plugins and agents for Claude Code, installed your way." -ForegroundColor Yellow
Write-Host "  https://github.com/CallebeLima/Vibe-Forge" -ForegroundColor DarkGray
Write-Host ""

# ---------- prerequisites ----------
$missing = $false
foreach ($req in @(
    @("claude", "install Claude Code: https://docs.claude.com/en/docs/claude-code"),
    @("node",   "install Node.js: https://nodejs.org"),
    @("npx",    "it comes with Node.js: https://nodejs.org"),
    @("git",    "install Git: https://git-scm.com"))) {
  if (-not (Get-Command $req[0] -ErrorAction SilentlyContinue)) {
    Write-Host "  Missing: $($req[0]) - $($req[1])" -ForegroundColor Red
    $missing = $true
  }
}
if ($missing) {
  Write-Host ""
  Write-Host "  Install the items above, open a new terminal and run this again."
  return
}

$interactive = ($env:VIBE_FORGE_YES -ne "1")

# ---------- catalog ----------
function Item($id, $name, $kind, $sel, $desc, $url) {
  [pscustomobject]@{ Id = $id; Name = $name; Kind = $kind; Sel = [bool]$sel; Desc = $desc; Url = $url }
}
$core = @(
  (Item "omc" "oh-my-claudecode" "plugin" $true "A team of AI specialists (architect, builder, designer, tester, security reviewer) plus a planning command." "https://github.com/Yeachan-Heo/oh-my-claudecode"),
  (Item "frontend-design" "frontend-design" "skill" $true "Helps Claude make deliberate UI design choices instead of generic templates." "https://github.com/anthropics/skills/tree/main/skills/frontend-design"),
  (Item "webapp-testing" "webapp-testing" "skill" $true "Lets Claude test your web app with Playwright: click, take screenshots, read logs." "https://github.com/anthropics/skills/tree/main/skills/webapp-testing"),
  (Item "owasp-security" "owasp-security" "skill" $true "Security review against the OWASP standard, including risks of AI apps." "https://github.com/agamm/claude-code-owasp"),
  (Item "chrome-devtools" "chrome-devtools-mcp" "plugin" $true "Lets Claude inspect your app in a real Chrome: console errors, network, performance." "https://github.com/ChromeDevTools/chrome-devtools-mcp"),
  (Item "diagram-design" "diagram-design" "plugin" $true "Draws clean diagrams (architecture, flowcharts, sequences) as HTML/SVG." "https://github.com/cathrynlavery/diagram-design"),
  (Item "vibe-forge" "vibe-forge" "plugin" $true "This kit: project rules, safe settings and agent routing (new-project-from-kit)." "https://github.com/CallebeLima/Vibe-Forge"),
  (Item "supabase" "supabase + postgres skills" "skill" ($env:WITH_SUPABASE -eq "1") "Only if you use Supabase: auth, row-level security, migrations, Postgres best practices." "https://github.com/supabase/agent-skills"),
  (Item "graphify" "graphify" "tool" ($env:WITH_GRAPHIFY -eq "1") "Maps your codebase into a knowledge graph. Needs Python 3.10+ and edits CLAUDE.md and settings.json." "https://github.com/Graphify-Labs/Graphify")
)
$next = ($env:WITH_NEXTJS -eq "1")
$extras = @(
  (Item "vercel-react" "vercel-react-best-practices" "skill" $next "Pick this if your project uses Next.js or React: performance rules from Vercel's engineers." "https://github.com/vercel-labs/agent-skills"),
  (Item "web-design" "web-design-guidelines" "skill" $next "Pick this if your project has a web interface: audits UI code for accessibility and design rules." "https://github.com/vercel-labs/agent-skills"),
  (Item "remotion" "remotion-best-practices" "skill" ($env:WITH_REMOTION -eq "1") "Pick this only if you make videos with Remotion (videos built from React code)." "https://github.com/remotion-dev/skills")
)

function Show-Menu($title, $intro, $items) {
  while ($true) {
    Write-Host ""
    Write-Host "== $title ==" -ForegroundColor Yellow
    Write-Host $intro
    Write-Host ""
    for ($i = 0; $i -lt $items.Count; $i++) {
      $mark = if ($items[$i].Sel) { "[x]" } else { "[ ]" }
      $color = if ($items[$i].Sel) { "Green" } else { "Gray" }
      Write-Host ("  {0} {1}  {2} ({3})" -f $mark, ($i + 1), $items[$i].Name, $items[$i].Kind) -ForegroundColor $color
      Write-Host ("        {0}" -f $items[$i].Desc) -ForegroundColor DarkGray
    }
    Write-Host ""
    Write-Host "  Toggle: type numbers (e.g. 1 3)   a = all   n = none   m 2 = read more about #2   Enter = continue"
    $line = Read-Host "  >"
    if ([string]::IsNullOrWhiteSpace($line)) { break }
    $tok = @($line.Trim() -split "\s+")
    switch -Regex ($tok[0]) {
      "^[aA]$" { foreach ($it in $items) { $it.Sel = $true } }
      "^[nN]$" { foreach ($it in $items) { $it.Sel = $false } }
      "^[mM]$" {
        $num = 0
        if ($tok.Count -gt 1 -and [int]::TryParse($tok[1], [ref]$num) -and $num -ge 1 -and $num -le $items.Count) {
          Write-Host "  Opening $($items[$num - 1].Url)"
          try { Start-Process $items[$num - 1].Url } catch { Write-Host "  Could not open the browser. Open this link yourself: $($items[$num - 1].Url)" }
        } else {
          Write-Host "  Type m followed by an item number, e.g. m 2"
        }
      }
      default {
        foreach ($t in $tok) {
          $n = 0
          if ([int]::TryParse($t, [ref]$n) -and $n -ge 1 -and $n -le $items.Count) {
            $items[$n - 1].Sel = -not $items[$n - 1].Sel
          } else { Write-Host "  Ignored: $t" }
        }
      }
    }
  }
}

if ($interactive) {
  Show-Menu "Step 1 of 2: choose what to install" "  Items marked [x] are recommended for most projects. Untick what you do not need." $core
  Show-Menu "Step 2 of 2: recommended extras (depend on your project)" "  Not needed by every project. Tick only what matches what you are building." $extras
}
$picked = @($core + $extras | Where-Object { $_.Sel })

# ---------- confirm ----------
if ($picked.Count -eq 0) {
  Write-Host ""
  Write-Host "  Nothing selected. Nothing was installed."
  return
}
Write-Host ""
Write-Host "== Ready to install ==" -ForegroundColor Yellow
foreach ($p in $picked) { Write-Host "  - $($p.Name) ($($p.Kind))" }
if ($interactive) {
  Write-Host ""
  Read-Host "  Press Enter to start, or Ctrl+C to cancel" | Out-Null
}

# ---------- install ----------
$failed = New-Object System.Collections.ArrayList
function Step($label, [scriptblock]$cmd) {
  Write-Host "  > $label"
  $global:LASTEXITCODE = 0
  & $cmd | Out-Host
  if ($LASTEXITCODE -ne 0) {
    Write-Host "  ! failed: $label" -ForegroundColor Red
    [void]$failed.Add($label)
    return $false
  }
  return $true
}
function Install-Plugin($repo, $mkt, $plugin) {
  if (Step "add marketplace $repo" { claude plugin marketplace add $repo }) {
    [void](Step "install $plugin@$mkt" { claude plugin install "$plugin@$mkt" })
  }
}
function Install-Skill($repo, $skill) {
  [void](Step "install skill $skill" { npx --yes skills add $repo --skill $skill --agent claude-code })
}
function Install-Graphify {
  $py = $null
  foreach ($c in @("python", "py", "python3")) { if (Get-Command $c -ErrorAction SilentlyContinue) { $py = $c; break } }
  if (-not $py) {
    Write-Host "  ! graphify needs Python 3.10+ (https://python.org). Install it and run this again." -ForegroundColor Red
    [void]$failed.Add("graphify (Python not found)")
    return
  }
  if (Step "install graphify package" { & $py -m pip install graphifyy }) {
    [void](Step "set up graphify in this project" { graphify install --project })
  }
}

Write-Host ""
Write-Host "== Installing ==" -ForegroundColor Yellow
$omcRepo = if ($env:OMC_MARKETPLACE_REPO) { $env:OMC_MARKETPLACE_REPO } else { "Yeachan-Heo/oh-my-claudecode" }
foreach ($p in $picked) {
  switch ($p.Id) {
    "omc"             { Install-Plugin $omcRepo "omc" "oh-my-claudecode" }
    "frontend-design" { Install-Skill "anthropics/skills" "frontend-design" }
    "webapp-testing"  { Install-Skill "anthropics/skills" "webapp-testing" }
    "owasp-security"  { Install-Skill "agamm/claude-code-owasp" "owasp-security" }
    "chrome-devtools" { Install-Plugin "ChromeDevTools/chrome-devtools-mcp" "chrome-devtools-plugins" "chrome-devtools-mcp" }
    "diagram-design"  { Install-Plugin "cathrynlavery/diagram-design" "diagram-design" "diagram-design" }
    "vibe-forge"      { Install-Plugin "CallebeLima/Vibe-Forge" "vibe-forge" "vibe-forge" }
    "supabase"        { Install-Skill "supabase/agent-skills" "supabase"; Install-Skill "supabase/agent-skills" "supabase-postgres-best-practices" }
    "graphify"        { Install-Graphify }
    "vercel-react"    { Install-Skill "vercel-labs/agent-skills" "vercel-react-best-practices" }
    "web-design"      { Install-Skill "vercel-labs/agent-skills" "web-design-guidelines" }
    "remotion"        { Install-Skill "remotion-dev/skills" "remotion-best-practices" }
  }
}

Write-Host ""
if ($failed.Count -gt 0) {
  Write-Host "== Finished with problems ==" -ForegroundColor Red
  foreach ($f in $failed) { Write-Host "  ! $f" -ForegroundColor Red }
  Write-Host "  See 'Common problems' in the README: https://github.com/CallebeLima/Vibe-Forge#readme"
} else {
  Write-Host "== Done ==" -ForegroundColor Green
}
Write-Host ""
Write-Host "  Next: restart Claude Code in this folder, then ask:"
Write-Host "    Use new-project-from-kit to set up this project"
Write-Host ""
