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

## Install (2 steps)

### Step 1 — Open a terminal in YOUR project folder and run the installer

No project yet? Create an empty folder, then open the terminal inside it.

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/CallebeLima/Vibe-Forge/main/scripts/bootstrap.ps1 | iex
```

**Mac / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/CallebeLima/Vibe-Forge/main/scripts/bootstrap.sh | bash
```

Want the optional extras? Run these **before** the command above (only the ones you need):
- Supabase skills: PowerShell `$env:WITH_SUPABASE = "1"` · Mac/Linux `export WITH_SUPABASE=1`
- Graphify (needs Python 3.10+): PowerShell `$env:WITH_GRAPHIFY = "1"` · Mac/Linux `export WITH_GRAPHIFY=1`

**What gets installed:**
- Skills: `frontend-design`, `webapp-testing`, `owasp-security` (+ `supabase`, `supabase-postgres-best-practices` if enabled)
- Plugins: `oh-my-claudecode` (the agents), `diagram-design` (diagrams), `chrome-devtools-mcp` (lets Claude test your app in a real browser) and `vibe-forge` (this kit)

<details>
<summary>🔍 Want to read the script before running it? (recommended)</summary>

Running a script straight from the internet means trusting who published it. Read it first:
[bootstrap.ps1](scripts/bootstrap.ps1) · [bootstrap.sh](scripts/bootstrap.sh). They only run the install commands listed above.

Prefer not to run it from the web? Clone the kit **outside** your project (for example `C:\tools\vibe-forge`), then, from inside your project folder, run `& C:\tools\vibe-forge\scripts\bootstrap.ps1` (or `bash /path/to/vibe-forge/scripts/bootstrap.sh`).
</details>

### Step 2 — Open Claude Code in the same folder and ask it to set up the project

> "Use new-project-from-kit to set up this project"

Claude asks what you are building, picks the right template and copies the project rules (`CLAUDE.md`), the safe settings and the `.gitignore`:

| If your project is... | Template |
|---|---|
| Python/FastAPI API + Next.js | `python-nextjs` |
| Vite + React + TypeScript | `vite-react` |
| Anything else / not sure | `minimal` |

## Check that it worked

In Claude Code:
- `/skills` → should list the skills above
- `/plugin` → should list `oh-my-claudecode`, `chrome-devtools-mcp`, `vibe-forge`

## What each piece does (click to expand)

<details>
<summary><b>🧠 oh-my-claudecode (OMC)</b> — the AI team</summary>

A plugin that gives Claude a team of specialist **agents** plus a planning command. Instead of one generalist doing everything, Claude hands each job to the right specialist:

- `architect` — plans and reviews structure (read-only, it never edits your code)
- `executor` — writes the code
- `designer` — builds the UI
- `test-engineer` — writes and runs tests
- `security-reviewer` — hunts for vulnerabilities
- `document-specialist` — product, pricing and docs

Also adds `/oh-my-claudecode:plan` to plan a feature before building it.
</details>

<details>
<summary><b>🎨 frontend-design</b> — front-end that doesn't look generic</summary>

A skill that pushes Claude to make deliberate design choices (typography, colors, layout) instead of the default "AI template" look. Used when you ask for pages, components or a new look.
</details>

<details>
<summary><b>🧪 webapp-testing</b> — tests your app like a real user</summary>

A skill that uses Playwright to open your app, click around, take screenshots and read browser logs. Includes a helper script to start your servers before testing.
</details>

<details>
<summary><b>🌐 chrome-devtools-mcp</b> — Claude sees your app in a real browser</summary>

A plugin that connects Claude to Chrome DevTools: inspect the page, read console errors, check network requests and performance. The rule "UI is only done after checking in the browser" relies on it.
</details>

<details>
<summary><b>🔒 owasp-security</b> — security review</summary>

A skill that checks code against OWASP (the standard list of web security risks), including risks specific to AI apps such as prompt injection. Trigger it with phrases like "security review" or "is this safe to ship?".
</details>

<details>
<summary><b>📊 diagram-design</b> — diagrams from a sentence</summary>

A plugin (by `cathrynlavery`, MIT license) that makes Claude draw clean diagrams as a single HTML file with SVG: architecture, flowchart, sequence, state machine, database schema (ER), timeline and many more. Try: *"Make me an architecture diagram of my app: frontend, backend, database."*
</details>

