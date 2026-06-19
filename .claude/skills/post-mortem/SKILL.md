---
name: post-mortem
description: Write a root-cause analysis (RCA) after a bug is fixed — for other engineers and your future self. Do NOT write one until you have a validated fix. เขียน RCA หลัง fix bug ที่ validate แล้ว. Trigger after a debug session once the fix is validated.
---

# Post-mortem

Reference: a common blameless post-mortem methodology + the "written/auditable" and "bus-factor" charter principles (knowledge must leave one person's head). อ้างอิง post-mortem แบบ blameless + หลักการของทีม (charter) written/auditable + bus factor.

## When to use — เมื่อไหร่ใช้

- After fixing a bug whose fix is validated. หลัง fix bug ที่ validate แล้ว.
- Before closing a ticket. ก่อนปิด ticket.
- After a resolved production incident. production incident ที่ resolve แล้ว.

## Refuse to draft unless all 4 are present — Refuse ถ้าไม่ครบ 4 ข้อ

- [ ] A reliable repro exists. Reliable repro มีอยู่.
- [ ] Root cause is known (not a hypothesis). Root cause รู้แล้ว (ไม่ใช่ hypothesis).
- [ ] Fix is identified (PR/commit). Fix ระบุแล้ว.
- [ ] Fix is validated (the original repro now passes). Fix validate แล้ว.

**If any is missing → say what's missing; do not guess. ถ้าขาดข้อใด → บอกว่าขาดอะไร อย่าเขียนเดา.**

## Template

- Use template: `{{VAULT}}/templates/post-mortem.md`
- Save to: `{{VAULT}}/work/quarterly/incidents/` (create the folder if it doesn't exist). สร้าง folder ถ้าไม่มี.

## Structure (in this order) — Structure ตามลำดับ

1. **Summary** (mandatory) — one paragraph: what broke, what fixed it, ticket/PR. อะไรพัง, อะไรแก้.
2. **Symptom** — what was actually observed (error message, log line). สิ่งที่สังเกตได้จริง.
3. **Root cause** (mandatory) — the real mechanism, with function/file names. mechanism จริง พร้อมชื่อฟังก์ชัน/ไฟล์.
4. **Why it produced the symptom** — connect cause → symptom. เชื่อม cause → symptom.
5. **Fix** (mandatory) — what changed + PR + why it addresses the root cause. ทำไม address root cause.
6. **How it was found** — the debug path (pull from your breadcrumb ledger). debug path.
7. **Why it slipped through** — CI gap / latent issue / review miss (blameless). blameless.
8. **Validation** (mandatory) — concrete: test name, uptime, soak run. concrete evidence.
9. **Action items** — what + owner + tracking (if none, say so). ถ้าไม่มีให้บอกว่าไม่มี.

## Hard rules — กฎเหล็ก

- **Code identifiers are first-class** — function names, paths, commit SHAs. Code identifiers เป็น first-class.
- **No hedging** — delete "we believe". ไม่ hedge.
- **Blameless** — describe the gap, not a person's name. บอก gap ไม่บอกชื่อคน.
- **State validation coverage honestly** — if you only tested one config, say so. บอก validation coverage ตรง ๆ.

## For management → hand off to the `management-talk` skill. สำหรับ management → ส่งต่อ skill `management-talk`.
