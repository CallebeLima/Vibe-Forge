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

## Instalação (2 passos)

### Passo 1 — Abra o terminal na pasta do SEU projeto e rode o instalador

Ainda não tem projeto? Crie uma pasta vazia e abra o terminal dentro dela.

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/CallebeLima/Vibe-Forge/main/scripts/bootstrap.ps1 | iex
```

**Mac / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/CallebeLima/Vibe-Forge/main/scripts/bootstrap.sh | bash
```

O instalador é **interativo**. Ele mostra uma lista de marcação em duas etapas e só instala depois que você confirmar:

1. **Ferramentas principais** — já marcadas com o que a maioria dos projetos precisa. Cada item tem uma descrição curta (em inglês). Digite `m 3` para abrir a página do projeto do item 3 no navegador e ler mais.
2. **Extras recomendados** — dependem do seu projeto. Marque as skills da Vercel se usa Next.js/React ou tem interface web, e a do Remotion só se faz vídeos com Remotion.

Comandos: digite números para marcar/desmarcar (`1 3`), `a` = todos, `n` = nenhum, `m N` = saber mais, Enter = continuar.

Quer pular as perguntas? Use `VIBE_FORGE_YES=1` para instalar os itens já marcados. Pré-marque opcionais com `WITH_SUPABASE=1`, `WITH_GRAPHIFY=1`, `WITH_NEXTJS=1`, `WITH_REMOTION=1` (PowerShell: `$env:NOME = "1"` · Mac/Linux: `export NOME=1`).

**O que pode ser instalado:**
- Skills: `frontend-design`, `webapp-testing`, `owasp-security` (+ `supabase`, `supabase-postgres-best-practices`)
- Plugins: `oh-my-claudecode` (os agentes), `diagram-design` (diagramas), `chrome-devtools-mcp` (deixa o Claude testar seu app num navegador de verdade) e `vibe-forge` (este kit)
- Ferramenta: `graphify` (precisa de Python 3.10+)

<details>
<summary>🔍 Quer ler o script antes de rodar? (recomendado)</summary>

Rodar um script direto da internet significa confiar em quem o publicou. Leia antes:
[bootstrap.ps1](scripts/bootstrap.ps1) · [bootstrap.sh](scripts/bootstrap.sh). Eles só rodam os comandos de instalação listados acima.

Prefere não rodar pela internet? Baixe o kit **fora** do seu projeto (por exemplo `C:\tools\vibe-forge`) e, de dentro da pasta do projeto, rode `& C:\tools\vibe-forge\scripts\bootstrap.ps1` (ou `bash /caminho/do/vibe-forge/scripts/bootstrap.sh`).
</details>

### Passo 2 — Abra o Claude Code na mesma pasta e peça para configurar o projeto

> "Use a new-project-from-kit para configurar este projeto"

O Claude pergunta o que você está construindo, escolhe o template certo e copia as regras do projeto (`CLAUDE.md`), as configurações seguras e o `.gitignore`:

| Se o seu projeto é... | Template |
|---|---|
| API Python/FastAPI + Next.js | `python-nextjs` |
| Vite + React + TypeScript | `vite-react` |
| Qualquer outro / não sei | `minimal` |

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
<summary><b>📊 diagram-design</b> — diagramas a partir de uma frase</summary>

Um plugin (de `cathrynlavery`, licença MIT) que faz o Claude desenhar diagramas limpos em um único arquivo HTML com SVG: arquitetura, fluxograma, sequência, máquina de estados, esquema de banco (ER), linha do tempo e muitos outros. Experimente: *"Faça um diagrama de arquitetura do meu app: frontend, backend, banco de dados."*
</details>

<details>
<summary><b>🕸️ graphify</b> — um mapa do seu código (opcional)</summary>

Transforma seu projeto (código, documentos, PDFs) em um grafo de conhecimento, para o Claude consultar como as coisas se conectam em vez de reler todos os arquivos. Cria uma pasta `graphify-out/` com um `graph.html` interativo e um resumo `GRAPH_REPORT.md`. Precisa de Python 3.10+. Não vem por padrão porque também edita o `CLAUDE.md` e o `settings.json` do projeto (adiciona um hook). Marque no instalador (ou use `WITH_GRAPHIFY=1`) e rode `/graphify .` no Claude Code (no PowerShell, `graphify .`).
</details>

