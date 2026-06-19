---
name: code-review-detail
description: Deep-dive a single code-review finding — trace the real code path, explain root cause and impact, and propose a fix with code. (เจาะลึก finding ทีละข้อ — trace code จริง อธิบาย root cause/ผลกระทบ พร้อมวิธีแก้) Takes the finding as an argument. Trigger when a dev/reviewer asks for more on a review finding: /code-review-detail <finding>.
---

# Code Review — Detail / Deep-Dive

Reference: Claude Code's built-in `/code-review` (or your manual review) + your team charter (explainable code) + `scrutinize`.

## When to use (เมื่อไหร่ใช้)

- After Claude Code's built-in `/code-review` (or your manual review) produces a finding and a dev asks for more detail on one item. (หลัง review ออก finding แล้ว dev ขอคำอธิบายเพิ่ม)
- A finding is being contested ("why is this a breaking change?") → you must trace the real code to show it. (finding ถูกโต้แย้ง → ต้อง trace code จริงให้ดู)
- The dev can't explain the finding back (charter: explainable code) → teach it with evidence from the code. (dev อธิบายกลับไม่ได้ → สอนด้วยหลักฐานจาก code)

## Input

```
/code-review-detail <finding heading>
```

Example:
```
/code-review-detail 1. Renaming stats → analytics breaks the existing TaskList stats bar
```

The argument is one finding from a prior review. If you don't have the original review context → ask for the PR/commit first, don't guess. (ถ้าไม่มี context ของ review เดิม → ถาม PR/commit ก่อน อย่าเดา)

## Core rules — do not skip (กฎสำคัญ ห้ามข้าม)

- **Always trace the real code** — open the file, read the real lines, cite `file:line` for every claim. No hand-waving. (Trace code จริงเสมอ อ้าง `file:line` ทุก claim)
- **Verify before writing** — anything you call "broken" must point to the exact line and reason. (ทุกข้อที่บอกว่าพังต้องชี้ได้ว่าพังบรรทัดไหน เพราะอะไร)
- **Don't fix code in this skill** — this skill *explains*, it does not *fix* (fix goes out as a separate PR per `surgical-changes`). (สกิลนี้อธิบาย ไม่ใช่ fix)
- **Match the listener** — junior dev → explain in detail; senior dev → keep it terse, trace only. (ภาษาตรงกับผู้ฟัง)

## Steps (ขั้นตอน)

### 1. Locate — find the finding in the real code
- From the argument, find the related files/lines on both sides (the cause + the impacted site). (หาไฟล์/บรรทัดทั้งต้นเหตุและจุดที่ได้รับผลกระทบ)
- If cross-layer (backend↔frontend) → trace every call site. (ถ้า cross-layer → trace ให้ครบทุก call site)

### 2. Explain — follow the 5 sections (see Output Template)
- What / Where / Why it matters / Root cause / Fix + Verify

### 3. Evidence — attach proof
- Real code snippets from the file (not pseudo-code) with `file:line`. (code snippet จริง พร้อม `file:line`)
- If it's a breaking change → show old path vs new to reveal what's missing. (แสดง path เดิม vs ใหม่ ให้เห็นว่าขาดตรงไหน)

### 4. Severity restate — restate level and action
- 🔴 Blocking / 🟡 Should-fix / 🟢 Nit — and what must happen before merge. (ต้องทำอะไรก่อน merge)

## Output Template

```
# Detail: <finding heading>
Level: 🔴/🟡/🟢   |   PR/Commit: <ref>

## 1. What it is (What)
<problem in 1-3 lines>

## 2. Where it is (Where) — evidence
- Cause:    `path/file.py:line` — <real code>
- Impact:   `path/other.js:line` — <real code>

## 3. Why it matters (Why)
<impact: who hits it, when, symptom — silent fail? 500? data leak?>

## 4. Root cause (Root cause)
<why it happens — e.g. renamed an action instead of adding, forgot to migrate a call site>

## 5. Fix + Verify (Fix & Verify)
<fix options with short trade-offs>
<how to verify it's actually fixed — test/manual step>
```

## Exit / Escalation

- If, while explaining, you find the finding is **wrong** (verify fails) → withdraw it and tell the dev straight, don't push it. (ถ้า finding ผิด → ถอนออก แจ้งตรง ๆ)
- If it's a security/PII issue → hand off to the security/privacy review skill before merge. (ถ้าเป็น security/PII → ส่งต่อ skill รีวิว security ก่อน merge)
- If the fix needs an architecture decision → draft an ADR (`adr-draft`) before committing. (ถ้าต้องตัดสินใจ architecture → ทำ ADR ก่อน commit)
