---
name: new-project-from-kit
description: Use ao iniciar um projeto novo a partir da base do kit. Escolhe a variante de template (python-nextjs, vite-react ou minimal), copia CLAUDE.md, settings.json e .gitignore e lista skills/plugins a instalar.
---

# Novo projeto a partir do kit

## Antes de executar (avisar o usuário)
Informe primeiro quais skills e plugins precisam estar instalados, para ele instalar antes de rodar qualquer prompt no terminal:
- Skills: `frontend-design`, `webapp-testing`, `owasp-security`, e (se usar Supabase) `supabase` + `supabase-postgres-best-practices`.
- Plugins: `oh-my-claudecode@omc` e, nas variantes com frontend, `chrome-devtools-mcp@chrome-devtools-plugins`.
- A lista completa e os comandos estão em `kit.json` e em `scripts/bootstrap.sh|ps1` na raiz do repositório do kit.

## Variantes de template (pasta `templates/`)
| Variante | Use quando | Arquivos |
|---|---|---|
| `python-nextjs` | API Python/FastAPI (arquitetura hexagonal) + frontend Next.js | `CLAUDE.md`, `settings.json`, `gitignore.snippet`, `hooks.example.json` |
| `vite-react` | Frontend Vite + React + TypeScript | `CLAUDE.md`, `settings.json`, `gitignore.snippet` |
| `minimal` | Qualquer outra stack, ou quando não há certeza | `CLAUDE.md`, `settings.json`, `gitignore.snippet` |

## Passos
1. Perguntar: nome do projeto e stack. Se a stack não for claramente Python+Next.js ou Vite+React, usar `minimal`. Confirmar a variante escolhida com o usuário.
2. Copiar `templates/<variante>/CLAUDE.md` para a raiz do projeto e substituir os marcadores (`{{PROJECT_NAME}}`, `{{COMANDOS}}`, `{{DESCRICAO_CURTA}}`, `{{PACKAGE}}`) com respostas do usuário. Remover linhas que não se aplicam à stack.
3. Copiar `templates/<variante>/settings.json` para `.claude/settings.json`. Se o arquivo já existir, mesclar em vez de sobrescrever.
4. Acrescentar `templates/<variante>/gitignore.snippet` ao `.gitignore` (sem duplicar linhas).
5. Se a variante for `python-nextjs`, oferecer `hooks.example.json` (roda `ruff` após edições).
6. Rodar `scripts/bootstrap` do kit (ou mostrar o comando) para instalar skills e plugins.
7. `git init` e primeiro commit somente se o usuário pedir.

## Regras
- Não ler `.env`, `workspace/` nem `.venv/`.
- Antes de alterar mais de 3 arquivos, apresentar plano curto e esperar confirmação.
- A arquitetura hexagonal (domain → application → infrastructure → api, com `typing.Protocol` e wiring em `container.py`) vale só para `python-nextjs`.
