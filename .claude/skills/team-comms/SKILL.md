---
name: team-comms
description: Facilitate daily standup, sprint planning, grooming, and retrospective so they stay on time and produce clear output / จัดประชุมให้ตรงเวลาและมี output ชัด. Trigger before/during the various meeting types.
---

# Team Communication & Meetings

Reference / อ้างอิง: your team's responsibilities doc + engineering playbook cadence.

## Daily Standup (e.g. 10:00–10:15)

Format (each person ≤2 min / แต่ละคน ≤2 นาที):
1. What did you do yesterday? / ทำอะไรไปเมื่อวาน?
2. What will you do today? / วันนี้จะทำอะไร?
3. Any blockers? / มี blocker ไหม?

**Tech-lead role:**
- Facilitate to keep it to ~15 minutes — it is NOT a problem-solving session. / ให้ตรงเวลา ไม่ใช่ session แก้ปัญหา
- Record blockers and resolve them offline. / บันทึก blocker แล้วแก้ offline
- If async, post in team chat before the standup time. / ถ้า async โพสต์ใน team chat ก่อนเวลา

## Sprint Planning (start of sprint, 1–2 h)

Checklist:
- [ ] Backlog groomed (stories clear, estimated) / story ชัด, estimate แล้ว
- [ ] Team capacity for this sprint accounted for (PTO, etc.) / คิด capacity แล้ว (วันลา ฯลฯ)
- [ ] Sprint goal is clear (one sentence) / sprint goal ชัด 1 ประโยค
- [ ] Selected stories: each has an owner + estimate / มีเจ้าของ + estimate
- [ ] Definition of Done is clear / DoD ชัด

Output: Sprint board updated in your tracker (e.g. Linear / Jira / GitHub Issues). / อัปเดต board ใน tracker แล้ว

## Technical Grooming (30–60 min / sprint)

- Break large stories into small tasks. / แตก story ใหญ่ → task เล็ก
- Clarify acceptance criteria. / clarify AC
- Identify dependencies and risks. / ระบุ dependency + risk
- Update estimates if needed. / อัปเดต estimate ถ้าต้องการ

## Retrospective (30–60 min / sprint)

Format: What went well / What could improve / Action items.

**Tech-lead role:**
- Facilitate — do not act as defender. / facilitate ไม่ใช่ defender
- Record action items + owner + due date. / บันทึก action item + owner + due
- Follow up on action items in the next sprint. / ติดตามใน sprint ถัดไป

## Meeting notes (written-and-auditable principle)

Per your team charter (docs/CHARTER.template.md), keep every decision written and auditable.
ตามหลักการ "ทุกอย่างเป็นลายลักษณ์อักษร" ในธรรมนูญทีม

- Every meeting has a note. / ทุก meeting มี note
- Template: `{{VAULT}}/templates/meeting.md`
- Store notes in: `{{VAULT}}/meetings/`
- Action items → a ticket in your tracker. / action item → ticket ใน tracker

## Architecture Review (as needed)

- Trigger: significant design decisions, cross-team impact. / decision สำคัญ, กระทบหลายทีม
- Output: an ADR (if it meets your ADR-worthy criteria). / ออก ADR ถ้าเข้าเกณฑ์
