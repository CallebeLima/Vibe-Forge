---
name: new-project-from-kit
description: Use ao iniciar um projeto novo (API Python + frontend Next.js, arquitetura hexagonal) a partir da base do kit. Copia CLAUDE.md, settings.json e .gitignore dos templates e lista skills/plugins a instalar.
---

# Novo projeto a partir do kit

## Antes de executar (avisar o usuário)
Informe primeiro quais skills e plugins precisam estar instalados, para ele instalar antes de rodar qualquer prompt no terminal:
- Skills: `frontend-design`, `webapp-testing`, `owasp-security`, e (se usar Supabase) `supabase` + `supabase-postgres-best-practices`.
- Plugins: `oh-my-claudecode@omc`, `chrome-devtools-mcp@chrome-devtools-plugins`.
- A lista completa e os comandos estão em `kit.json` e em `scripts/bootstrap.sh|ps1` na raiz do repositório do kit.

## Passos
1. Perguntar: nome do projeto, stack (Python/FastAPI, Next.js, Supabase sim/não) e idioma das respostas.
2. Copiar `templates/CLAUDE.md` para a raiz do projeto e substituir os marcadores `{{PROJECT_NAME}}`, `{{STACK}}` e `{{COMANDOS}}`.
3. Copiar `templates/settings.json` para `.claude/settings.json` (permissões deny para `.env`, `workspace/`, `.venv/`).
4. Acrescentar `templates/gitignore.snippet` ao `.gitignore`.
5. Rodar `scripts/bootstrap` do kit (ou mostrar o comando) para instalar skills e plugins.
6. `git init` e primeiro commit somente se o usuário pedir.

## Regras
- Não ler `.env`, `workspace/` nem `.venv/`.
- Antes de alterar mais de 3 arquivos, apresentar plano curto e esperar confirmação.
- Arquitetura: domain (puro) → application (use cases + ports como `typing.Protocol`) → infrastructure (adapters) → api. Composição sobre herança; wiring só em `container.py`.
