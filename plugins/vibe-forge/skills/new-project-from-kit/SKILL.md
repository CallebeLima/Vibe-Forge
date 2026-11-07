---
name: new-project-from-kit
description: Use when starting a new project from the Vibe Forge kit. Picks a template (vite-react or minimal) and copies CLAUDE.md, settings.json and the .gitignore snippet into the project.
---

# New project from the kit

Templates live next to this skill, in `../../templates/<variant>/`.

## Before you start (tell the user)
Say which skills and plugins the templates rely on, so the user can install them before going further:
- Skills: `frontend-design`, `owasp-security`
- Plugin: `chrome-devtools-mcp@chrome-devtools-plugins` (used by `vite-react` to check the UI in a browser)

If any are missing, point the user to the installer in the Vibe Forge README (`scripts/bootstrap.sh` or `scripts/bootstrap.ps1`). Do not run installers yourself.

## Variants
| Variant | Use when |
|---|---|
| `vite-react` | Vite + React + TypeScript frontend |
| `minimal` | any other stack, or when unsure |

## Steps
1. Ask for the project name and stack. If the stack is not clearly Vite + React, use `minimal`. Confirm the variant with the user.
2. Copy `CLAUDE.md` from the variant to the project root and fill the placeholders (`{{PROJECT_NAME}}`, `{{SHORT_DESCRIPTION}}`, `{{COMMANDS}}`) from the user's answers. Delete lines that do not apply.
3. Copy `settings.json` to `.claude/settings.json`. If that file already exists, merge instead of overwriting.
4. Append `gitignore.snippet` to `.gitignore` without duplicating lines.
5. Do not run `git init` or commit unless the user asks.

## Rules
- Never read `.env` files.
- Before changing more than 3 files, show a short plan and wait for confirmation.
