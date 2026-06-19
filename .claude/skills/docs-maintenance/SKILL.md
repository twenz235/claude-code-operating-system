---
name: docs-maintenance
description: >
  Keep the handbook, architecture docs, runbooks, and ADRs up to date — update
  them via PR only. Trigger weekly (architecture), quarterly (full review), and
  whenever a process changes.
  Glossary (TH): ดูแล docs ให้ทันสมัย อัปเดตผ่าน PR เท่านั้น.
---

# Documentation Maintenance

References: your team's documentation SOP + your engineering playbook (cadence)
+ your team charter (`docs/CHARTER.template.md`): written/auditable decisions,
bus-factor.

## Iron rules
- **Every change goes through a PR** — no direct edits (written/auditable per your charter).
- **Update within 1 week** when a process changes.
- Keep a **CHANGELOG** in your infrastructure/operations repo.

## Weekly routine
- [ ] `<project-root>/docs/architecture.md` — update if the architecture changed.
- [ ] Runbooks — update if the deployment/infra process changed.

## Quarterly routine
- [ ] Review the whole `handbook/` — is the content still current?
- [ ] Existing ADRs — still correct? Anything to supersede?
- [ ] API docs — match the implementation?
- [ ] Onboarding guide — still usable?

## When onboarding someone new
Update `handbook/onboarding-engineer.md` within the onboarding week.

## ADR — when to write one
Write one only when all 3 hold:
1. Hard to reverse (high cost).
2. A future reader will wonder why.
3. There's a real trade-off (other options existed, you chose this one for a reason).

Template: `{{VAULT}}/templates/adr.md`
Store in: `<project-root>/docs/adr/` or `{{VAULT}}/reference/adrs/`

## Docs the tech lead owns
- `handbook/` — team process.
- `<project-root>/docs/architecture.md` — architecture.
- DevOps runbook — deploy/restore steps.
- API docs — OpenAPI spec.
- ADR log — significant decisions.
