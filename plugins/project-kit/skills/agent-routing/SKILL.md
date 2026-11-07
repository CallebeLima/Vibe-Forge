---
name: agent-routing
description: Use para escolher qual agente do oh-my-claudecode (OMC) e qual skill usar por área (arquitetura, backend, UI, testes, segurança, produto/preço). Também define quando segurança é obrigatória.
---

# Roteamento de agentes (OMC)

Os agentes vêm do plugin `oh-my-claudecode@omc`; o projeto não define agentes próprios.

| Área | Agente | Skill de apoio |
|---|---|---|
| Arquitetura / plano | `oh-my-claudecode:architect` (somente leitura), comando `/oh-my-claudecode:plan` | `graphify` (opcional) |
| Backend / pipeline | `executor` | `supabase-postgres-best-practices` se houver banco |
| UI | `designer` | `frontend-design` |
| Testes | `test-engineer` | `webapp-testing` |
| Segurança | `security-reviewer` | `owasp-security` |
| Produto / preço | `document-specialist` | skills `xlsx` / `docx` para contas |

## Segurança obrigatória antes de publicar mudanças em
auth, OAuth, uploads, URLs de entrada, tokens, dependências ou integrações com IA. Relatório por severidade (arquivo, linha, cenário, correção), sem inventar achados.

## Backend
Custo importa: preferir processamento local e modelo barato; avisar se uma mudança aumentar o custo por unidade de uso. Cobrir bordas (entrada vazia, resposta inválida do modelo, upload inválido).

## QA
Bug novo começa com teste que falha. Lint/tipos: `ruff` e `mypy`. UI só é dada como concluída após verificar no navegador (Playwright ou chrome-devtools-mcp).
