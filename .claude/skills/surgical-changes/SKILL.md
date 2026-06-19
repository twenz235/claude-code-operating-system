---
name: surgical-changes
description: Touch only what's necessary — don't improve neighboring code, don't refactor what isn't broken. Every changed line must trace back to the request. แตะเฉพาะที่จำเป็น ทุกบรรทัด trace กลับ request ได้. Trigger when modifying existing code.
---

# Surgical Changes

Reference: a widely-cited "minimal diff" engineering practice + your code-review SOP + the "quality over speed" charter principle. อ้างอิง practice "minimal diff" + SOP code review + หลักการของทีม (charter) คุณภาพเหนือความเร็ว.

## When to use — เมื่อไหร่ใช้

- Before modifying existing code in the system. ก่อนแก้ไขโค้ดที่มีอยู่.
- When the PR diff is larger than expected. เมื่อ diff ใหญ่กว่าที่คาด.

## Rules for editing existing code — กฎสำหรับการแก้โค้ดที่มีอยู่

- **Do NOT** "improve" unrelated neighboring code, comments, or formatting. อย่า improve โค้ดข้างเคียง.
- **Do NOT** refactor things that already work well. อย่า refactor สิ่งที่ทำงานได้ดีอยู่แล้ว.
- **Match** the existing style, even if you dislike it. Match style เดิม แม้จะไม่ชอบ.
- **If you find unrelated dead code** → mention it; don't delete it yourself. mention ให้รู้ อย่าลบเอง.

## Rules for orphans your own change creates — กฎสำหรับ orphan ที่เกิดจาก change ของตัวเอง

- Remove imports/variables/functions that **your change** made unused. ลบของที่ change ของเราทำให้ไม่ใช้แล้ว.
- Don't remove pre-existing dead code (unless asked). ไม่ลบ dead code เดิม (เว้นแต่ถูกขอ).

## Self-test before commit — Self-test ก่อน commit

> "Does every changed line trace back to the user's request?" "ทุกบรรทัดที่เปลี่ยน trace กลับ request ได้ไหม?"
> If not → explain why it had to change, or revert. ถ้าไม่ได้ → อธิบายหรือ revert.

## For the tech lead specifically — สำหรับ TL โดยเฉพาะ

- Don't self-merge your own PR (charter: review must be independent) — it must pass through a separate security/compliance reviewer. ห้าม self-merge PR ของตัวเอง.
- Fallback work (covering for another role) goes through code review too. fallback work ต้องผ่าน code review เช่นกัน.
