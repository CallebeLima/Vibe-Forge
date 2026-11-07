# Vibe Forge installer (PowerShell). Run it from the root of YOUR project folder.
# Steps: 1) pick the core tools  2) pick the recommended extras  3) install.
# Non-interactive: $env:VIBE_FORGE_YES = "1" installs the pre-selected items without asking.
# Pre-select optional items: WITH_SUPABASE, WITH_GRAPHIFY, WITH_NEXTJS, WITH_REMOTION = "1"
$ErrorActionPreference = "Continue"

# Show UTF-8 output from claude/npx correctly (otherwise symbols turn into garbled characters on Windows)
$vfOldEnc = [Console]::OutputEncoding
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
function Restore-Enc { try { [Console]::OutputEncoding = $vfOldEnc } catch {} }

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
  Restore-Enc
  return
}

$interactive = ($env:VIBE_FORGE_YES -ne "1")

# ---------- catalog ----------
function Item($id, $name, $kind, $sel, $tag, $desc, $url) {
  [pscustomobject]@{ Id = $id; Name = $name; Kind = $kind; Sel = [bool]$sel; Tag = $tag; Desc = $desc; Url = $url }
}
$core = @(
  (Item "omc" "oh-my-claudecode" "plugin" $true "recommended" "A team of AI specialists (architect, builder, designer, tester, security reviewer) plus a planning command." "https://github.com/Yeachan-Heo/oh-my-claudecode"),
  (Item "frontend-design" "frontend-design" "skill" $true "recommended" "Helps Claude make deliberate UI design choices instead of generic templates." "https://github.com/anthropics/skills/tree/main/skills/frontend-design"),
  (Item "webapp-testing" "webapp-testing" "skill" $true "recommended" "Lets Claude test your web app with Playwright: click, take screenshots, read logs." "https://github.com/anthropics/skills/tree/main/skills/webapp-testing"),
  (Item "owasp-security" "owasp-security" "skill" $true "recommended" "Security review against the OWASP standard, including risks of AI apps." "https://github.com/agamm/claude-code-owasp"),
  (Item "chrome-devtools" "chrome-devtools-mcp" "plugin" $true "recommended" "Lets Claude inspect your app in a real Chrome: console errors, network, performance." "https://github.com/ChromeDevTools/chrome-devtools-mcp"),
  (Item "diagram-design" "diagram-design" "plugin" $true "recommended" "Draws clean diagrams (architecture, flowcharts, sequences) as HTML/SVG." "https://github.com/cathrynlavery/diagram-design"),
  (Item "vibe-forge" "vibe-forge" "plugin" $true "recommended" "This kit: project rules, safe settings and agent routing (new-project-from-kit)." "https://github.com/CallebeLima/Vibe-Forge"),
  (Item "supabase" "supabase + postgres skills" "skill" ($env:WITH_SUPABASE -eq "1") "if you use Supabase" "Auth, row-level security, migrations, Postgres best practices." "https://github.com/supabase/agent-skills"),
  (Item "graphify" "graphify" "tool" ($env:WITH_GRAPHIFY -eq "1") "optional" "Maps your codebase into a knowledge graph. Needs Python 3.10+ and edits CLAUDE.md and settings.json." "https://github.com/Graphify-Labs/Graphify")
)
$next = ($env:WITH_NEXTJS -eq "1")
$extras = @(
  (Item "vercel-react" "vercel-react-best-practices" "skill" $next "if you use Next.js / React" "Performance rules from Vercel's engineers for React and Next.js code." "https://github.com/vercel-labs/agent-skills"),
  (Item "web-design" "web-design-guidelines" "skill" $next "if you have a web UI" "Audits UI code for accessibility and design rules." "https://github.com/vercel-labs/agent-skills"),
  (Item "remotion" "remotion-best-practices" "skill" ($env:WITH_REMOTION -eq "1") "if you use Remotion" "Best practices for making videos from React code with Remotion." "https://github.com/remotion-dev/skills")
)

# Writes one padded line made of colored segments: @(@("text","Color"), ...)
function Write-Segs($segs, $width) {
  $len = 0
  foreach ($s in $segs) {
    $t = $s[0]
    if ($len + $t.Length -gt $width) { $t = $t.Substring(0, [Math]::Max(0, $width - $len)) }
    Write-Host $t -NoNewline -ForegroundColor $s[1]
    $len += $t.Length
  }
  Write-Host (" " * [Math]::Max(0, $width - $len))
}

