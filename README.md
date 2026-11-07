# claude-project-kit

Base reutilizável extraída do projeto Hachi para iniciar novos projetos (API Python hexagonal + Next.js) com as mesmas skills, plugins e agentes.

## O que tem aqui
- `plugins/project-kit/`: plugin próprio
  - skill `new-project-from-kit`: cria projeto novo a partir dos templates
  - skill `agent-routing`: mapa dos agentes OMC por área
  - comando `/project-kit:bootstrap`
- `templates/`: `CLAUDE.md`, `settings.json` (permissões deny para `.env`/`workspace`/`.venv`), `hooks.example.json`, `gitignore.snippet`
- `kit.json`: inventário de skills e plugins de terceiros, com origem e comando de instalação
- `scripts/bootstrap.sh|ps1`: instalam tudo de uma vez

## Instalar skills/plugins ANTES de usar
Skills: `frontend-design`, `webapp-testing`, `owasp-security` (+ `supabase`, `supabase-postgres-best-practices` com `WITH_SUPABASE=1`).
Plugins: `chrome-devtools-mcp`, `oh-my-claudecode` (defina `OMC_MARKETPLACE_REPO`).

```powershell
# Windows, na raiz do projeto novo
$env:OMC_MARKETPLACE_REPO = "owner/repo-do-marketplace-omc"
.\scripts\bootstrap.ps1
```

## Usar o plugin
```
/plugin marketplace add <seu-usuario>/claude-project-kit
/plugin install project-kit@claude-project-kit
```

## Por que não copia as skills de terceiros
Cada uma tem dono, licença e atualizações próprias. O kit guarda só a origem (`kit.json`), e o script instala a versão atual.

## Pendências
- `diagram-design` (MIT, v2.6) e `graphify` (v0.9.103) estavam instaladas no Hachi sem origem registrada no `skills-lock.json`. Informe a origem em `kit.json`.
- Repositório do marketplace `omc` precisa ser preenchido.
- `frontend-design` existe como skill e como plugin no Hachi; mantenha só um.
