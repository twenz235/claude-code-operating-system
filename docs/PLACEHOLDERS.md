# Placeholders — the `{{TOKEN}}` reference table

This operating system ships with **placeholder tokens** wherever a value is specific to *you*: your assistant's name, your project, your tracker, your deploy platform, and so on. Nothing personal or organization-specific is hardcoded. You make the template yours by replacing every `{{TOKEN}}` with your own value.

> **คู่มือ (TH):** ทุกที่ที่เป็นค่าเฉพาะของคุณ (ชื่อ assistant, โปรเจกต์, tracker, deploy platform ฯลฯ) จะเป็น `{{TOKEN}}` กลาง ๆ ไม่มีของจริงฮาร์ดโค้ดไว้ — คุณแทนค่าเองให้ครบก่อนใช้

This file is the **canonical list**. If a token appears anywhere in the repo (skills, agents, hooks, docs), it is defined here.

---

## The tokens

| Token | Meaning | Where it appears | Example value |
|-------|---------|------------------|---------------|
| `{{ASSISTANT}}` | The name your AI assistant goes by in prose, and the slug used in file/dir names derived from it (e.g. capture-note filenames, the curator agent). | `curate` / `review-proposals` skills, `curator` agent, hook capture-note glob (`*-{{ASSISTANT}}-*.md`), `ASSISTANT_TAG` env in the hooks. | `nova`, `pilot`, `scout` |
| `{{USER}}` | The human owner — the person the assistant works for. Used only in prose persona lines. | `CLAUDE.md` persona section, skill prose. | `Alex`, `your name` |
| `{{PROJECT}}` | Your primary software product / codebase. | Deploy skills, per-env DB names (`{{PROJECT}}_<env>`), charter scope refs. | `acme-app` |
| `{{ORG}}` | Your version-control org / account handle (e.g. the GitHub org). | Deploy agents, registry image paths. | `acme-co` |
| `{{DOMAIN}}` | Your base service domain. Other hosts are built on top (e.g. `api.{{DOMAIN}}`, `{{DEPLOY_PLATFORM}}.{{DOMAIN}}`). | Deploy skills, full-loop config, internal service URLs. | `acme.com` |
| `{{REPO}}` | A repository name (often with a suffix like `-backend` / `-frontend`). Also used for "a private backup remote" references. | Repo refs in deploy skills, the optional config-backup script comment. | `acme-app` → `acme-app-backend` |
| `{{VAULT}}` | The root of your notes vault / second brain (any Markdown PKM — Obsidian, plain folder, etc.). Cadence and memory features write here. | Hooks (`CLAUDE_VAULT`), `curate`/`review-proposals` skills, `curator` agent, all cadence skills, charter copy target. | `~/notes`, `~/vault` |
| `{{TRACKER}}` | Your issue tracker. | `to-ticket`, `task-manager`, `tracker-card` agent, `design-cards`. | `Linear`, `Jira`, `GitHub Issues` |
| `{{DEPLOY_PLATFORM}}` | Your deploy platform / PaaS. Also forms the API-key env var name (`{{DEPLOY_PLATFORM}}_API_KEY`). | `deploy`, `cicd-deploy`, deploy agents, the API host `{{DEPLOY_PLATFORM}}.{{DOMAIN}}`. | `Render`, `Fly.io`, `Railway` |
| `{{REGISTRY}}` | Your container image registry. | Deploy skills (image pull/push). | `Docker Hub`, `ECR`, `GAR` |
| `{{OBJECT_STORE}}` | Your offsite object store for backups / mirrors. | `backup-dr`, infra skills. | `S3`, `GCS`, `B2` |
| `{{OWNER_ROLE}}` | The manager / decision-maker / ops lead you escalate to and who holds root-level approval. | `management-talk`, `charter-check`, cadence/review skills, workload escalation. | `your manager`, `MD`, `CTO` |

### Team-coordination tokens (the COORD system)

These are used by the `/coord-*` commands, the BOARD, and [`team-coordination.md`](team-coordination.md). They only matter if you run the multi-agent team workflow.

