#!/usr/bin/env bash
# Vibe Forge installer. Run it from the root of YOUR project folder.
#
# Always installed:  frontend-design, owasp-security, chrome-devtools-mcp, vibe-forge
# Optional (asked one by one, default = no):
#   webtest  = webapp-testing        omc       = oh-my-claudecode
#   supabase = supabase skills       react     = vercel-react-best-practices
#   webaudit = web-design-guidelines
#
# Environment variables:
#   VIBE_FORGE_WITH=omc,supabase   install these optional items without asking
#   VIBE_FORGE_NO_PROMPT=1         never ask; install the defaults + VIBE_FORGE_WITH only
set -u

WITH=",${VIBE_FORGE_WITH:-},"
NO_PROMPT="${VIBE_FORGE_NO_PROMPT:-0}"
FAILED=()

# ---------- prerequisites ----------
missing=0
for tool in claude node npx git; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing: $tool"
    missing=1
  fi
done
if [ "$missing" = 1 ]; then
  echo "Install the tools above (Claude Code, Node.js, Git), open a new terminal and run this again."
  exit 1
fi

# ---------- helpers ----------
# Questions are read from the terminal, so this also works when piped from curl.
CAN_ASK=0
if [ "$NO_PROMPT" != "1" ] && { : </dev/tty; } 2>/dev/null; then CAN_ASK=1; fi

want() { # key label
  case "$WITH" in *",$1,"*) return 0 ;; esac
  [ "$CAN_ASK" = 1 ] || return 1
  printf '  Install %s? [y/N] ' "$2" >/dev/tty
  local answer=""
  read -r answer </dev/tty || return 1
  case "$answer" in y | Y | yes | YES) return 0 ;; *) return 1 ;; esac
}

run() {
  echo "  > $*"
  if "$@" </dev/null; then return 0; fi
  FAILED+=("$*")
  return 1
}

skill() { run npx --yes skills add "$1" --skill "$2" --agent claude-code; } # repo skill
plugin() { run claude plugin marketplace add "$1" && run claude plugin install "$3@$2"; } # repo marketplace plugin

# ---------- always ----------
echo "== Installing defaults =="
skill anthropics/skills frontend-design
skill agamm/claude-code-owasp owasp-security
plugin ChromeDevTools/chrome-devtools-mcp chrome-devtools-plugins chrome-devtools-mcp
plugin CallebeLima/Vibe-Forge vibe-forge vibe-forge

# ---------- optional ----------
echo ""
echo "== Optional =="
if want webtest "webapp-testing (Playwright: Claude clicks through your app)"; then
  skill anthropics/skills webapp-testing
fi
if want omc "oh-my-claudecode (team of specialist agents; heavy, third-party)"; then
  plugin Yeachan-Heo/oh-my-claudecode omc oh-my-claudecode
fi
if want supabase "Supabase skills (auth, RLS, migrations, Postgres practices)"; then
  skill supabase/agent-skills supabase
  skill supabase/agent-skills supabase-postgres-best-practices
fi
if want react "vercel-react-best-practices (React / Next.js performance rules)"; then
  skill vercel-labs/agent-skills vercel-react-best-practices
fi
if want webaudit "web-design-guidelines (UI and accessibility review)"; then
  skill vercel-labs/agent-skills web-design-guidelines
fi

# ---------- result ----------
echo ""
if [ "${#FAILED[@]}" -gt 0 ]; then
  echo "== Finished with problems =="
  for item in "${FAILED[@]}"; do echo "  ! failed: $item"; done
  echo "Fix the cause and run the failed commands by hand."
  exit 1
fi
echo "== Done =="
echo "Restart Claude Code in this folder, check with /skills and /plugin, then ask:"
echo "  Use new-project-from-kit to set up this project"
