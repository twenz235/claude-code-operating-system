---
name: test
description: Run the real test suite the way a ship-loop would, but stop at "test + HTML report" — never ship. Detect test commands from the repo, spawn a test-loop subagent (report-only by default, or --fix), and emit a clean report that states pass/fail/flaky/SKIP honestly. Never touches git. Glossary (TH): รันเทสจริง + รายงาน ไม่ commit/push. Trigger when you want to know if the work is green, test a PR before review, or run tests + report without committing. test report no-ship report-only fix test-loop layers coverage
---

# test — Test + Report, No Ship

Take your full dev/ship loop and delete the bottom half (commit → push → PR → merge). This skill stops at "ran every layer + opened an HTML report" — **it never touches git** (read-only against the repo). When the test run is heavy, it spawns a `test-loop` subagent, the same way a ship loop would.

> Glossary (TH): เหมือน loop ส่งงานเต็ม แต่ตัดครึ่งล่างทิ้ง จบที่ "รันครบทุก layer + เปิด report" — ไม่แตะ git เลย.

## GOLDEN RULES (do not violate)
1. **Never fake a pass.** Even in `--fix`, you may not weaken assertions, `skip`, lower the coverage gate, or add `@ts-ignore` to make red go green. Red means fix the *code under test*, not the test. Glossary (TH): แดง = แก้โค้ด ไม่ใช่แก้เทส.
2. **Report pre-existing and flaky results honestly** — never fold them into the verdict to make it look greener than it is. (See your team charter, `docs/CHARTER.template.md`, on truthful reporting.)
3. **SKIP-with-note is not a silent pass.** A layer the repo does not support is reported as `SKIPPED — <reason>`, not omitted.
4. **Stay in scope.** `--fix` changes only what is needed to make the *change's* tests pass; it does not refactor neighbouring code.
5. **Never ship.** No commit / push / PR / merge under any circumstances. You can run on any branch (including protected ones) precisely because you never write to git.
6. **report-only = strictly read-only** — the test-loop may not edit any file; on red it diagnoses and reports, nothing more.

## MODE (flag; default is report-only)
- **report-only** (default): the test-loop runs each layer once, may not Edit/Write, and on red it diagnoses + reports without changing anything. Retry cap = 1. Fast and safe.
- **`--fix`**: red → diagnose → fix → rerun (cap 3), but it stops before any commit. If it passes and you then want to ship, hand off to your full ship/delivery loop.

## STEP 0 — DETECT (gate: stop-ask)
Resolve the test / lint / typecheck / build / e2e commands and the coverage gate in this order (ground truth — never guess). This mirrors a ship loop's detect step but **drops the branch guard** (read-only, so any branch is fine):
1. Read a repo-level loop config if one exists (e.g. `.fullloop.yml` / `.testloop.yml`) at the repo root — it may declare test/lint/typecheck/build/e2e commands, the coverage gate, and which layers apply.
2. Otherwise parse the CI workflow (e.g. `.github/workflows/ci.yml`) and use the *same* commands CI runs, plus the names of any required checks.
3. Otherwise detect the stack: `package.json` → JS/TS frontend (`lint` / `typecheck` / `test` / `build` scripts); `pyproject.toml` / `requirements.txt` → Python backend (linter / type checker / test runner such as `ruff` / `mypy` / `pytest`); adapt to whatever the project actually uses.
4. If the task runner is unusual and detection fails → **stop and ask** for the commands (do not guess).

Read the coverage gate from the real CI config; do not hardcode a number. If your repo defines a per-repo command table, treat that as the default when detection matches it.

## STEP 1 — SCOPE (gate: auto)
Changed files define the test-loop's boundary. Resolve in order:
(a) An explicit argument — a PR number (check it out, list its files), a branch, or a file list.
(b) The uncommitted working tree (`git status -s` + `git diff --name-only`).
(c) A diff against your integration branch (`git diff --name-only origin/<integration-branch>...HEAD`, e.g. `develop`/`main`).
If there are no changes at all → run a **baseline** full suite and label it in the report: "no changes — full-suite baseline".

## STEP 2 — TEST (spawn the test-loop subagent)
Spawn the `test-loop` subagent and pass it: the **MODE** (report-only → "do not Edit/Write any file, run each layer once, on red diagnose + report without fixing, retry cap = 1" / fix → default cap 3), the project type, the resolved commands (STEP 0), the scope files (STEP 1), the layers the repo actually supports, and the repo path. Let it run and return a per-layer handoff.
- Frontend e2e usually needs a backend spun up and seeded (e.g. a local database) — that is heavy. With a quick/fast flag or `--layers unit`, skip e2e and mark it SKIP-with-note.
- If the subagent hits its retry cap (in fix mode) or the harness itself breaks (backend won't start / seed fails), it returns a `blocked_reason` → report it honestly; do not brute-force.

## STEP 3 — HTML REPORT (gate: auto)
Emit a clean, calm HTML report (see the report style in your conventions) and open it in the browser:
- A per-layer results table: layer / status (pass | fail | flaky | SKIPPED) / command / detail.
- Coverage actual vs gate (when measurable).
- **Pre-existing and flaky results called out separately and honestly** (never hidden).
- Files the test-loop touched (only in `--fix`).
- A run log: mode, retry cap, and the reason each loop stopped (auditable).
- A verdict: pass | needs-attention + the next step (e.g. "all green → ready to ship via your delivery loop").

## ARGS
- `/test` → report-only, current working tree / branch, every layer the repo supports.
- `/test --fix` → fix mode (cap 3, stops before commit).
- `/test <PR#>` → fetch the PR head, scope = its diff, report-only (test a PR before review).
- `/test --layers unit` | fast mode → unit/static layers only, skip e2e.

## OUT OF SCOPE
No commit / push / PR / merge / deploy. Does not change branches. When you want to ship afterwards, hand off to your full delivery loop.

> Optional preference: if your team documents an "author your own commit/PR text" rule (e.g. no automated tool-attribution lines), this skill respects it because it writes nothing to git at all. That rule is an opt-in documented preference, not a hardcoded law.