| Token | Meaning | Where it appears | Example value |
|-------|---------|------------------|---------------|
| `{{HOST}}` | The human courier who relays messages between sessions — reads "relay to `<role>`" off the board and opens the next session. Not a role; the only cross-session channel. | `team-coordination.md`, the BOARD legend, every relay line, `/coord-*` commands. | `you`, `your name`, `the relay` |
| `{{INTEGRATION_BRANCH}}` | The branch feature/fix work merges into first (and the only branch a session may merge into). | Git charter, git-permissions table, worker/manager flow. | `develop`, `dev`, `main` |
| `{{PROTECTED_BRANCHES}}` | Branch(es) no session may touch directly — PR only, human merges. | Git charter, git-permissions table. | `main, staging, production` |
| `{{DEV_URL}}` | The dev environment base URL (for stale-SHA / health checks). | Troubleshooting, health checks. | `https://dev.example.com` |
| `{{STAGING_URL}}` | The staging environment base URL; running a shell against it needs `{{HOST}}` approval. | Secrets & safety, troubleshooting. | `https://staging.example.com` |
| `{{HEALTH_ENDPOINT}}` | The path that reports the live build/SHA, for verifying what's actually deployed. | Stale-SHA check in troubleshooting. | `/health`, `/status` |
| `{{TIMEZONE}}` | The single timezone all board timestamps use, declared once in the board legend. | BOARD legend, entry timestamps. | `UTC`, `America/New_York` |
| `{{REPO_ROOT}}` | The absolute root of the project on disk, if the board lives outside the repo. Otherwise paths are repo-relative `./coord/...`. | `team-coordination.md` path refs. | `~/work/acme-app` |
| `{{BACKEND_REPO}}` | The backend repository name. | Role/handoff refs, card context. | `acme-app-backend` |
| `{{FRONTEND_REPO}}` | The frontend repository name. | Role/handoff refs, card context. | `acme-app-frontend` |
| `{{DOCS_REPO}}` | The docs repository name. | Role/handoff refs, card context. | `acme-app-docs` |
| `{{QA_DIR}}` | The directory / repo where QA artifacts (test plans, fixtures) live. | QA role, handoff refs. | `acme-app-qa`, `./qa` |
| `{{TEST_ACCOUNTS}}` | A **local-only** placeholder for test logins / accounts — **fill locally, NEVER commit.** Keep its file gitignored. | Secrets & safety, `.gitignore` note. | _(local file, never committed)_ |
| `{{STAKEHOLDER}}` | A generic non-engineering stakeholder reference (e.g. an MD / DPO / product owner) when one must be named generically. | `FYI` entries, escalation context. | `the product owner` |

> **Note on derived names.** Some tokens form compound strings:
> - `{{ASSISTANT}}` → the capture-note glob `*-{{ASSISTANT}}-*.md` and the `ASSISTANT_TAG` env value. These three (the hook glob, `capture.sh`, `session-start.sh`, `curate-cron.sh`) **must stay consistent** — see SETUP.md.
> - `{{DOMAIN}}` → `api.{{DOMAIN}}`, `{{DEPLOY_PLATFORM}}.{{DOMAIN}}`.
> - `{{PROJECT}}` → per-env DB names like `{{PROJECT}}_staging`.
> - `{{DEPLOY_PLATFORM}}` → the env var `{{DEPLOY_PLATFORM}}_API_KEY`.

---

## Things that are NOT a placeholder

A few values are intentionally generic rather than tokens — leave them as-is or fill the angle-bracket hint:

- `<project-root>` — wherever your project repo lives on disk (e.g. `~/work/acme-app`).
- `<TICKET-KEY>` / `<TICKET-KEY>-NN` — your tracker's ticket prefix (e.g. `PROJ`, `PROJ-123`).
- `<source-skill-repo>` — if you mirror skills from another repo, the source you edit.
- `<your-framework's ...>`, `<your machine>`, `<your timezone>` — fill with your real value or delete the line.
- `SOP-NN` — your own SOP code or a plain description of the activity.

These use `< >` (not `{{ }}`) precisely because they are free-form, not a fixed find/replace target.

---

## Find / replace recipe

Pick your values, then run one `sed` per token across the tree. The committed files use `~`-relative paths, so this is safe to run in place after you have cloned and **before** you copy `.claude/` into `~/.claude`.

