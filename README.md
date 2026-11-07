# Vibe Forge

A small starter kit for new [Claude Code](https://docs.claude.com/en/docs/claude-code) projects: an installer for a few useful skills and plugins, plus generic project templates (`CLAUDE.md`, permission settings, `.gitignore`).

Most of what it installs is made by other people. This repo only adds the installer and the templates.

## Requirements

Claude Code, Node.js (for `npx`) and Git. Check with `claude --version`, `node --version`, `git --version`.

## Install

Run it from the root of **your project** folder.

**Mac / Linux**
```bash
curl -fsSL https://raw.githubusercontent.com/CallebeLima/Vibe-Forge/main/scripts/bootstrap.sh | bash
```

**Windows (PowerShell)**
```powershell
irm https://raw.githubusercontent.com/CallebeLima/Vibe-Forge/main/scripts/bootstrap.ps1 | iex
```

Piping a script from the internet means trusting its author. The scripts are short: read [bootstrap.sh](scripts/bootstrap.sh) / [bootstrap.ps1](scripts/bootstrap.ps1) first, or clone this repo and run the script locally. They only run the `npx skills add` and `claude plugin ...` commands you can see in them.

Then restart Claude Code in the folder and ask:

> Use new-project-from-kit to set up this project

## What gets installed

Always:

| Item | Source | What it does |
|---|---|---|
| `frontend-design` (skill) | anthropics/skills | Pushes Claude toward deliberate UI design instead of generic templates |
| `owasp-security` (skill) | agamm/claude-code-owasp | Security review against OWASP, including AI-app risks |
| `chrome-devtools-mcp` (plugin) | ChromeDevTools/chrome-devtools-mcp | Lets Claude inspect your app in a real Chrome: console, network, performance |
| `vibe-forge` (plugin) | this repo | The `new-project-from-kit` skill and its templates |

Optional (the installer asks about each one, default is no):

| Key | Item | Install it if |
|---|---|---|
| `webtest` | `webapp-testing` | you want Claude to click through your app with Playwright |
| `omc` | `oh-my-claudecode` | you want its team of specialist agents (heavy, third-party) |
| `supabase` | `supabase` + `supabase-postgres-best-practices` | you use Supabase |
| `react` | `vercel-react-best-practices` | you use React or Next.js |
| `webaudit` | `web-design-guidelines` | you have a web UI and want accessibility / design review |

Skip the questions with environment variables:

```bash
# Mac / Linux
VIBE_FORGE_WITH=omc,supabase VIBE_FORGE_NO_PROMPT=1 bash scripts/bootstrap.sh
```
```powershell
# Windows
$env:VIBE_FORGE_WITH = "omc,supabase"; $env:VIBE_FORGE_NO_PROMPT = "1"
```

`VIBE_FORGE_WITH` installs the listed optional items without asking. `VIBE_FORGE_NO_PROMPT=1` never asks and installs only the defaults plus whatever `VIBE_FORGE_WITH` lists.

## Templates

`new-project-from-kit` copies one of these into your project:

| Template | For |
|---|---|
| `vite-react` | Vite + React + TypeScript frontend |
| `minimal` | any other stack |

Each has a `CLAUDE.md` (project rules to fill in), a `settings.json` (copied to `.claude/settings.json`) and a `.gitignore` snippet.

## About the permission settings

`settings.json` denies Claude access to `.env` files and asks before `git push`, `rm` and package installs. Treat this as a guardrail, not a sandbox: deny rules match specific tools and command patterns, and a shell command can still find another way to read a file. Keep real secrets out of the project folder if that matters to you.

## Troubleshooting

| Problem | Fix |
|---|---|
| `claude`, `npx` or `git` not found | Install it and open a new terminal |
| PowerShell blocks the script | `Set-ExecutionPolicy -Scope Process Bypass`, then run it again |
| A plugin does not show up | Restart Claude Code and run `/plugin` |
| A plugin clone times out | `export CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS=300000` (PowerShell: `$env:CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS = "300000"`) and run the installer again |

## License

MIT, see [LICENSE](LICENSE). Third-party skills and plugins keep their own licenses and are downloaded from their authors at install time.
