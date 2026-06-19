---
name: workload-balance
description: >
  OPTIONAL SAMPLE — adapt to your org or delete. Track time per project,
  prioritize work, and warn {{OWNER_ROLE}} early when load approaches capacity.
  Trigger weekly (time aggregation) and whenever you feel overloaded. (Glossary (TH):
  ติดตามเวลาต่อโปรเจกต์ จัดลำดับ priority และแจ้งผู้ตัดสินใจล่วงหน้าเมื่อโหลดใกล้เกิน)
---

# Workload & Multi-Project Balance

> **OPTIONAL SAMPLE — adapt to your org or delete.** The two-project example and
> the stacks below are illustrative. Replace project names, stacks, and tools
> with your own. Reference: your team's responsibilities doc + your engineering
> playbook.

## Example: one tech lead covering two projects at once (Glossary (TH): ดูแล 2 โปรเจกต์พร้อมกัน)
- **{{PROJECT}}** — (example stack) web framework + OpenAPI gen + DB / cache / queue + frontend.
- **A secondary service** ({{DOMAIN}}) — (example stack) Node.js + Express + SQLite.

## Time tracking (daily) (Glossary (TH): บันทึกเวลารายวัน)
- Log time per project every day (your time tracker, e.g. Toggl, or your {{TRACKER}}'s time feature).
- Categories: Dev, Review, Meeting, Docs, Admin, Hiring/Training.

## Weekly time aggregation (Friday) (Glossary (TH): รวมเวลารายสัปดาห์)

Template inside the weekly review:
```
## Time distribution — week {{week}}
- {{PROJECT}}: X h (dev: X, review: X, meeting: X)
- Secondary service: X h
- Hiring/Training: X h
- Admin/Other: X h
Total: X h

Status: Normal / Near capacity / Overload
```

## Overload protocol (Glossary (TH): โปรโตคอลเมื่อโหลดเกิน)
Maps to the charter principles "decisions are written/auditable" and "don't risk
team/company survival by staying silent."

**Never stay silent when overloaded** — warn {{OWNER_ROLE}} in advance.

When load exceeds capacity:
1. Record: which project, why, for how long.
2. Notify {{OWNER_ROLE}} in writing (use the `management-talk` skill's "overload notification" format).
3. Offer options: cut scope / extend deadline / add resources.
4. {{OWNER_ROLE}} decides — the tech lead implements that decision.

**It is not a failure** to flag overload in time (your playbook should treat
timely escalation as the expected behavior).

## Prioritization framework (Glossary (TH): กรอบจัดลำดับความสำคัญ)
1. Production incident / security issue (highest).
2. Blocking the team (PR review, a decision they are waiting on).
3. Sprint commitment (work already committed).
4. Non-blocking improvements, docs, grooming.