```bash
# from the repo root — set YOUR values first
ASSISTANT=nova
USER=Alex
PROJECT=acme-app
ORG=acme-co
DOMAIN=acme.com
REPO=acme-app
VAULT='~/notes'
TRACKER=Linear
DEPLOY_PLATFORM=Render
REGISTRY='Docker Hub'
OBJECT_STORE=S3
OWNER_ROLE='your manager'

# team-coordination (COORD) tokens — only needed if you run the /coord-* workflow
HOST=you
INTEGRATION_BRANCH=develop
PROTECTED_BRANCHES='main, staging, production'
DEV_URL='https://dev.example.com'
STAGING_URL='https://staging.example.com'
HEALTH_ENDPOINT=/health
TIMEZONE=UTC
REPO_ROOT='~/work/acme-app'
BACKEND_REPO=acme-app-backend
FRONTEND_REPO=acme-app-frontend
DOCS_REPO=acme-app-docs
QA_DIR=acme-app-qa
STAKEHOLDER='the product owner'
# {{TEST_ACCOUNTS}} is intentionally NOT set here — it's a local-only, never-committed file.

# replace every token in every text file under the repo
grep -rlZ '{{' . --include='*.md' --include='*.json' --include='*.sh' \
  | xargs -0 sed -i '' \
    -e "s|{{ASSISTANT}}|$ASSISTANT|g" \
    -e "s|{{USER}}|$USER|g" \
    -e "s|{{PROJECT}}|$PROJECT|g" \
    -e "s|{{ORG}}|$ORG|g" \
    -e "s|{{DOMAIN}}|$DOMAIN|g" \
    -e "s|{{REPO}}|$REPO|g" \
    -e "s|{{VAULT}}|$VAULT|g" \
    -e "s|{{TRACKER}}|$TRACKER|g" \
    -e "s|{{DEPLOY_PLATFORM}}|$DEPLOY_PLATFORM|g" \
    -e "s|{{REGISTRY}}|$REGISTRY|g" \
    -e "s|{{OBJECT_STORE}}|$OBJECT_STORE|g" \
    -e "s|{{OWNER_ROLE}}|$OWNER_ROLE|g" \
    -e "s|{{HOST}}|$HOST|g" \
    -e "s|{{INTEGRATION_BRANCH}}|$INTEGRATION_BRANCH|g" \
    -e "s|{{PROTECTED_BRANCHES}}|$PROTECTED_BRANCHES|g" \
    -e "s|{{DEV_URL}}|$DEV_URL|g" \
    -e "s|{{STAGING_URL}}|$STAGING_URL|g" \
    -e "s|{{HEALTH_ENDPOINT}}|$HEALTH_ENDPOINT|g" \
    -e "s|{{TIMEZONE}}|$TIMEZONE|g" \
    -e "s|{{REPO_ROOT}}|$REPO_ROOT|g" \
    -e "s|{{BACKEND_REPO}}|$BACKEND_REPO|g" \
    -e "s|{{FRONTEND_REPO}}|$FRONTEND_REPO|g" \
    -e "s|{{DOCS_REPO}}|$DOCS_REPO|g" \
    -e "s|{{QA_DIR}}|$QA_DIR|g" \
    -e "s|{{STAKEHOLDER}}|$STAKEHOLDER|g"
```

> `{{TEST_ACCOUNTS}}` is deliberately left out of the find/replace — it points at a **local-only file you never commit**. Fill it on your machine and gitignore it (see [`team-coordination.md`](team-coordination.md) → Secrets & safety).

> macOS BSD `sed` needs the empty `''` after `-i`. On GNU/Linux use `sed -i` (no `''`).

After replacing, confirm nothing was missed:

```bash
grep -rn '{{' . --include='*.md' --include='*.json' --include='*.sh'   # should print nothing
```

> **กลั่นกรอง (TH):** ตั้งค่าตัวแปรของคุณก่อน แล้วรัน `sed` แทนทุก token จากนั้น `grep '{{'` ต้องไม่เหลืออะไร — ถ้าเหลือแปลว่ายังแทนไม่ครบ

For the runtime env vars the hooks read (`CLAUDE_VAULT`, `ASSISTANT_TAG`, `PROJECT_ROOT`), see **SETUP.md** — those are set in your shell profile / `settings.json`, not by this find/replace.