<details>
<summary><b>🗄️ supabase + supabase-postgres-best-practices</b> — banco de dados (opcional)</summary>

Skills para projetos que usam Supabase: login/autenticação, segurança por linha (RLS), migrations, edge functions, além de boas práticas de Postgres para desenho de tabelas, índices e consultas lentas. Só são instaladas se você marcar (ou usar `WITH_SUPABASE=1`).
</details>

<details>
<summary><b>🔥 vibe-forge (este plugin)</b> — a cola de tudo</summary>

- `new-project-from-kit` — configura um projeto novo: copia as regras, as configurações seguras e o `.gitignore`
- `agent-routing` — diz ao Claude qual agente e qual skill usar em cada tipo de tarefa
- `/vibe-forge:bootstrap` — lista e instala tudo acima
</details>

<details>
<summary><b>📄 Templates</b> — o que é copiado para o seu projeto (3 variantes)</summary>

A skill `new-project-from-kit` escolhe uma para você:

| Variante | Para |
|---|---|
| `python-nextjs` | API Python/FastAPI + frontend Next.js |
| `vite-react` | Frontend Vite + React + TypeScript |
| `minimal` | qualquer outra stack (regras genéricas) |

Cada uma contém:

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

O `settings.json` de cada template impede o Claude de ler ou editar seu `.env` (a variante Python também bloqueia `workspace/` e `.venv/`), e pede confirmação antes de `git push`, `rm` e instalações. Seus segredos continuam seus.

## Problemas comuns

| Problema | Solução |
|---|---|
| `npx` ou `claude` não encontrado | Instale Node.js / Claude Code e reabra o terminal |
| PowerShell bloqueia o script | Rode `Set-ExecutionPolicy -Scope Process Bypass` e tente de novo |
| Plugin não aparece | Reinicie o Claude Code e rode `/plugin` |
| Falta alguma skill | Rode manualmente a linha dela no `kit.json` |
| `Git clone timed out after 120s` ou `EBUSY ... .clone` (geralmente no `diagram-design`) | 1) Apague a pasta que sobrou em `%USERPROFILE%\.claude\plugins\marketplaces\<nome>..clone` (feche o VS Code e outros terminais antes). 2) Aumente o tempo limite: PowerShell `$env:CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS = "300000"` · Mac/Linux `export CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS=300000`. 3) Rode o instalador de novo |

## O que tem dentro

```
vibe-forge/
├── plugins/vibe-forge/   → o plugin (skills + /vibe-forge:bootstrap)
├── templates/            → 3 variantes: python-nextjs, vite-react, minimal
├── scripts/              → bootstrap.ps1 / bootstrap.sh
├── kit.json              → lista completa de skills e plugins com as origens
└── .claude-plugin/       → torna este repositório instalável como marketplace
```

## Extras recomendados (etapa 2 do instalador)

O instalador pergunta sobre estes depois das ferramentas principais, porque só fazem sentido em alguns projetos:

| Extra | Marque se… |
|---|---|
| `vercel-react-best-practices` | seu projeto usa **Next.js ou React** (regras de performance da Vercel) |
| `web-design-guidelines` | seu projeto tem **interface web** (audita acessibilidade e design) |
| `remotion-best-practices` | você faz **vídeos com Remotion** |

Prefere instalar na mão? Rode na pasta do projeto, reinicie o Claude Code e confira com `/skills`:
```
npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices --agent claude-code
npx skills add vercel-labs/agent-skills --skill web-design-guidelines --agent claude-code
npx skills add remotion-dev/skills --skill remotion-best-practices --agent claude-code
```

> Esses comandos vêm da documentação pública de cada projeto e não foram testados com este kit.

## Créditos e observações

As skills de terceiros **não** são copiadas aqui; o instalador baixa a versão atual dos autores:
`anthropics/skills`, `agamm/claude-code-owasp`, `supabase/agent-skills`, `ChromeDevTools/chrome-devtools-mcp`, `Yeachan-Heo/oh-my-claudecode`.

## Licença

MIT — veja [LICENSE](LICENSE).
