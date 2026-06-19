# CHARTER.sample.md — a worked-example team charter

> **OPTIONAL SAMPLE — adapt to your org or delete.** This is a fuller, filled-in
> example of a team charter using NEUTRAL principles. It exists to show how a
> charter reads when complete and how skills consume it. Copy the blank scaffold
> from `docs/CHARTER.template.md`, then write *your* principles — don't ship
> these verbatim.
>
> (Glossary (TH): นี่คือตัวอย่างธรรมนูญทีมที่กรอกครบแล้ว ใช้ดูโครงและโทน แล้วเขียนของทีมตัวเอง
> อย่าลอกตรง ๆ)

A charter is a short list of **principles that outrank convenience.** When a
decision is fast/easy one way but conflicts with a principle, the principle wins.
Keep it small (a handful of principles, not dozens) and mark which ones are
*inviolable* — never traded away under deadline pressure.

---

## How to read this file

- **#** — a stable id you can cite (e.g. "this fails P3").
- **Principle** — the rule, in one plain sentence.
- **Inviolable?** — `yes` = never overridden, even under pressure. `no` = a strong
  default that can be consciously, visibly traded with owner sign-off.
- **Why** — the failure this prevents.

---

## Principles (neutral example set)

### P1 — Decisions are written and auditable  `inviolable: yes`
Every non-trivial decision leaves a written trail (an ADR, a ticket comment, a
note) with the reasoning — not just the outcome. **Why:** undocumented decisions
become folklore; six months later nobody knows why, and the same debate repeats.

### P2 — Correctness and quality beat speed  `inviolable: yes`
Don't ship something you can't stand behind to hit a date. Flag the trade-off
instead. **Why:** a fast-but-wrong release costs more than the time it saved, in
incidents and rework.

### P3 — Write the least code that solves the problem  `inviolable: no`
No speculative features, no abstraction "for later." Ask: would a senior engineer
call this over-built? **Why:** every extra line is a line to maintain, test, and
debug.

### P4 — Change only what the task requires (surgical changes)  `inviolable: no`
Don't refactor or "improve" adjacent code that isn't broken. Every changed line
should trace back to the request. Batch unrelated suggestions separately. **Why:**
drive-by changes hide the real diff and break things outside the review's focus.

### P5 — No single point of knowledge (bus factor)  `inviolable: yes`
Anything that lives only in one person's head gets written into a runbook or
handbook before the week ends. **Why:** if that person is unavailable, the team
must still operate.

### P6 — No self-approval on your own work  `inviolable: yes`
Your own PR / your own security review is reviewed by someone else. **Why:** a
second set of eyes catches what the author is blind to; self-approval defeats the
control entirely.

### P7 — Security and privacy by default  `inviolable: yes`
Audit new dependencies before use; never put real secrets in code, commits, or
PRs; keep production data out of personal machines; follow your data-protection
regime (GDPR / PDPA / CCPA — whichever applies). **Why:** a leaked key or a PII
mishandling is unrecoverable and may be illegal.

### P8 — Production is gated; humans approve the irreversible  `inviolable: yes`
No push/merge to main or deploy to production without explicit approval; the
owner ({{OWNER_ROLE}}) holds reserve access and approves irreversible steps
(prod migrations, force-pushes to shared branches). **Why:** the costly mistakes
are the ones nobody could undo.

### P9 — Explain the reasoning behind design choices  `inviolable: no`
State the "why," not just the "what," so others can push back and improve it.
**Why:** a design nobody understands is a design nobody can safely change.

### P10 — Don't stay silent about risk  `inviolable: no`
Overload, a slipping estimate, a looming incident — surface it early and in
writing. Timely escalation is expected behavior, not failure. **Why:** silent
risk turns into a surprise that's now everyone's emergency.

> Replace, reorder, and renumber freely. Pick *your* inviolable set deliberately —
> the inviolable ones are the heart of the charter.

---

## How skills consume this charter

### `charter-check` — gate a decision
Before a non-routine, hard-to-reverse decision, this skill walks the principle
list and forces you to name which **inviolable** principles are in play and
confirm the decision doesn't violate them. Example:

> Decision: "Force-push `staging` to match `develop` to clear conflicts."
> charter-check → touches **P8** (irreversible on a shared branch, inviolable).
> → STOP: requires explicit {{OWNER_ROLE}} approval; propose a non-destructive
> alternative first.

### `grill-with-docs` — interview before a feature
Before starting a feature or an architecture change, this skill interviews you
(or the team) until there's a shared understanding, checking the plan against
both your domain notes in `{{VAULT}}` and this charter. Example:

> Feature: "Add a CSV export of user records."
> grill-with-docs → cross-references **P7** (this touches PII — what's the
> redaction / access-control story?) and **P3** (is a full export needed, or a
> scoped one?). Surfaces these before any code is written.

### Pointing skills at your real charter
1. Copy `docs/CHARTER.template.md` to your charter location
   (e.g. `{{VAULT}}/reference/charter.md` or `<project-root>/docs/CHARTER.md`).
2. Fill it in, using this sample as a model.
3. Update the path references inside `charter-check` / `grill-with-docs` (and
   any skill that cites "your team charter") to match where you put it.
