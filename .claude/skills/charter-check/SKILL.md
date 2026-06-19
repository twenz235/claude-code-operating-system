---
name: charter-check
description: Check a significant decision against your team charter before committing to it — force yourself to name the inviolable principles in play / ตรวจหลักการธรรมนูญทีมก่อนตัดสินใจสำคัญ. Trigger before any non-routine, significant decision.
---

# Charter Check — review principles before deciding

Reference / อ้างอิง: your team charter (`docs/CHARTER.template.md`) + the charter principle that every decision is made through principles, written and auditable.

This skill assumes your team maintains a charter — a short list of standing principles that decisions
must respect, some of which are marked inviolable (they override convenience, deadlines, even contracts).
If you don't have one yet, copy `docs/CHARTER.template.md`, fill in your principles, and mark the
inviolable ones. The table below is a generic example to adapt — replace it with your own rows.

สกิลนี้สมมุติว่าทีมมี charter — รายการหลักการที่การตัดสินใจต้องเคารพ บางข้อ "ยกเลิกไม่ได้"
ถ้ายังไม่มี ให้ copy `docs/CHARTER.template.md` มาเติมเอง ตารางด้านล่างเป็นตัวอย่าง generic ให้ปรับ

## When to use / เมื่อไหร่ใช้
- Before a large architecture decision. / ก่อน decision สถาปัตยกรรมใหญ่
- Before recommending a hire/fire to the {{OWNER_ROLE}} (manager / decision-maker). / ก่อนแนะนำ hire/fire ต่อผู้มีอำนาจตัดสินใจ
- Before introducing a new paid tool/service. / ก่อนเอา tool/service ใหม่ที่มีค่าใช้จ่ายเข้า
- When speed and quality are in conflict. / เมื่อความเร็วขัดกับคุณภาพ
- Before granting any exception to a standard process. / ก่อนยกเว้น standard process

## Step 1: Identify the relevant principles / ระบุหลักการที่เกี่ยวข้อง

Fill this from YOUR charter. The rows below are an illustrative set — substitute your own and mark
which are inviolable (⛔). / เติมจาก charter ของคุณ; ตัวอย่างด้านล่างให้แทนที่ และระบุข้อที่ยกเลิกไม่ได้

| # | Principle (example — replace with yours) | Relevant? / เกี่ยวไหม? |
|---|------------------------------------------|------------------------|
| 1 | Everything is written and auditable / ทุกอย่างเป็นลายลักษณ์อักษร | |
| 2 | Quality over speed ⛔ / คุณภาพเหนือความเร็ว | |
| 3 | Legal correctness ⛔ / ความถูกต้องทางกฎหมาย | |
| 4 | Code must be explainable / โค้ดต้องอธิบายได้ | |
| 5 | No irreplaceable person (bus factor) / ไม่มีคนที่ทดแทนไม่ได้ | |
| 6 | Security-conscious by default / คำนึงถึง security เป็นพื้น | |
| 7 | Confidentiality / การรักษาความลับ | |
| 8 | Transparency / ความโปร่งใส | |
| 9 | IP protection / การคุ้มครอง IP | |
| 10 | Every decision made through principles ⛔ / ทุกการตัดสินใจผ่านหลักการ | |

⛔ = inviolable (overrides convenience, deadlines, and contracts). Mark yours per your real charter.
⛔ = ยกเลิกไม่ได้ (มีผลเหนือความสะดวก/เดดไลน์/สัญญา) — ทำเครื่องหมายตาม charter จริง

## Step 2: Ask yourself / ถามตัวเอง
> "Does this decision conflict with any inviolable principle (your ⛔ rows)?"
> "การตัดสินใจนี้ขัดกับหลักการที่ยกเลิกไม่ได้ไหม?"

- If it conflicts → **do not do it** (no exception) → escalate to the {{OWNER_ROLE}} with an explanation. / ถ้าขัด → ห้ามทำ → escalate พร้อมอธิบาย
- If it doesn't → record that the check passed and the reasoning. / ถ้าไม่ขัด → บันทึกว่าผ่าน พร้อมเหตุผล

## Step 3: Record it (written-and-auditable principle) / บันทึก
Every significant decision needs a record — use an ADR or a 1-on-1 note depending on context.
ทุก decision สำคัญต้องมีบันทึก — ใช้ ADR หรือ 1-on-1 note ตาม context
