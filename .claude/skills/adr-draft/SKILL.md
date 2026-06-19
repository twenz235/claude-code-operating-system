---
name: adr-draft
description: Draft an ADR before committing an important decision; always confirm the 3 gate criteria first. เขียน ADR ก่อน commit decision สำคัญ ตรวจ 3 เกณฑ์ก่อนเสมอ. Trigger when a decision is hard to reverse, or future readers will ask "why?".
---

# ADR Draft

Reference / อ้างอิง: your engineering playbook (decision-record cadence) + charter principles "everything written and auditable". A common starting rule is to land your first stack/architecture ADRs early in a project (e.g. within the first few months).

## Before writing an ADR — check the 3 gate criteria (all must hold)
ตรวจ 3 เกณฑ์ก่อนเสมอ — ต้องครบทั้งหมด:

- [ ] **Hard to reverse / ย้อนกลับยาก** — is the cost of changing your mind high?
- [ ] **Future readers will wonder / คนอนาคตจะสงสัย** — without a record, will someone who joins later ask "why did we do it this way?"
- [ ] **A real trade-off exists / มี trade-off จริง** — was there a genuine alternative you considered but did not choose?

**If any criterion is missing → no ADR needed.** Use a PR description or commit message instead. / ถ้าขาดข้อใดข้อหนึ่ง ไม่ต้อง ADR ใช้ PR description หรือ commit message แทน

## Template
File / ไฟล์: `{{VAULT}}/templates/adr.md`

Store in two places / เก็บที่:
- Knowledge log: `{{VAULT}}/reference/adrs/ADR-{number}-{slug}.md`
- Project record (via PR): `<project-root>/docs/adr/ADR-{number}-{slug}.md`

## ADRs worth landing early
- The stack/architecture choice for any new service (e.g. an internal HR/LMS app) — land it early per your playbook cadence.
- Any new decision that meets the 3 gate criteria above. / ADR ใหม่ใดก็ตามที่เข้าเกณฑ์ 3 ข้อ

## Core format
```markdown
## Context
[The problem to be decided — not the solution / ปัญหาที่ต้องตัดสินใจ ไม่ใช่ solution]

## Decision
[What was decided — one clear sentence / สิ่งที่ตัดสินใจ 1 ประโยคชัดเจน]

## Consequences
### Positive / บวก
### Negative / Risk — ลบ / Risk

## Alternatives Considered
[Options on the table and why they were not chosen / ทางเลือกที่มีและทำไมไม่เลือก]

## Related charter principles
[Which principle(s) apply + how / หลักการที่เกี่ยวข้อง + เกี่ยวอย่างไร]
```

## After writing the ADR
- If it concerns project code → open a PR into the repo (charter: changes are written and auditable). / ถ้าเกี่ยวกับ project code เปิด PR เข้า repo
- If it concerns a personal/process decision → the notes vault is enough. / ถ้าเกี่ยวกับ personal process vault ก็พอ
- Update `{{VAULT}}/reference/adrs/` every time. / Update ทุกครั้ง
