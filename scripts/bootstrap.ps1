# Vibe Forge installer. Run it from the root of YOUR project folder.
#
# Always installed:  frontend-design, owasp-security, chrome-devtools-mcp, vibe-forge
# Optional (asked one by one, default = no):
#   webtest  = webapp-testing        omc       = oh-my-claudecode
#   supabase = supabase skills       react     = vercel-react-best-practices
#   webaudit = web-design-guidelines
#
# Environment variables:
#   $env:VIBE_FORGE_WITH = "omc,supabase"   install these optional items without asking
#   $env:VIBE_FORGE_NO_PROMPT = "1"         never ask; install the defaults + VIBE_FORGE_WITH only
$ErrorActionPreference = "Continue"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$With = @()
if ($env:VIBE_FORGE_WITH) { $With = $env:VIBE_FORGE_WITH.Split(",") | ForEach-Object { $_.Trim() } }
$NoPrompt = ($env:VIBE_FORGE_NO_PROMPT -eq "1")
$script:Failed = @()

# ---------- prerequisites ----------
$missing = $false
foreach ($tool in "claude", "node", "npx", "git") {
  if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
    Write-Host "Missing: $tool"
    $missing = $true
  }
}
if ($missing) {
  Write-Host "Install the tools above (Claude Code, Node.js, Git), open a new terminal and run this again."
  return
}

# ---------- helpers ----------
function Want([string]$key, [string]$label) {
  if ($With -contains $key) { return $true }
  if ($NoPrompt) { return $false }
  $answer = Read-Host "  Install ${label}? [y/N]"
  return ($answer -match '^(y|yes)$')
}

function Run([string]$label, [scriptblock]$command) {
  Write-Host "  > $label"
  $global:LASTEXITCODE = 0
  & $command 2>&1 | Out-Host
  if ($LASTEXITCODE -ne 0) {
    $script:Failed += $label
    return $false
  }
  return $true
}

function Skill([string]$repo, [string]$name) {
  Run "npx skills add $repo --skill $name" { npx --yes skills add $repo --skill $name --agent claude-code } | Out-Null
}

function Plugin([string]$repo, [string]$marketplace, [string]$name) {
  $added = Run "claude plugin marketplace add $repo" { claude plugin marketplace add $repo }
  if ($added) {
    Run "claude plugin install $name@$marketplace" { claude plugin install "$name@$marketplace" } | Out-Null
  }
}

# ---------- always ----------
Write-Host "== Installing defaults =="
Skill "anthropics/skills" "frontend-design"
Skill "agamm/claude-code-owasp" "owasp-security"
Plugin "ChromeDevTools/chrome-devtools-mcp" "chrome-devtools-plugins" "chrome-devtools-mcp"
Plugin "CallebeLima/Vibe-Forge" "vibe-forge" "vibe-forge"

# ---------- optional ----------
Write-Host ""
Write-Host "== Optional =="
if (Want "webtest" "webapp-testing (Playwright: Claude clicks through your app)") {
  Skill "anthropics/skills" "webapp-testing"
}
if (Want "omc" "oh-my-claudecode (team of specialist agents; heavy, third-party)") {
  Plugin "Yeachan-Heo/oh-my-claudecode" "omc" "oh-my-claudecode"
}
if (Want "supabase" "Supabase skills (auth, RLS, migrations, Postgres practices)") {
  Skill "supabase/agent-skills" "supabase"
  Skill "supabase/agent-skills" "supabase-postgres-best-practices"
}
if (Want "react" "vercel-react-best-practices (React / Next.js performance rules)") {
  Skill "vercel-labs/agent-skills" "vercel-react-best-practices"
}
if (Want "webaudit" "web-design-guidelines (UI and accessibility review)") {
  Skill "vercel-labs/agent-skills" "web-design-guidelines"
}

# ---------- result ----------
Write-Host ""
if ($script:Failed.Count -gt 0) {
  Write-Host "== Finished with problems =="
  foreach ($item in $script:Failed) { Write-Host "  ! failed: $item" }
  Write-Host "Fix the cause and run the failed commands by hand."
  return
}
Write-Host "== Done =="
Write-Host "Restart Claude Code in this folder, check with /skills and /plugin, then ask:"
Write-Host "  Use new-project-from-kit to set up this project"
