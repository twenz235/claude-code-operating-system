---
name: bus-factor-reminder
description: Surface knowledge that lives only in one head and force it into a runbook/handbook before next week. Always run during weekly review. ตรวจ knowledge ที่อยู่ในหัวคนเดียว แล้วบังคับเขียนลง runbook/handbook. Use in weekly-review.
---

# Bus Factor Reminder

Reference / อ้างอิง: charter principle "no single irreplaceable person" + your docs-maintenance SOP.

## When to use / เมื่อไหร่ใช้
- Every week (folded into weekly-review). / ทุกสัปดาห์ รวมใน weekly-review
- After an incident that used specialized knowledge. / หลัง incident ที่ใช้ knowledge เฉพาะทาง
- Before any planned or sick leave. / ก่อนลาพัก / ลาป่วย

## The key question / คำถามสำคัญ

> "If I disappeared tomorrow, what would the team or the {{OWNER_ROLE}} be unable to do?"
> "ถ้าผมหายไปพรุ่งนี้ ทีมหรือ {{OWNER_ROLE}} จะทำอะไรต่อไม่ได้บ้าง?"

### DevOps / Infra
- [ ] Is the deploy process written in a runbook? / deploy process บันทึกใน runbook แล้ว?
- [ ] Where are the secrets — does the {{OWNER_ROLE}} know? / secrets อยู่ที่ไหน {{OWNER_ROLE}} รู้ไหม?
- [ ] Can the {{OWNER_ROLE}} reach production access without going through me? / production access เข้าได้ไหมโดยไม่ผ่านผม?
- [ ] Who else can follow the backup / restore steps? / backup / restore ใครทำตามได้บ้าง?

### Architecture
- [ ] Do important decisions have an ADR? / decision สำคัญมี ADR ไหม?
- [ ] Do complex modules have comments/docs explaining intent? / module ซับซ้อนมี comment/doc อธิบาย intent ไหม?

### People
- [ ] Are 1-on-1 notes recorded so the {{OWNER_ROLE}} can see them if needed? / 1-on-1 notes บันทึกไว้ให้ {{OWNER_ROLE}} รู้ถ้าจำเป็น?
- [ ] Is the candidate pipeline summarized in your hiring/CRM tool? / candidate pipeline มีสรุปใน CRM ไหม?

### Knowledge
- [ ] Were this week's important learnings captured? / learning สำคัญจากสัปดาห์นี้ capture แล้ว?
- [ ] If not → use the `capture-knowledge` skill immediately. / ถ้ายัง ใช้ capture-knowledge ทันที

## Action
For every "no", create a task in {{TRACKER}} (your issue tracker, e.g. Linear/Jira/GitHub Issues) to do before next week. / ทุกข้อที่ตอบ "ไม่" สร้าง task ใน {{TRACKER}} ทำก่อนสัปดาห์ถัดไป

Don't let it slide as "I'll do it later" — bus factor builds up unintentionally. / อย่าปล่อยให้ "จะทำทีหลัง" bus factor เกิดโดยไม่ตั้งใจ

## Runbooks the [tech lead] must maintain (bus-factor principle)
Followable by a "stand-in", not necessarily the [tech lead] / อ่านแล้วทำตามได้โดยคนแทน:
- DevOps runbook: deploy, rollback, restore.
- Secrets-management runbook.
- Incident-response runbook.
