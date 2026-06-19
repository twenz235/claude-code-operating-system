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
    -e "s|{{OWNER_ROLE}}|$OWNER_ROLE|g"
```

> macOS BSD `sed` needs the empty `''` after `-i`. On GNU/Linux use `sed -i` (no `''`).

After replacing, confirm nothing was missed:

```bash
grep -rn '{{' . --include='*.md' --include='*.json' --include='*.sh'   # should print nothing
```

> **กลั่นกรอง (TH):** ตั้งค่าตัวแปรของคุณก่อน แล้วรัน `sed` แทนทุก token จากนั้น `grep '{{'` ต้องไม่เหลืออะไร — ถ้าเหลือแปลว่ายังแทนไม่ครบ

For the runtime env vars the hooks read (`CLAUDE_VAULT`, `ASSISTANT_TAG`, `PROJECT_ROOT`), see **SETUP.md** — those are set in your shell profile / `settings.json`, not by this find/replace.