<details>
<summary><b>🕸️ graphify</b> — a map of your codebase (optional)</summary>

Turns your project (code, docs, PDFs) into a knowledge graph so Claude can look up how things connect instead of re-reading every file. Creates a `graphify-out/` folder with an interactive `graph.html` and a `GRAPH_REPORT.md` summary. Needs Python 3.10+. Not installed by default because it also edits your project's `CLAUDE.md` and `settings.json` (it adds a hook). Install with `WITH_GRAPHIFY=1`, then run `/graphify .` in Claude Code (in PowerShell, `graphify .`).
</details>

<details>
<summary><b>🗄️ supabase + supabase-postgres-best-practices</b> — database (optional)</summary>

Skills for projects that use Supabase: login/auth, row-level security (RLS), migrations, edge functions, plus Postgres best practices for table design, indexes and slow queries. Only installed with `WITH_SUPABASE=1`.
</details>

<details>
<summary><b>🔥 vibe-forge (this plugin)</b> — the glue</summary>

- `new-project-from-kit` — sets up a new project: copies the rules, safe settings and `.gitignore`
- `agent-routing` — tells Claude which agent and skill to use for each kind of job
- `/vibe-forge:bootstrap` — lists and installs everything above
</details>

<details>
<summary><b>📄 Templates</b> — what gets copied into your project (3 variants)</summary>

The `new-project-from-kit` skill picks one for you:

| Variant | For |
|---|---|
| `python-nextjs` | Python/FastAPI API + Next.js frontend |
| `vite-react` | Vite + React + TypeScript frontend |
| `minimal` | any other stack (generic rules) |

Each one contains:

- `CLAUDE.md` — project rules: architecture, "answer concisely", "ask before changing more than 3 files"
- `settings.json` — blocks reading/editing `.env`, `workspace/`, `.venv/`; asks before `git push`, `rm` and installs
- `.gitignore` snippet — keeps secrets and generated files out of Git
- `hooks.example.json` — optional: runs `ruff` after Claude edits Python files
</details>

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

Every template's `settings.json` blocks Claude from reading or editing your `.env` (the Python variant also blocks `workspace/` and `.venv/`), and asks before `git push`, `rm` and installs. Your secrets stay yours.

## Common problems

| Problem | Fix |
|---|---|
| `npx` or `claude` not found | Install Node.js / Claude Code and reopen the terminal |
| PowerShell blocks the script | Run `Set-ExecutionPolicy -Scope Process Bypass` and try again |
| Plugin not showing | Restart Claude Code, then run `/plugin` |
| A skill is missing | Run its line from `kit.json` manually |
| `Git clone timed out after 120s` or `EBUSY ... .clone` (usually `diagram-design`) | 1) Delete the leftover folder `%USERPROFILE%\.claude\plugins\marketplaces\<name>..clone` (close VS Code/other terminals first). 2) Raise the timeout: PowerShell `$env:CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS = "300000"` · Mac/Linux `export CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS=300000`. 3) Run the installer again |

## What's inside

```
vibe-forge/
├── plugins/vibe-forge/   → the plugin (skills + /vibe-forge:bootstrap)
├── templates/            → 3 variants: python-nextjs, vite-react, minimal
├── scripts/              → bootstrap.ps1 / bootstrap.sh
├── kit.json              → full list of skills & plugins with their sources
└── .claude-plugin/       → makes this repo installable as a marketplace
```

## Recommended extras (not installed by default)

Install only what your project uses. Run these in your project folder (needs Node.js), then restart Claude Code and check with `/skills`.

**Next.js projects** — React/Next.js performance + UI/accessibility audit (`vercel-labs/agent-skills`):
```
npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices --agent claude-code
npx skills add vercel-labs/agent-skills --skill web-design-guidelines --agent claude-code
```

**Video with Remotion** (`remotion-dev/skills`):
```
npx skills add remotion-dev/skills --skill remotion-best-practices --agent claude-code
```

> These commands come from each project's public docs and have not been tested with this kit.

## Credits & notes

Third-party skills are **not** copied here; the installer downloads the current version from their authors:
`anthropics/skills`, `agamm/claude-code-owasp`, `supabase/agent-skills`, `ChromeDevTools/chrome-devtools-mcp`, `Yeachan-Heo/oh-my-claudecode`.

## License

MIT — see [LICENSE](LICENSE).
