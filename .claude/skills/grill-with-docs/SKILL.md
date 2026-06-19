---
name: grill-with-docs
description: >
  Interview yourself or the team before starting a feature until you reach a
  clear shared understanding, checked against your domain knowledge so everyone
  aligns before building. Trigger when starting a new feature or making a
  significant architecture change.
  Glossary (TH): สัมภาษณ์จนเข้าใจตรงกันก่อนเริ่มทำ.
---

# Grill With Docs

References: the grill-with-docs technique (Matt Pocock) + your backend/API SOP +
your team-communication SOP + your team charter (written/auditable decisions).

## When to use
- Starting a new, unclear feature.
- A significant architecture change.
- Before writing a PRD / ADR.
- When the team holds different interpretations.

## Domain knowledge (read before asking)
- `{{VAULT}}/work/areas/` — context for each area of the product.
- `{{VAULT}}/reference/adrs/` — prior decisions.
- `{{VAULT}}/reference/charter.md` — your team charter / principles.
- `<project-root>/docs/SOP/` — relevant SOPs.

## Grill process (one question at a time; wait for the answer before the next)

### 1. Explore the codebase + domain first
If a question can be answered from the codebase → explore first, don't ask.

### 2. Ask the full decision tree
- What is the user's goal (user story)?
- Is there a constraint from a relevant SOP?
- Is there a prior ADR to respect?
- What is explicitly **out of scope**?
- What is the simplest approach that still hits the goal?

### 3. Always use the language from the existing domain / ADRs
If a new term conflicts with an existing one → challenge it first.

### 4. Update the ADR if you decide something new
Only when: hard to reverse + a future reader will wonder why + there's a real trade-off.
Template: `{{VAULT}}/templates/adr.md`
