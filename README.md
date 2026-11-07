# 🔥 Vibe Forge

**Start every new project with the best Claude Code setup already in place.**
One install gives you the skills, plugins, safety rules and "AI team" (agents) used in a real production project.

🇧🇷 [Leia em português](README.pt-BR.md)

---

## What is this? (30 seconds)

When you "vibe code" with Claude Code, results depend a lot on **what Claude knows how to do** and **what it is allowed to touch**. Setting that up for each new project is slow and easy to get wrong.

Vibe Forge packages it all:

| Piece | In plain words |
|---|---|
| **Skills** | Instruction manuals Claude reads when needed (UI design, security review, testing, Supabase...) |
| **Plugins** | Add-ons that give Claude new commands and a team of **agents** |
| **Agents** | Specialists: an architect, a builder, a designer, a tester, a security reviewer |
| **Templates** | A ready `CLAUDE.md` (project rules) and `settings.json` (blocks Claude from reading your `.env` secrets) |

## Before you start

You need three things installed:

1. **Claude Code** → https://docs.claude.com/en/docs/claude-code
2. **Node.js** (to run `npx`) → https://nodejs.org
3. **Git** → https://git-scm.com

Check in a terminal:

```
claude --version
node --version
git --version
```

## Install (easy way, 3 steps)

### Step 1 — Get the kit

```
git clone https://github.com/CallebeLima/vibe-forge.git
```

### Step 2 — Open a terminal in YOUR project folder and run the installer

**Windows (PowerShell):**
```powershell
cd C:\path\to\your-project
& C:\path\to\vibe-forge\scripts\bootstrap.ps1
```

**Mac / Linux:**
```bash
cd /path/to/your-project
bash /path/to/vibe-forge/scripts/bootstrap.sh
```

Using Supabase? Add it first:
- PowerShell: `$env:WITH_SUPABASE = "1"`
- Mac/Linux: `export WITH_SUPABASE=1`

**What gets installed:**
- Skills: `frontend-design`, `webapp-testing`, `owasp-security` (+ `supabase`, `supabase-postgres-best-practices` if enabled)
- Plugins: `oh-my-claudecode` (the agents) and `chrome-devtools-mcp` (lets Claude test your app in a real browser)

### Step 3 — Add the Vibe Forge plugin and create your project base

Open Claude Code in your project and run:

```
/plugin marketplace add CallebeLima/vibe-forge
/plugin install vibe-forge@vibe-forge
```

Then just ask Claude:

> "Use new-project-from-kit to set up this project"

It will ask a few questions, then copy the rules (`CLAUDE.md`), the safe settings and the `.gitignore` for you.

## Check that it worked

In Claude Code:
- `/skills` → should list the skills above
- `/plugin` → should list `oh-my-claudecode`, `chrome-devtools-mcp`, `vibe-forge`

## The "AI team" (agents)

| When you want... | Claude uses | Skill that helps |
|---|---|---|
| A plan / architecture | `architect` (read-only, safe) | — |
| Code written | `executor` | — |
| A nice UI | `designer` | `frontend-design` |
| Tests | `test-engineer` | `webapp-testing` |
| Security check | `security-reviewer` | `owasp-security` |
| Pricing / product math | `document-specialist` | — |

**Golden rule baked in:** security review is required before publishing changes to login, uploads, tokens, user-provided URLs, dependencies or AI integrations.

## Safety built in

`templates/settings.json` blocks Claude from reading or editing your `.env`, `workspace/` and `.venv/`, and asks before `git push`, `rm` and installs. Your secrets stay yours.

## Common problems

| Problem | Fix |
|---|---|
| `npx` or `claude` not found | Install Node.js / Claude Code and reopen the terminal |
| PowerShell blocks the script | Run `Set-ExecutionPolicy -Scope Process Bypass` and try again |
| Plugin not showing | Restart Claude Code, then run `/plugin` |
| A skill is missing | Run its line from `kit.json` manually |

## What's inside

```
vibe-forge/
├── plugins/vibe-forge/   → the plugin (skills + /vibe-forge:bootstrap)
├── templates/            → CLAUDE.md, settings.json, .gitignore, hook example
├── scripts/              → bootstrap.ps1 / bootstrap.sh
├── kit.json              → full list of skills & plugins with their sources
└── .claude-plugin/       → makes this repo installable as a marketplace
```

## Recommended extras (not installed by default)

- **superpowers** — test-first coding, systematic debugging, code review
- **vercel-labs/agent-skills** — React/Next.js performance and UI audit
- **remotion-dev/skills** — if you generate video with Remotion

Commands are in `kit.json` → `recommended_gaps`.

## Credits & notes

Third-party skills are **not** copied here; the installer downloads the current version from their authors:
`anthropics/skills`, `agamm/claude-code-owasp`, `supabase/agent-skills`, `ChromeDevTools/chrome-devtools-mcp`, `Yeachan-Heo/oh-my-claudecode`.

## License

MIT — see [LICENSE](LICENSE).
