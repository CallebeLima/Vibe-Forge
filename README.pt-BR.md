# 🔥 Vibe Forge

**Comece todo projeto novo com o melhor setup do Claude Code já pronto.**
Uma instalação e você ganha as skills, plugins, regras de segurança e o "time de IA" (agentes) usados em um projeto real.

🇺🇸 [Read in English](README.md)

---

## O que é isso? (30 segundos)

Quando você faz "vibe coding" com o Claude Code, o resultado depende muito do **que o Claude sabe fazer** e do **que ele pode mexer**. Configurar isso a cada projeto novo é chato e fácil de errar.

O Vibe Forge empacota tudo:

| Peça | Em palavras simples |
|---|---|
| **Skills** | Manuais que o Claude lê quando precisa (design de UI, revisão de segurança, testes, Supabase...) |
| **Plugins** | Complementos que dão ao Claude comandos novos e um time de **agentes** |
| **Agentes** | Especialistas: arquiteto, construtor, designer, testador, revisor de segurança |
| **Templates** | Um `CLAUDE.md` pronto (regras do projeto) e um `settings.json` (impede o Claude de ler seus segredos do `.env`) |

## Antes de começar

Você precisa ter instalado:

1. **Claude Code** → https://docs.claude.com/en/docs/claude-code
2. **Node.js** (para rodar o `npx`) → https://nodejs.org
3. **Git** → https://git-scm.com

Confira no terminal:

```
claude --version
node --version
git --version
```

## Instalação (jeito fácil, 3 passos)

### Passo 1 — Baixe o kit

```
git clone https://github.com/CallebeLima/vibe-forge.git
```

### Passo 2 — Abra o terminal na pasta do SEU projeto e rode o instalador

**Windows (PowerShell):**
```powershell
cd C:\caminho\do\seu-projeto
& C:\caminho\do\vibe-forge\scripts\bootstrap.ps1
```

**Mac / Linux:**
```bash
cd /caminho/do/seu-projeto
bash /caminho/do/vibe-forge/scripts/bootstrap.sh
```

Vai usar Supabase? Ative antes:
- PowerShell: `$env:WITH_SUPABASE = "1"`
- Mac/Linux: `export WITH_SUPABASE=1`

**O que é instalado:**
- Skills: `frontend-design`, `webapp-testing`, `owasp-security` (+ `supabase`, `supabase-postgres-best-practices` se ativado)
- Plugins: `oh-my-claudecode` (os agentes) e `chrome-devtools-mcp` (deixa o Claude testar seu app num navegador de verdade)

### Passo 3 — Adicione o plugin Vibe Forge e crie a base do projeto

Abra o Claude Code no seu projeto e rode:

```
/plugin marketplace add CallebeLima/vibe-forge
/plugin install vibe-forge@vibe-forge
```

Depois é só pedir ao Claude:

> "Use a new-project-from-kit para configurar este projeto"

Ele faz algumas perguntas e copia para você as regras (`CLAUDE.md`), as configurações seguras e o `.gitignore`.

## Como saber se deu certo

No Claude Code:
- `/skills` → deve listar as skills acima
- `/plugin` → deve listar `oh-my-claudecode`, `chrome-devtools-mcp` e `vibe-forge`

## O "time de IA" (agentes)

| Quando você quer... | O Claude usa | Skill que ajuda |
|---|---|---|
| Um plano / arquitetura | `architect` (só leitura, seguro) | — |
| Código escrito | `executor` | — |
| Uma UI bonita | `designer` | `frontend-design` |
| Testes | `test-engineer` | `webapp-testing` |
| Checagem de segurança | `security-reviewer` | `owasp-security` |
| Preço / contas do produto | `document-specialist` | — |

**Regra de ouro embutida:** revisão de segurança é obrigatória antes de publicar mudanças em login, uploads, tokens, URLs enviadas pelo usuário, dependências ou integrações com IA.

## Segurança já incluída

O `templates/settings.json` impede o Claude de ler ou editar seu `.env`, `workspace/` e `.venv/`, e pede confirmação antes de `git push`, `rm` e instalações. Seus segredos continuam seus.

## Problemas comuns

| Problema | Solução |
|---|---|
| `npx` ou `claude` não encontrado | Instale Node.js / Claude Code e reabra o terminal |
| PowerShell bloqueia o script | Rode `Set-ExecutionPolicy -Scope Process Bypass` e tente de novo |
| Plugin não aparece | Reinicie o Claude Code e rode `/plugin` |
| Falta alguma skill | Rode manualmente a linha dela no `kit.json` |

## O que tem dentro

```
vibe-forge/
├── plugins/vibe-forge/   → o plugin (skills + /vibe-forge:bootstrap)
├── templates/            → CLAUDE.md, settings.json, .gitignore, exemplo de hook
├── scripts/              → bootstrap.ps1 / bootstrap.sh
├── kit.json              → lista completa de skills e plugins com as origens
└── .claude-plugin/       → torna este repositório instalável como marketplace
```

## Extras recomendados (não instalados por padrão)

- **vercel-labs/agent-skills** — performance de React/Next.js e auditoria de UI
- **remotion-dev/skills** — se você gera vídeo com Remotion

Os comandos estão em `kit.json` → `recommended_gaps`.

## Créditos e observações

As skills de terceiros **não** são copiadas aqui; o instalador baixa a versão atual dos autores:
`anthropics/skills`, `agamm/claude-code-owasp`, `supabase/agent-skills`, `ChromeDevTools/chrome-devtools-mcp`, `Yeachan-Heo/oh-my-claudecode`.

## Licença

MIT — veja [LICENSE](LICENSE).
