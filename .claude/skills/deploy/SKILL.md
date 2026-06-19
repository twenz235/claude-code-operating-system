---
name: deploy
description: >
  Deploy frontend/backend services to any environment (dev/staging/prod), or
  scaffold a new env/project, via a deploy-platform API + container-registry
  image pull, following a 3-layer manifest-driven template (L1-L7 invariants +
  G1-G6 governance gates). Trigger when you need to deploy, add an env, port the
  template to a new repo, roll back, or run a production migration.
  Glossary (TH): deploy เพื่อนำของขึ้น env / scaffold = ตั้งค่า env ใหม่ / rollback = ย้อนกลับ.
  deploy staging production rollback compose health smoke-test migrate registry manifest
---

# deploy — Deploy via a 3-layer template

References: your CI/CD SOP, `.deploy/envs.yml` manifest, an ADR for the deploy
architecture, and your team charter (`docs/CHARTER.template.md`) on
quality > speed, written/auditable decisions, security, and bus-factor.
Reference impl (example): a `{{REPO}}-backend` + `{{REPO}}-frontend` pair on a
`feat/deploy-template` branch.

> The platform names below ({{DEPLOY_PLATFORM}}, {{REGISTRY}}, the web/queue/DB
> stack) are **examples**. Swap in your own PaaS, registry, and stack — the
> invariants (L*) and gates (G*) are the portable part.

## When to use
- **Deploy** frontend/backend to any environment.
- **Scaffold a new env** (e.g. open staging/prod) for an existing repo.
- **Port the template** to a new repo/project.
- **Roll back**, or run a **production migration**.

## Framework — 3 layers (do not mix them)
```
Layer 1 MECHANICS  → files in repo: deploy.yml + a deploy composite action +
                     compose file + Dockerfile. Holds invariants L1-L7.
                     Byte-identical across repos (except Dockerfile per stack).
Layer 2 VALUES     → .deploy/envs.yml — every value that differs per env/project.
                     Edit it here, in one place.
Layer 3 GOVERNANCE → this skill — how to use it + gates + runbook.
```
Iron rule: **env-specific values must never be hardcoded in the workflow** —
they live only in the manifest. `deploy.yml` maps `branch/tag → env`, then a
YAML reader (e.g. `yq`) loads the manifest as JSON.
> TH: ค่าเฉพาะ env ห้าม hardcode ใน workflow — อยู่ใน manifest อย่างเดียว.

## Procedure

### A. Scaffold a new env (e.g. staging)
1. **PREFLIGHT (hard-stop):** the health endpoint must be public (no auth) and
   must return `.commit` = the baked `GIT_SHA`. If it doesn't → stop. This
   prevents a false-green at the source (L2/L5/L6).
2. Add an env block in `.deploy/envs.yml` — the deploy-platform service id
   (`compose_id`) **must be brand new; never reuse dev's** (G3).
3. Create a new service on your deploy platform → get its service id → put it in
   the manifest → **disable the platform's own git auto-deploy / push-webhook in
   the UI** (L1; some platforms ack the webhook 200 then no-op — keep deploys
   driven by the API/workflow, not the platform's git hook).
4. Create a CI environment named after the env. If `approval: manual` (prod) →
   require reviewers (e.g. {{OWNER_ROLE}} + tech lead) (G1). dev/staging don't
   need approval.
5. Create a **separate** DB/cache for the env and set the service's `.env` —
   **generate fresh values, never copy dev's** (so a dev `DATABASE_URL` can't
   leak in, G3). Values the workflow does **not** push you must set here:
   - `IMAGE_TAG=<env>-latest` (dev/staging) or `=vX.Y.Z` (prod). **If unset, the
     compose default is `dev-latest` → staging/prod would serve the DEV image**
     (check your compose file).
   - `MIGRATE_ON_BOOT=false` for staging/prod (G2) — backend only. dev may leave it true.
   - The env's `<framework secret key>`, `DATABASE_URL`, `<cache URL>`,
     `<error-tracker DSN>`, `<allowed hosts>`, `<CORS origins>`.
   - **prod also:** override compose `pull_policy` to `missing` (immutable tags
     must not force-pull on restart, L3).
   - Frontend: the public API host/URL is **baked as a build-arg** from the
     manifest — do not set it here.
   - **PRE vs POST:** values that make smoke **red** if missing = PRE (must be
     complete before deploy): framework settings module / secret key / frontend
     URL / allowed-hosts (+localhost) / `IMAGE_TAG` / DB vars + deploy-API key /
     registry creds / service id / DB / DNS. Values you can fill in later while
     deploy stays green = POST: error-tracker DSN / LLM keys / email vars /
     payment vars / CORS (set before the real frontend ships) / public API host
     (set before chat features). Full table: runbook §1.5.
