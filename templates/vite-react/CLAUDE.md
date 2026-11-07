# {{PROJECT_NAME}}

Frontend Vite + React + TypeScript.

# Commands
- Dev: `npm run dev`
- Build: `npm run build`
- Lint: `npm run lint`
- Tipos: `npx tsc --noEmit`
- Testes: `npm test` (ajuste se o projeto usar outro runner)

# Estrutura e regras
- Código em `src/`. Componentes pequenos, um por arquivo; lógica reutilizável em hooks (`src/hooks/`).
- Chamadas de API isoladas em `src/lib/api.ts`; componentes não chamam `fetch` direto.
- Variáveis de ambiente do Vite começam com `VITE_` e ficam em `.env` (nunca versionado; manter um `.env.example`).
- Nunca colocar segredos no código do frontend: tudo em `VITE_*` é público no navegador.

# Execução
- Nunca ler nem editar `.env`.
- Rodar lint e tipos depois de mudanças e corrigir antes de concluir.
- Responder em pt-BR, conciso, sem explicar código a menos que peçam.
- Antes de alterar mais de 3 arquivos, apresentar plano curto e esperar confirmação.

# Agentes e skills (plugin oh-my-claudecode)
- Plano/arquitetura → `oh-my-claudecode:architect` e `/oh-my-claudecode:plan`; código → `executor`; UI → `designer` + skill `frontend-design`; testes → `test-engineer` + `webapp-testing`; segurança → `security-reviewer` + `owasp-security`.
- Revisão de segurança antes de publicar mudanças em login, uploads, tokens, URLs vindas do usuário, dependências ou integrações com IA.
- UI só está pronta depois de conferir no navegador (Playwright ou chrome-devtools-mcp), incluindo celular e console sem erros.
- Bug novo começa com teste que falha.
