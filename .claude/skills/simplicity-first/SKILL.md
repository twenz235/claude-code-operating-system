---
name: simplicity-first
description: Write the least code that solves the problem — no features beyond what was asked. Ask "would a senior engineer call this over-engineered?" เขียนโค้ดน้อยที่สุดที่แก้ปัญหา. Trigger before implementing and after implementing to self-check.
---

# Simplicity First

Reference: a widely-cited "keep it simple" engineering practice + the KISS rule + the "quality over speed" charter principle. อ้างอิง practice "keep it simple" + KISS + หลักการของทีม (charter) คุณภาพเหนือความเร็ว.

## When to use — เมื่อไหร่ใช้

- Before starting to implement. ก่อนเริ่ม implement.
- After implementing, to review yourself. หลัง implement เพื่อ review ตัวเอง.
- When the code looks too long. เมื่อเห็นว่าโค้ดยาวเกินไป.

## Checklist before implementing — Checklist ก่อน implement

- [ ] What was actually asked? (Not what you think should be done.) สิ่งที่ขอคืออะไร?
- [ ] Any feature or abstraction that wasn't asked for? Cut it. ตัดออก.
- [ ] Any "flexibility" or "configurability" nobody needs right now? Cut it. ตัดออก.
- [ ] Error handling for impossible scenarios? Cut it. ตัดออก.

## Self-test after implementing — Self-test หลัง implement

> "Would a senior engineer call this over-engineered?" "Senior engineer จะบอกว่า over ไหม?"
> If yes → rewrite smaller. ถ้าใช่ → เขียนใหม่ให้เล็กกว่า.

> "Can these 200 lines become 50?" "200 บรรทัดนี้ เหลือ 50 ได้ไหม?"
> If yes → rewrite. ถ้าได้ → เขียนใหม่.

## Hard rules — กฎเหล็ก

- No features beyond what was asked. ไม่มี feature เกินที่ขอ.
- No abstraction for code used once. ไม่มี abstraction สำหรับโค้ดที่ใช้ครั้งเดียว.
- No "might need it later" — if nobody asked, don't build it. ไม่มี "อาจจะใช้ในอนาคต".
- Abstract on the second duplication, not the first. duplicate ครั้งที่สองถึงจะ abstract.
