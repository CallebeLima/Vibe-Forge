# {{PROJECT_NAME}}

# Commands
{{COMANDOS}}
- Testes: `pytest -q` | teste único: `pytest tests/test_x.py::test_name -q`
- Lint/tipos: `ruff check .` e `mypy src`

# Architecture & Rules
Layout hexagonal em `src/{{PACKAGE}}/`, composição sobre herança (sem classes base; use `typing.Protocol`):
- `domain/`: dataclasses puras e erros; zero I/O.
- `application/`: casos de uso e `ports.py` (Protocols). Depende só de domain/ports, nunca de SDKs.
- `infrastructure/`: adapters concretos (SDKs, storage, ffmpeg, etc.).
- `api/`: camada HTTP (FastAPI). Só chama builders de `container.py`; nada de HTTP em domain/application.
- `container.py`: composition root. TODO adapter novo é ligado aqui.
- `frontend/`: Next.js App Router (ler `frontend/AGENTS.md` antes de codar).
- `tests/`: unitários com factories, sem rede nem modelos de ML.

# Token Economy & Execution Constraints
- Nunca ler nem varrer `workspace/`, `.venv/` ou `.env`.
- Rodar `pytest -q` depois de mudanças de lógica.
- Responder em pt-BR, conciso, sem explicar código a menos que peçam.
- Antes de alterar mais de 3 arquivos, apresentar plano curto e esperar confirmação.

# Agentes e áreas (agentes do OMC; sem agentes próprios)
- Arquitetura/plano → `oh-my-claudecode:architect` (leitura) e `/oh-my-claudecode:plan`; backend → `executor`; UI → `designer` + skill `frontend-design`; testes → `test-engineer` + `webapp-testing`; segurança → `security-reviewer` + `owasp-security`; produto/preço → `document-specialist`.
- Segurança obrigatória antes de publicar mudanças em auth, OAuth, uploads, URLs de entrada, tokens, dependências ou integrações com IA. Relatório por severidade (arquivo, linha, cenário, correção); sem inventar achados.
- Backend: custo importa; preferir processamento local e modelo barato; avisar se a mudança aumentar o custo por unidade. Cobrir bordas (entrada vazia, resposta inválida do modelo, upload inválido).
- Frontend: verificar no navegador (Playwright ou chrome-devtools-mcp) antes de dar como concluído.
- QA: bug novo começa com teste que falha.
- Produto: mostrar contas e premissas; separar fato pesquisado (com fonte) de hipótese.
