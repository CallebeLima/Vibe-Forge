# {{PROJECT_NAME}}

Vite + React + TypeScript frontend.

# Commands
- Dev: `npm run dev`
- Build: `npm run build`
- Lint: `npm run lint`
- Types: `npx tsc --noEmit`
- Tests: `npm test` (adjust if the project uses another runner)

# Structure and rules
- Code in `src/`. Small components, one per file; reusable logic in hooks (`src/hooks/`).
- API calls live in `src/lib/api.ts`; components never call `fetch` directly.
- Vite env variables start with `VITE_` and live in `.env` (never committed; keep a `.env.example`).
- Never put secrets in frontend code: everything in `VITE_*` is public in the browser.

# Workflow
- Never read or edit `.env` files (`.env.example` is fine).
- Run lint and type checks after changes, and fix failures before finishing.
- Keep answers concise; do not explain code unless asked.
- Before changing more than 3 files, present a short plan and wait for confirmation.
- A new bug starts with a failing test.
- UI is only done after checking it in the browser (`chrome-devtools-mcp`), including a phone-width viewport and a clean console. Use the `frontend-design` skill for UI work.
- Security review before shipping changes to login, uploads, tokens, user-supplied URLs, dependencies or AI integrations (skill: `owasp-security`).
