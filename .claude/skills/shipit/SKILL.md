---
name: shipit
description: Drive the full dev loop passively from design -> make -> test (loop until green) -> e2e -> commit -> push -> conflict-check -> PR into the integration branch -> wait for CI green -> merge integration -> report. Runs autonomously in the feature->integration lane, stops to ask at judgment gates; never touches main/staging/prod. Trigger when told to "ship / shipit / finish the line / run the whole loop" after design is agreed.
---

# shipit — Passive Full-Loop Dev Conductor

Drives the full dev loop from "design agreed" through "merged into the integration branch + report".
Runs **autonomously by default in the feature->integration lane**, stops to ask only at gates that need judgment, and **never touches main/staging/prod**. Same model as a deploy runner: "orchestrate, never deploy by hand."

> This is an **orchestrator playbook** — it lives in the main loop so it can (a) call your existing skills (a subagent can't) and (b) stop to ask you mid-loop, then continue with full context. The heavy test work (steps 3–6) is spawned as a `shipit-loop` subagent that runs in its own context and returns a handoff.
> ปรับ branch names / commands ให้ตรง repo ของคุณ — ค่าตั้งต้นด้านล่างเป็นตัวอย่าง

## GOLDEN RULES

1. **You may only merge into the integration branch** (example name: `develop`). feature->integration = the agent may run `gh pr merge --merge` itself. **PR/merge into main|master|staging|prod is HUMAN-ONLY** — you may open the PR, but you may NOT click merge even if told to (decline per your out-of-scope policy; see the example `refuse-list` skill under examples/).
2. **Always a merge commit** (`gh pr merge --merge` / `git merge --no-ff`). Avoid squash/rebase-merge — they cut ancestry and produce phantom conflicts next round. (This is a defensible default; pick whatever your team's charter says and be consistent.)
3. **AI attribution in commits/PRs is an OPTIONAL, documented team preference** — it is NOT hardcoded law here. If your team chooses to omit `Co-Authored-By` / "Generated with" trailers, record that choice in your charter and follow it. Otherwise, follow the harness default.
4. **Never use `git push --no-verify` to bypass a guard.** If you'd push a protected branch -> stop and ask.
5. **Never cut/skip a CI/test/security gate for a deadline**, and **never edit a test just to make it pass.** A red test means fix the code, not the test. (Charter principle: *quality > speed*.)
6. **SKIP-with-note is not silent-pass.** A layer the repo doesn't have (e2e / AI-user / ux / i18n) may be skipped, but you MUST **state in the report that it was skipped and why** — never present it as passed.
7. **Verify, don't trust.** CI green = read it from `gh pr checks` for real; merged = read real state; integration healthy = real smoke SHA match — don't infer from an exit code alone.
8. **Only do the scope that was asked.** Touching out-of-scope / refactoring neighbors -> stop and ask. (Charter principles: *surgical changes*, *simplicity first*.)

## The 3-level passive model

**AUTO** (run without asking): make -> test-until-pass (within the retry cap) -> e2e -> [Phase >=1: AI-user -> ux] -> self-review -> commit -> push feature -> conflict-check vs integration (mechanical resolves only) -> open PR -> integration -> wait CI green -> **merge integration** -> verify integration green -> HTML report.

**STOP-ASK** (stop, summarize status + options, wait — not a dead wall):
- ambiguous spec / >1 load-bearing interpretation (step 1)
- test loop hits the retry cap (default 3)
- coverage below the repo's gate
- a **logical** conflict with the integration branch (don't guess someone else's intent)
- repeated CI red that isn't flaky
- e2e fails after a re-do
- touching **security / privacy / auth / RBAC / secrets / migration / infra** -> requires 2 reviewers (CODEOWNERS) — the agent cannot self-approve
- needing to expand scope beyond the boundary

**HUMAN-ONLY** (you only — the agent declines even if told to):
- merge/PR-merge into main|master|staging|prod
- prod deploy · prod migration (requires written approval from your {{OWNER_ROLE}})
- cutting a CI/test/security gate

> **The autonomous edge ends at "merged into integration + integration CI green + report opens".** It does not spill into deploy/prod and does **not** open an integration->main PR for you unless you ask. If you ask it to go further toward main, it opens a PR (it does not merge).

## STEP 0 — INTAKE + PROJECT DETECT (gate: stop-ask)

1. **Ticket/AC:** if there's no ticket yet -> use `to-ticket` (or your tracker's equivalent) to draft verifiable acceptance criteria (draft only, don't save it yourself). If the AC isn't verifiable -> stop-ask.
2. **Check branch:** you must be on a feature branch — **never run the loop on a protected branch** (`main|master|develop|staging` or your equivalents). If on a protected branch -> stop-ask to cut a feature branch first.
3. **Resolve test commands / branch in order (ground truth — never guess):**
   1. Read `.fullloop.yml` at the repo root if present (test/lint/typecheck/build/e2e cmd, coverage gate, integration branch, deploy workflow).
   2. No manifest -> parse `.github/workflows/ci.yml` (the exact commands CI runs) + the required-check name.
   3. No `ci.yml` -> detect the stack: a JS/TS manifest (e.g. `package.json`) -> frontend (`lint/typecheck/test/build` scripts); a Python manifest (e.g. `pyproject.toml`/`requirements.txt`) -> backend (`ruff/mypy/pytest`, etc.). Adapt to your stack.
   4. An unusual task runner (make/just/nx) you can't detect -> **stop-ask for the command** (don't guess).
4. **Integration branch:** default to your team's integration branch (verify from the deploy workflow). If the repo uses a different name, read it from the manifest/CI.

### Reference: example repo command matrix (use as a default only if detection matches)

This is an **illustrative** matrix — replace every cell with your project's real commands.

| | frontend (example) | backend (example) |
|---|---|---|
| lint | `npm run lint` | `ruff check .` (blocking) |
| typecheck | `npm run typecheck` | `mypy …` (advisory) |
| test | `npm run test` | `pytest --cov-fail-under=<gate>` |
| build | `npm run build` (needs build-time API host env) | — |
| i18n | `npm run i18n:check` | — |
| e2e | `npm run test:e2e:auto` | — |
| security | (`npm audit`) | `bandit` + your dependency-audit tool |
| migration | — | your framework's `makemigrations --check --dry-run` equivalent |
| required check | the CI "success" job name | the CI jobs |
| integration | integration branch | integration branch |

> Read the coverage gate **from the repo's real CI config**, not hardcoded.

## STEP 1 — THINK + SPEC (gate: stop-ask)

Call `think-before-coding` + `goal-driven-execution`; touching an API -> `backend-api-contract` (spec before code); changing architecture -> `adr-draft`.
Turn AC -> a success-criteria table. >1 load-bearing interpretation or an important unknown -> **stop-ask with the tradeoff**.

## STEP 2 — BRANCH + IMPLEMENT (gate: stop-ask)

1. `git fetch origin <integration>` -> verify the feature branch is cut from the latest integration (if badly diverged, propose rebasing/merging integration into the feature — if the conflict is logical -> stop-ask).
2. Implement per `surgical-changes` + `simplicity-first` — every line traces back to an AC, vertical slice, **no refactoring of neighbors**. Touching out of scope -> stop-ask.

## STEP 3–6 — TEST (spawn subagent `shipit-loop`)

Spawn the **`shipit-loop`** subagent (Agent tool, `subagent_type: "shipit-loop"`) and let it run the heavy test loop in a separate context, returning a handoff. Pass it: project type, the resolved commands, AC + success criteria, the list of touched files, which layers to run, retry cap = **3**.

Layers:
- **3 unit-loop** (`lint + typecheck + unit + build + i18n`) — red -> diagnose -> fix -> repeat (cap 3). Pass = 0 errors + coverage >= the repo's gate.
- **4 UI scenario + e2e** (frontend) — added use-case -> write the spec (RED) before making it green. Backend-only -> SKIP-with-note.
- **5 AI-user test** — drives the app like a real user via an LLM SDK (vendor-neutral). **Default = SKIP-with-note** until the harness script and SDK exist in the repo. Audit any new dependency before enabling.
- **6 ux/ui-wrong test** (a11y + visual + i18n) — default = i18n check only (if it ran in step 3); a11y/visual = SKIP-with-note until the tooling (e.g. axe-core) is added.

The subagent returns its result -> if all layers pass (or SKIP-with-note) continue; if it hits the retry cap -> **stop-ask** with root-cause + diff + honestly labeling any pre-existing/flaky tests (don't bury them).

### quickmode short-circuit (micro-fix)
If the change is **micro** (typo / copy / style-only / comment — no logic/API/auth change) -> skip steps 4–6 entirely **but still run step 3 (unit+lint+typecheck) in full**. State in the report that it short-circuited because it was a micro-fix.

## STEP 7 — PRE-COMMIT GATE (gate: stop-ask)

- Touching PII/auth/RBAC/secrets -> run your security/privacy review skill. Any finding -> **stop-ask: requires 2 reviewers (e.g. the tech lead + a separate security/compliance reviewer, via CODEOWNERS) — the agent cannot self-approve**.
- `scrutinize` + a self-review (e.g. the built-in /code-review) on the diff: intent/simplicity/scope/security/test/contract.
- Significant decision -> `charter-check`. A charter violation (e.g. being pushed to cut a gate) -> **hard-stop, decline** (per your out-of-scope policy; see the example `refuse-list` skill under examples/).

## STEP 8 — COMMIT (gate: auto)

`git commit` on the feature branch. Message = conventional `type(scope): desc` referencing the ticket (e.g. `PROJ-123`). Follow your team's attribution preference (see Golden Rule 3). Nothing to commit -> stop (the loop produced no change).

## STEP 9 — PUSH (gate: auto)

`git push -u origin <feature>`. If you'd push a protected branch or a hook blocks -> **stop, do NOT `--no-verify`** -> stop-ask. Non-fast-forward -> `git fetch` + report + stop.

## STEP 10 — CONFLICT CHECK vs integration (gate: auto)

`git fetch origin <integration>` -> check mergeability: after opening the PR use `gh pr view --json mergeable` (`MERGEABLE`/`CONFLICTING`), or trial `git merge --no-commit --no-ff origin/<integration>` in a throwaway worktree then `git merge --abort` + cleanup.
- **mechanical** conflict (lockfile / import order) -> resolve on the feature branch + push again (counts toward the cap of 3).
- **logical** conflict -> **stop-ask** (don't guess someone else's intent).
- worktree crash -> cleanup + report.

## STEP 11 — OPEN PR -> integration (gate: auto)

`gh pr create --base <integration>` with a body: ticket link (CI blocks if missing), type, coverage, **the result of every test layer including SKIP-with-note for skipped layers**. Follow your attribution preference in the body.
If CODEOWNERS routes to security/infra/migration -> flag 2-reviewer + the agent cannot self-approve.

## STEP 12 — WAIT CI green (gate: stop-ask)

`gh pr checks <pr> --watch` (or `gh run watch`) until every required check is green.
> Note: if CI doesn't run e2e, that's fine — e2e ran locally in step 4.
- Red that isn't flaky -> go back to step 3 (counts toward the cap of 3). Flaky -> `gh run rerun` once. Hit the cap -> **stop-ask + name which check is red** (honestly). **Never skip the gate.**

## STEP 13 — MERGE -> integration (gate: auto)

Before merging, **confirm `--json baseRefName` == the integration branch** — if not, **HARD ABORT** (never merge into anything else).
`gh pr merge <pr> --merge --delete-branch` (merge commit `--no-ff`; avoid squash/rebase). Verify the ticket -> Done.
Merge race / CI flips red -> stop and report, don't force.

## STEP 14 — VERIFY integration + HTML REPORT (gate: auto)

- Integration push -> the integration env auto-deploys (if you have one). Spawn a read-only deploy runner or `gh run watch` to wait for a green deploy + smoke SHA match.
- Produce an **HTML report** (your house style; this template uses a clean off-white "MUJI" tone): before/after screenshots + a change table + **a table of every test layer, labeling red/pre-existing/SKIP honestly** -> open it for the user.
- Print a **run-log** that records the retry cap + why each loop stopped (auditable).
- Integration goes red after merge -> `triage` + alert immediately + **propose** a revert PR (don't revert yourself = a human decision).

## STEP 15 — HANDOFF (gate: human-only for main/prod)

`handoff` returns: goal / state+evidence / decisions+why / open questions / next.
If you're asked to go further -> you may **open** a PR `integration -> main`/`staging` (`gh pr create --base main`) **but merging is the human's job only**. prod = gated environment + deploy via your CI only (through a deploy runner/conductor) — **never hit the {{DEPLOY_PLATFORM}} API directly**.

---

## Default scope (current)
- step 0–4, 7–15 with assets that exist
- step 5 (AI-user) + step 6 a11y/visual = **SKIP-with-note** until you build the harness scripts (audit dependencies first)
- defaults: retry cap = 3 · quickmode short-circuit (micro-fix skips 4–6, still runs 3)

## Appendix — `.fullloop.yml` schema (optional per-repo, fallback = ci.yml)
```yaml
# .fullloop.yml — if absent, shipit parses .github/workflows/ci.yml instead
integration_branch: develop          # the branch the agent may merge into itself
stack: frontend                      # frontend | backend | other
commands:
  lint:       npm run lint
  typecheck:  npm run typecheck
  test:       npm run test
  build:      npm run build          # required env goes in build_env
  i18n:       npm run i18n:check
  e2e:        npm run test:e2e:auto  # omit = no e2e -> SKIP-with-note
build_env:
  API_URL: https://api.{{DOMAIN}}    # example build-time host
coverage_gate: 70                    # omit = read from ci.yml
required_check: ci-success           # the job/check that must be green before merge
deploy_workflow: deploy.yml          # integration push -> integration env (auto)
layers: [unit, e2e]                  # layers the repo supports; others = SKIP-with-note
```