6. Generate the runbook `.deploy/runbooks/rollback.<env>.md`.

### B. Deploy
- **dev/staging:** push the branch named in `branch_trigger` (e.g. `develop` / `staging`).
- **prod:** push a `v*.*.*` tag (not a branch) → stop at the approval gate →
  {{OWNER_ROLE}} / tech lead approves.
- `deploy.yml` runs: `ci` (gate, G5) → `resolve` (read manifest) →
  `build-and-push` (registry image, tagged with `GIT_SHA` + per-env build args)
  → `deploy` (composite action).
- **manual:** `gh workflow run deploy.yml -f environment=<env>` (or your CI's equivalent).

### C. Verify (automatic in the composite action — do not bypass)
- Assert `health.commit == baked SHA` (not just HTTP 200 — a stale image also
  returns 200, L2).
- If red: read the error → classify the mode → `STALE_IMAGE` (pull_policy /
  IMAGE_TAG, L3) · `HEALTH_NOT_PUBLIC` (L5) · placeholder service id (env not
  finished being set up).

### D. Rollback
- Find the old tag: `gh release list`, or the image tags in the registry (`<env>-<sha>`).
- dev/staging: redeploy by pinning the old `IMAGE_TAG=<env>-<sha>` in the
  service `.env`, then redeploy. (A mutable `-latest` tag **can't be a rollback
  target** — it's already been overwritten.)
- prod: redeploy the previous immutable `v*.*.*`. Smoke against the baked SHA
  **of that tag** (not HEAD) — otherwise a correct rollback shows as false-red.
- Target RTO ≤ 30 min (your DR SOP). If a migration is involved → see E + consult {{OWNER_ROLE}}.

### E. Migration (prod) — gated
- The prod entrypoint does not auto-migrate (`MIGRATE_ON_BOOT=false`).
- `migrate --plan` → paste the plan into your tracker/runbook → **{{OWNER_ROLE}}
  approves in writing** (written/auditable decision per your charter) → apply via
  the gated workflow → smoke + monitor for 1 hour.

## Output Template (before dispatch — for a human to ack)
```
Deploy plan
  repo:      <{{REPO}}-backend | {{REPO}}-frontend>
  env:       <dev|staging|prod>     approval: <auto|manual>
  trigger:   <push develop | push staging | tag vX.Y.Z>
  image:     <registry_image>:<tag>     mutable: <true|false>
  serviceId: <id>   (placeholder? → STOP)
  health:    <health_url>   expect .commit == <sha>
  migration: <none | gated ({{OWNER_ROLE}} approve)>
```

## Rules (invariants — do not touch)
- **L1** Deploy via the platform API / workflow only — not the platform's git
  push-webhook (it may 200-then-no-op).
- **L2** Smoke always compares `.commit == SHA` — HTTP 200 is not evidence.
- **L3** Mutable tag (`*-latest`) → compose `pull_policy: always`; immutable prod
  tag → don't force-pull (avoids a restart pull-fail).
- **L4** Healthcheck uses `127.0.0.1` + `HOSTNAME=0.0.0.0` — not `localhost`
  (on some minimal images `localhost` resolves to `::1` → 404).
- **L5** Health route is public (bypasses auth, no cookie).
- **L6** `GIT_SHA` build-arg → ENV → surfaced at health `.commit`.
- **L7** The frontend's API host/URL is a **build-arg baked per env** (a runtime
  `.env` won't override compiled rewrites).
- **G1** Prod goes through human approval (CI environment required-reviewers).
  **G2** Prod migration is gated + approved by {{OWNER_ROLE}}.
  **G3** Each env has its own DB/cache; staging holds no prod PII.
  **G4** There is a rollback path + a runbook a stand-in can read.
  **G5** Deploy is gated on ci-success.
  **G6** Deploy is deterministic, SHA-pinned, in-repo.
- **Do not push/merge to protected branches yourself** — open a PR for
  {{USER}} / {{OWNER_ROLE}} to merge (git-safety; see your charter).
- **The deploy-API key lives only as a CI secret** — never on a local machine or
  in an agent (security; see your charter).

## Exit / Escalation
- Smoke red twice → roll back immediately (D), do not patch-in-prod; open an
  incident + write a post-mortem within 48h (`/post-mortem`).
- Changing the CI/CD architecture → `/adr-draft` first.
- Prod migration → only with {{OWNER_ROLE}} sign-off (E). Prod down > 30 min →
  escalate to {{OWNER_ROLE}} immediately (your DR SOP).
- Refusing / routing out-of-scope work → `/refuse-list`.
