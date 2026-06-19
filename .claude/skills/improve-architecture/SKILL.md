---
name: improve-architecture
description: >
  Find deepening opportunities in the codebase to improve testability and
  navigability — always read the ADRs + domain first. Trigger quarterly, or when
  a debugging session finds you can't locate a good seam.
  Glossary (TH): หาจุดทำให้ module ลึกขึ้น ทดสอบง่ายขึ้น.
---

# Improve Architecture

References: the improve-codebase-architecture technique (Matt Pocock) + your
documentation SOP (quarterly review) + your team charter
(`docs/CHARTER.template.md`): bus-factor.

## When to use
- Quarterly (your playbook's quarterly review).
- After a debugging session that found a poor seam.
- Before sprint planning that includes a large refactor.

## Vocabulary (use it consistently)
- **Module** — anything with an interface and an implementation.
- **Depth** — leverage at the interface: lots of behavior behind a small interface.
- **Seam** — a place where behavior can change without editing the inside.
- **Deletion test** — if you deleted this module, does complexity spread out, or disappear?

## Process

### 1. Read the domain + ADRs first
- `{{VAULT}}/reference/adrs/`
- `<project-root>/docs/SOP/`
- Pick up terms from the domain vocabulary (e.g. "Order", "Worker") before naming things.

### 2. Explore the codebase (organic, not a checklist)
Hunt for friction:
- Does understanding one concept require touring many modules?
- Which module is shallow (interface almost equal to implementation)?
- Did you extract a pure function for tests while the real bug hides at the caller?
- Which module is tightly coupled across a seam?

Apply the **Deletion test** wherever you're suspicious.

### 3. Present candidates (one at a time)
Per candidate:
- Files/modules involved.
- The problem (the friction you found).
- The solution (plain English).
- Benefits (how locality + leverage + testing improve).
- Recommendation: `Strong` / `Worth exploring` / `Speculative`.

**Do not propose an interface until the user picks a candidate.**

### 4. Check for ADR conflict
If a candidate contradicts an existing ADR → flag it clearly + explain why it's still worth reopening.

### 5. If you decide on a new deep module → update
- A new ADR, if it meets the 3 criteria.
- The relevant area note in `{{VAULT}}/work/areas/`.
- The runbook, if deployment/infra changed.
