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

## O que cada peça faz (clique para expandir)

<details>
<summary><b>🧠 oh-my-claudecode (OMC)</b> — o time de IA</summary>

Um plugin que dá ao Claude um time de **agentes** especialistas e um comando de planejamento. Em vez de um generalista fazer tudo, o Claude passa cada tarefa para o especialista certo:

- `architect` — planeja e revisa a estrutura (só leitura, nunca edita seu código)
- `executor` — escreve o código
- `designer` — monta a interface
- `test-engineer` — escreve e roda testes
- `security-reviewer` — procura vulnerabilidades
- `document-specialist` — produto, preço e documentação

Também adiciona o `/oh-my-claudecode:plan` para planejar uma funcionalidade antes de construir.
</details>

<details>
<summary><b>🎨 frontend-design</b> — front-end que não parece genérico</summary>

Uma skill que faz o Claude tomar decisões de design com intenção (tipografia, cores, layout) em vez do visual padrão "cara de template de IA". Usada quando você pede páginas, componentes ou um visual novo.
</details>

<details>
<summary><b>🧪 webapp-testing</b> — testa seu app como um usuário de verdade</summary>

Uma skill que usa o Playwright para abrir seu app, clicar, tirar prints e ler os logs do navegador. Inclui um script que sobe seus servidores antes de testar.
</details>

<details>
<summary><b>🌐 chrome-devtools-mcp</b> — o Claude vê seu app num navegador de verdade</summary>

Um plugin que conecta o Claude ao Chrome DevTools: inspecionar a página, ler erros do console, ver requisições de rede e desempenho. A regra "a interface só está pronta depois de conferir no navegador" depende dele.
</details>

<details>
<summary><b>🔒 owasp-security</b> — revisão de segurança</summary>

Uma skill que confere o código contra o OWASP (a lista padrão de riscos de segurança web), incluindo riscos de apps com IA, como prompt injection. Ative com frases como "revisão de segurança" ou "isso é seguro para publicar?".
</details>

<details>
<summary><b>🗄️ supabase + supabase-postgres-best-practices</b> — banco de dados (opcional)</summary>

Skills para projetos que usam Supabase: login/autenticação, segurança por linha (RLS), migrations, edge functions, além de boas práticas de Postgres para desenho de tabelas, índices e consultas lentas. Só são instaladas com `WITH_SUPABASE=1`.
</details>

<details>
<summary><b>🔥 vibe-forge (este plugin)</b> — a cola de tudo</summary>

- `new-project-from-kit` — configura um projeto novo: copia as regras, as configurações seguras e o `.gitignore`
- `agent-routing` — diz ao Claude qual agente e qual skill usar em cada tipo de tarefa
- `/vibe-forge:bootstrap` — lista e instala tudo acima
</details>

<details>
<summary><b>📄 Templates</b> — o que é copiado para o seu projeto</summary>

- `CLAUDE.md` — regras do projeto: arquitetura, "responder de forma concisa", "perguntar antes de mudar mais de 3 arquivos"
- `settings.json` — bloqueia leitura/edição de `.env`, `workspace/`, `.venv/`; pede confirmação antes de `git push`, `rm` e instalações
- trecho de `.gitignore` — mantém segredos e arquivos gerados fora do Git
- `hooks.example.json` — opcional: roda o `ruff` depois que o Claude edita arquivos Python
</details>

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

Instale só o que seu projeto usa. Rode na pasta do projeto (precisa do Node.js), reinicie o Claude Code e confira com `/skills`.

**Projetos Next.js** — performance de React/Next.js + auditoria de UI e acessibilidade (`vercel-labs/agent-skills`):
```
npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices --agent claude-code
npx skills add vercel-labs/agent-skills --skill web-design-guidelines --agent claude-code
```

**Vídeo com Remotion** (`remotion-dev/skills`):
```
npx skills add remotion-dev/skills --skill remotion-best-practices --agent claude-code
```

> Esses comandos vêm da documentação pública de cada projeto e ainda não foram testados com este kit.

## Créditos e observações

As skills de terceiros **não** são copiadas aqui; o instalador baixa a versão atual dos autores:
`anthropics/skills`, `agamm/claude-code-owasp`, `supabase/agent-skills`, `ChromeDevTools/chrome-devtools-mcp`, `Yeachan-Heo/oh-my-claudecode`.

## Licença

MIT — veja [LICENSE](LICENSE).
