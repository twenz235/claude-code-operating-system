# coord QA runbook / handoff template

> Reusable QA reference for the `qa-<n>` sessions: how to point at an env, which accounts
> to use, and techniques worth reusing. **Template only** — fill the placeholders locally.
>
> ⚠️ **Never commit live credentials, UUIDs, tokens, keys, or host/IP details to this
> repo.** Keep the real values in an untracked local file (see {{TEST_ACCOUNTS}} below)
> and add that file to `.gitignore`. This runbook ships with placeholders only.

## Environments

| Env | Base URL | Health check | Notes |
|---|---|---|---|
| dev | {{DEV_URL}} | {{HEALTH_ENDPOINT}} | <!-- what dev is wired to; stub vs real services --> |
| staging | {{STAGING_URL}} | {{HEALTH_ENDPOINT}} | <!-- closer-to-prod config; gated --> |

**Before verifying anything:** curl the health endpoint and confirm the deployed `<SHA>`
matches the merge you intend to test (the env can lag the merge).

## Test accounts — {{TEST_ACCOUNTS}}

> **Fill locally, NEVER commit.** Create an untracked file (e.g. `./coord/.qa-secrets`
> ignored by `.gitignore`) holding the real logins per role. Reference it from your
> session; do not paste real values into memory files, the board, or this runbook.

| Role | Account placeholder | Used for |
|---|---|---|
| owner / admin | {{TEST_ACCOUNTS}} | full-permission flows |
| manager | {{TEST_ACCOUNTS}} | delegated-permission flows |
| worker / member | {{TEST_ACCOUNTS}} | restricted flows |
| non-member | {{TEST_ACCOUNTS}} | negative / enumeration checks (expect 404, not 403) |

`.gitignore` note (add to repo root):
```
# QA local secrets — never commit
coord/.qa-secrets
```

## Env recipe stubs

<!-- Per-env setup steps to reach a testable state. Keep generic; no creds inline. -->
- **dev recipe:** <!-- how to seed / reset / log in on {{DEV_URL}} --> _TODO_
- **staging recipe:** <!-- how to reach a clean state on {{STAGING_URL}} --> _TODO_

## Reusable technique notes

<!-- Durable how-tos that survive across cards. Keep them generic and credential-free. -->
- **Multi-role pass:** exercise each role (owner / manager / worker / non-member) against
  the same flow; confirm permissions hold from every angle.
- **Enumeration / IDOR check:** as a non-member, request another tenant's object by id —
  expect **404, not 403** (the response must not leak existence). _TODO: per-flow steps._
- **Responsive UI pass:** test the key mobile widths (e.g. 320 / 360 / 390). _TODO._
- **SHA gate:** always confirm `{{HEALTH_ENDPOINT}}` `<SHA>` before trusting a verdict.

## Tick the Acceptance Criteria (after verifying)

Before you hand a verdict back, update the **card's** AC checkboxes so the card mirrors
reality — the card is the single source of truth for progress:

- PASS = `[x]` · FAIL / pending = `[ ]` + the reason · device- or host-gated (you can't run
  it) = `[ ]` + a flag for who must run it.
- **Never tick a criterion you didn't actually test.** "AC coverage `<x/y>`" in the handoff
  must match the boxes you actually ticked. _เทสเสร็จติ๊ก AC ตามจริง · ห้ามติ๊กข้อที่ยังไม่เทส_

## Handoff template

<!-- Paste into a board ↳ reply when handing a verdict back. -->
```
↳ [qa-<n>] <MM-DD HH:MM> · DONE · <CARD-ID> verdict on <env>: PASS / PARTIAL / FAIL
- AC coverage: <x/y>   (matches the AC checkboxes ticked on the card)
- evidence: <what you observed; no creds>
- residual: <follow-ups or none>
```