# Arrow-key menu: Up/Down move, Enter or Space toggles, "Continue" row goes on.
function Show-Menu($title, $intro, $items) {
  $n = $items.Count; $cur = 0; $note = ""
  $h = 2 * $n + 9
  $w = [Math]::Max(40, [Console]::WindowWidth - 1)
  for ($k = 0; $k -lt $h; $k++) { Write-Host "" }
  $top = [Math]::Max(0, [Console]::CursorTop - $h)
  $oldCursor = $true
  try { $oldCursor = [Console]::CursorVisible; [Console]::CursorVisible = $false } catch {}
  try {
    while ($true) {
      [Console]::SetCursorPosition(0, $top)
      Write-Segs @() $w
      Write-Segs @(, @("== $title ==", "Yellow")) $w
      Write-Segs @(, @($intro, "Gray")) $w
      Write-Segs @() $w
      for ($i = 0; $i -lt $n; $i++) {
        $it = $items[$i]
        $mark = if ($it.Sel) { "[x]" } else { "[ ]" }
        $arrow = if ($i -eq $cur) { "  > " } else { "    " }
        $nameColor = if ($it.Sel) { "Green" } else { "White" }
        $tagColor = if ($it.Tag -eq "recommended") { "Green" } else { "Yellow" }
        Write-Segs @(
          @($arrow, "Cyan"),
          @(("{0} {1}  {2} ({3})  " -f $mark, ($i + 1), $it.Name, $it.Kind), $nameColor),
          @("[$($it.Tag)]", $tagColor)) $w
        Write-Segs @(, @(("        " + $it.Desc), "DarkGray")) $w
      }
      Write-Segs @() $w
      $contArrow = if ($cur -eq $n) { "  > " } else { "    " }
      Write-Segs @(@($contArrow, "Cyan"), @("Continue", "White")) $w
      Write-Segs @() $w
      Write-Segs @(, @("  Arrows = move  Enter/Space = tick  m = more info  a = all  n = none", "DarkGray")) $w
      Write-Segs @(, @(("  " + $note), "Yellow")) $w
      $note = ""
      $key = [Console]::ReadKey($true)
      switch ($key.Key) {
        "UpArrow"   { $cur = ($cur + $n) % ($n + 1) }
        "DownArrow" { $cur = ($cur + 1) % ($n + 1) }
        "Spacebar"  { if ($cur -lt $n) { $items[$cur].Sel = -not $items[$cur].Sel } }
        "Enter"     { if ($cur -eq $n) { return } else { $items[$cur].Sel = -not $items[$cur].Sel } }
        default {
          switch -CaseSensitive ($key.KeyChar) {
            { $_ -in "k" } { $cur = ($cur + $n) % ($n + 1) }
            { $_ -in "j" } { $cur = ($cur + 1) % ($n + 1) }
            { $_ -in "c", "C" } { return }
            { $_ -in "a", "A" } { foreach ($x in $items) { $x.Sel = $true } }
            { $_ -in "n", "N" } { foreach ($x in $items) { $x.Sel = $false } }
            { $_ -in "m", "M" } {
              if ($cur -lt $n) {
                try { Start-Process $items[$cur].Url } catch {}
                $note = "Opened $($items[$cur].Url)  (if nothing opened, copy this link)"
              }
            }
          }
        }
      }
    }
  } finally {
    [Console]::SetCursorPosition(0, [Math]::Min($top + $h, [Console]::BufferHeight - 1))
    try { [Console]::CursorVisible = $oldCursor } catch {}
  }
}

if ($interactive) {
  Show-Menu "Step 1 of 2: choose what to install" "  Items tagged [recommended] are ticked for you. Untick anything you do not want." $core
  Show-Menu "Step 2 of 2: extras that depend on your project" "  Each tag says when it is useful. Tick only what matches what you are building." $extras
}
$picked = @($core + $extras | Where-Object { $_.Sel })

# ---------- confirm ----------
if ($picked.Count -eq 0) {
  Write-Host ""
  Write-Host "  Nothing selected. Nothing was installed."
  Restore-Enc
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
Restore-Enc
