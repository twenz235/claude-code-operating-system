---
name: triage
description: Classify an issue with a P0–P3 state machine and an impact x urgency matrix, then assign an owner and an SLA. Glossary (TH): จำแนก issue ตาม priority + ความเร่งด่วน. Trigger when a bug report, error-tracker alert, or user complaint comes in, or when you must decide "fix now vs schedule".
---

# Triage

Reference: common "triage" practice (e.g. Matt Pocock's pattern) + your SOPs for task management + your team charter on "quality over speed".

## When to use

- A new bug report arrives (your issue tracker, error tracker, or team chat).
- Before assigning an owner — you need the priority first.
- Weekly grooming — re-triage stale tickets.
- A regression surfaces during development.

## State Machine

```
NEW → [triage] → CLASSIFIED → [assigned] → IN PROGRESS → [PR] → REVIEW → [merge] → DONE
                      ↓
                  REJECTED (won't fix / duplicate / out of scope)
                      ↓
                  DEFERRED (valid but later — has a deadline)
```

## Impact x Urgency Matrix

| | High urgency | Low urgency |
|---|---|---|
| **High impact** | **P0** — fix now, drop everything | **P1** — this sprint |
| **Low impact** | **P2** — next sprint | **P3** — backlog |

### "High impact" means
- Affects > ~10% of users, or revenue.
- Personal data (PII) / security / compliance.
- Blocks the whole team / production is down.

### "High urgency" means
- An active production issue (a user is stuck right now).
- A compliance deadline is near.
- It is on the critical path of the sprint.

## SLA by priority

| Priority | Response | Fix | Owner |
|----------|----------|-----|-------|
| P0 | < 30 min | < 4 hours | on-call + a tech-lead pair |
| P1 | < 4 hours | this sprint | owner from the area |
| P2 | < 24 hours | next sprint | owner from the area |
| P3 | < 1 week | backlog | unassigned is fine |

## Output Template

```
**Triage: [ticket ref]**

**Impact:** [High/Low] — because [evidence: user count / revenue / risk]
**Urgency:** [High/Low] — because [evidence: active issue / deadline]
**Priority:** [P0/P1/P2/P3]
**Decision:** [fix-now / sprint-now / sprint-next / backlog / defer / reject]
**Owner:** [handle / username]
**Reason (if reject/defer):** [...]
**Linked incidents:** [past similar issues]
```

## Hard rules

- **Never triage on feeling** — you need a number or a link as evidence.
- **Do not mark everything P0** — if more than 2 P0s land at once, that is a systemic problem; escalate to your manager / decision-maker.
- **A P3 that sits > 90 days → re-triage or reject.** Don't let the backlog rot.
- **A reject must carry a reason** — the requester may come back and ask.
- **A reopen must be justified** — say why it isn't a fresh ticket archiving the old one.

## When unsure

- Impact unclear → ask the data / customer-success side.
- Urgency unclear → ask your manager / product owner.
- Default when information is insufficient: **P2 + DEFERRED one sprint** (not P0).
