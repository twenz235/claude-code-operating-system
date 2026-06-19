---
name: design-cards
description: >
  Design a feature/improvement, or turn a bug list into fix approaches, and
  finish by creating tracker cards for devs to pick up — without implementing
  it yourself. Trigger on "design X and open the cards" or when handed a bug
  list to break into cards.
  Glossary (TH): ออกแบบแล้วเปิดการ์ด ไม่ลงมือ implement เอง.
  design feature improve bug-list tracker cards dev handoff
---

# design-cards — Design → Tracker Cards Conductor

References: your issue-tracking SOP + your team charter (written/auditable
decisions) + the `shipit` pattern (an orchestrator skill in the main loop
that spawns agents for the heavy work).

**This skill's job = design + create cards for someone else to build.** It ends
when the cards exist in your tracker. It does not spill over into implementation.

> Tracker note: examples below use a tracker MCP (e.g. Linear MCP:
> `save_issue` / `list_issues` / `get_issue`). Swap in your tracker's MCP/CLI
> (Jira, GitHub Issues, etc.). Ticket keys are written as `<TICKET-KEY>-NN`
> (e.g. `PROJ-123`).

## When to use / not use

Use:
- "Design feature X and open cards for the devs."
- An improvement that needs an approach worked out before handing it to the team.
- A **bug list** is handed over → break it into per-bug cards with triage + a fix approach.

Don't use:
- Work you'll implement end-to-end yourself → `/shipit`.
- A single card from a conversation with no design needed → spawn the
  `tracker-card` agent directly.
- A raw idea that isn't real work yet → capture it in your notes inbox (see `to-ticket`).

## GOLDEN RULES (do not violate)

1. **Output = design + cards only** — no code changes, no commit/push/merge. If
   asked to continue → `/shipit`.
2. **Never `save_issue` before the human acks the draft** — keep the
   `tracker-card` agent's own rule in every case.
3. **Every card is grounded in a real file:line** (via the `tracker-card`
   agent) — if you can't find it, say so; never fabricate.
4. **Every acceptance criterion is verifiable** — "works better" doesn't pass; it must be measurable.
5. **1 card = 1 concern**, vertical slice, size ≤ ~2 dev-days — split larger ones and add relations.
6. **AI attribution in cards/output is an optional, documented team preference** —
   follow your team's convention; don't hardcode it as law.
7. **Don't assign an owner that wasn't agreed** — default to unassigned so the
   human grooms it (see `task-manager`).

## STEP 0 — INTAKE (gate: stop-ask if ambiguous)

1. Classify the mode: **FEATURE** (new), **IMPROVE** (change existing), or
   **BUGLIST** (a list of ≥1 bug).
2. Identify the target repo(s) (FE / BE / both) + what is explicitly **out of scope**.
3. If the request has > 1 load-bearing interpretation → **stop-ask with the
   trade-offs** (`think-before-coding`); don't guess silently.
4. BUGLIST: split the list into individual bugs — 1 bug = 1 candidate card; bugs
   that are the same symptom from one root cause → fold into one card with a note.

## STEP 1 — GROUND (auto)

- Spawn an **`Explore` agent** (read-only) to inspect the real code: current
  state, existing patterns to reuse, file:line — the heavy reading stays out of the main context.
- Load-bearing claims ("how does the current thing work") → verify against real
  code, don't guess (explore/verify before acting).
- BUGLIST: per bug → a repro path + a root-cause hypothesis (`debug-mantra`,
  diagnose level only — **do not fix here**).

## STEP 2 — DESIGN (auto → gate)

- **FEATURE:** success criteria (`goal-driven-execution`) → ≥2 options + pick
  1 with reasons (explain your design choice) → slice into vertical-slice cards.
- **IMPROVE:** a real baseline (measured numbers / verified pain) → target →
  approach → slices.
- **BUGLIST:** triage **P0-P3** (`triage` impact matrix) + a fix approach per
  bug; a P0 that must be fixed now → escalate the fix-now path, not a waiting card.
- Touches important architecture → draft an ADR (`adr-draft`), attached or as a separate card.
- New API / contract change → the card must require **contract-first**
  (`backend-api-contract`: OpenAPI before code).
- Touches PII/auth/RBAC/secrets/migration → **flag a 2-reviewer requirement
  (CODEOWNERS)** on the card (security/privacy review skill).

**GATE (adaptive):**
- ≤ 3 cards and no ADR → go straight to STEP 3 (collect one ack at STEP 4).
- ≥ 4 cards or an ADR present → **stop-ask with a design summary** (a table:
  card + 1 line + priority + relations) before drafting.

## STEP 3 — DRAFT (auto)

- Spawn **one `tracker-card` agent per card** — for several, spawn in parallel in one message.
- Give each: mode, that card's design summary, file:line from STEP 1, priority
  (from triage), the relations you have in mind.
- Get back: a draft following the template **context → approach → gotcha →
  acceptance criteria → main files** + a duplicate-check note.
- The orchestrator adds: **estimate (S/M/L)** + a cross-card relations check
  (blocked-by / parent / related) so they don't conflict.

## STEP 4 — ACK + CREATE (gate → auto)

1. Show the **whole batch** of drafts to the human — they can ack / edit / drop / add per card.
2. Once acked → `save_issue` per card + set relations + priority + estimate.
3. **Verify for real:** read the issue back (its `<TICKET-KEY>-NN` + url) — don't
   trust an exit code alone.
4. Duplicates the agent found → propose linking related/parent instead of creating a copy.

## STEP 5 — REPORT (auto)

- Summarize in chat: cards opened (`<TICKET-KEY>-NN` + link), the design decision
  + reasons, open questions, what was cut.
- If there's real substance (a real design, not one tiny card) → an **HTML
  report** in your house style: design + cards table + trade-off table → open it
  for review.
- Always state honestly: what's verified / what's a hypothesis / what was skipped.

## Exit / Escalation

- Asked to "do it yourself / ship it" → `/shipit`, continuing from the cards opened.
- A P0 production-down bug → `triage` fix-now path + notify the human; don't
  just open a waiting card.
- A system-wide architecture change → `grill-with-docs` + `adr-draft`
  first, then come back to break out cards.
