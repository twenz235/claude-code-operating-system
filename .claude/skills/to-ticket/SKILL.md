---
name: to-ticket
description: Turn a conversation or an insight into a well-formed tracker ticket — title, description, acceptance criteria, labels, estimate, and owner. Glossary (TH): แปลงบทสนทนา/insight เป็น ticket ที่พร้อมทำ. Trigger when there's work to track, a new directive, a user complaint, or a bug you find.
---

# To Ticket

Reference: a common "to-PRD / to-ticket" pattern (e.g. Matt Pocock's) + your SOPs for task management.

> Works with whatever issue tracker you use (e.g. Linear, Jira, GitHub Issues). Where this skill says "the tracker", use your own.

## When to use

- A conversation contains work that needs tracking (not just chat).
- Someone (manager / dev / user) reports an issue via team chat, email, or a meeting.
- You find a bug that needs to be scheduled (not urgent enough to fix on the spot).
- Follow-up work from a post-mortem, an ADR, or a weekly review.

## Before creating a ticket — check 3 things

1. **Does it already exist in the tracker?** — search first, every time; never duplicate.
2. **Is it real work?** — not just an idea / discussion. If it's an idea, park it in your notes inbox instead.
3. **Is there a definite owner?** — if not, assign yourself (the tech lead) first, then reassign.

## Output Template

```
**Title:** [verb + outcome, <= 80 chars]
Example: "Fix N+1 query in the task-list view when filtering by owner"

**Description:**
## Context
[why this is needed — link the conversation / error-tracker event / chat thread]

## Problem
[the current problem — clear evidence, numbers/logs]

## Proposed solution
[the approach; if still unsure, write "TBD: spike needed"]

## Out of scope
[what this ticket does NOT include — prevents scope creep]

**Acceptance criteria:**
- [ ] [criterion 1 — verifiable]
- [ ] [criterion 2]
- [ ] Tests added (meet your coverage gate)
- [ ] Documentation updated

**Labels:** [bug/feature/tech-debt/chore] + [area: backend/frontend/infra/docs]
**Estimate:** [S/M/L or story points per your team's convention]
**Priority:** [P0-P3 — use triage if it isn't clear yet]
**Owner:** [handle / username — if none yet, put yourself (the tech lead)]
**Linked:** [PR / parent epic / blocked-by]
```

## Rules

- **The title is a verb** ("Fix...", "Add...", "Migrate..."), not a noun ("N+1 query").
- **The description must carry evidence** — link the error-tracker event / log / screenshot.
- **Acceptance criteria must be verifiable** — "works better" fails; "P95 latency < 200ms" passes.
- **Never assign someone you haven't talked to** — agree with the owner first.
- **Out of scope matters as much as in scope** — say clearly what you will not do.

## If there are several pieces of work → split the tickets

If the conversation contains 3+ pieces of work → split into 3 separate tickets; do not lump them into one. Use a parent-child / epic link to relate them.
