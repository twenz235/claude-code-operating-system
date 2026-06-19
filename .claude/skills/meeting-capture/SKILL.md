---
name: meeting-capture
description: Prepare before a meeting and capture action items after it into your notes vault and issue tracker. เตรียมก่อน meeting และ capture action items หลัง meeting. Trigger before/after any meeting.
---

# Meeting Capture

Reference: your team's communication SOP + the "written / auditable" charter principle (every decision recorded). อ้างอิง SOP สื่อสารของทีม + หลักการของทีม (charter) "ทุกอย่างเป็นลายลักษณ์ + auditable".

## Before the meeting (2–5 min) — ก่อน Meeting

- Open the meeting template: `{{VAULT}}/templates/meeting.md`
- Save the note to: `{{VAULT}}/meetings/<YYYY-MM-DD>-<meeting-name>.md`
- Write down: objective, attendees, agenda. ระบุ วัตถุประสงค์, ผู้เข้าร่วม, agenda.

## During the meeting — ระหว่าง Meeting

- Capture decisions **with their rationale** (written/auditable principle). จด decisions + rationale.
- Capture action items **with an owner, immediately** — don't wait until after. จด action items พร้อม owner ทันที (อย่ารอหลัง meeting).
- If it's a 1-on-1 → use the 1on1 template instead. ถ้าเป็น 1-on-1 → ใช้ template 1on1 แทน.

## Right after the meeting — หลัง Meeting (ทันที)

- [ ] Review action items — are they complete? Is each owner clear? ครบไหม owner ชัดไหม?
- [ ] Action items that are team work → create a ticket in your tracker (e.g. Linear/Jira/GitHub Issues). สร้าง ticket.
- [ ] Action items owned by you (the tech lead) → add to the daily note on the due date. เพิ่มใน daily note ของวันที่ due.
- [ ] If a decision is significant → consider writing an ADR (use the `adr-draft` skill). พิจารณา ADR.
- [ ] Share notes with attendees if needed. Share notes กับผู้เข้าร่วม (ถ้าจำเป็น).

## For standups — สำหรับ Standup

- No need to capture a full meeting note. ไม่ต้อง capture แบบ full meeting.
- Record only blockers + action items that arise. บันทึกแค่ blockers + action items ที่ arise.
