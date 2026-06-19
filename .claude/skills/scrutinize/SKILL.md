---
name: scrutinize
description: Review a plan, PR, or code change as an outsider — ask for intent first, trace the real code path, verify every claim. Review แบบ outsider ถาม intent ก่อน trace path จริง. Trigger before merging an important PR or approving a design the tech lead must sign off on.
---

# Scrutinize

Reference: a common adversarial-review methodology + your code-review SOP (review 100% of PRs) + the "explain design choices" and "security-conscious" charter principles. อ้างอิง scrutinize + SOP code review + หลักการของทีม (charter) explain-design + security-conscious.

## When to use — เมื่อไหร่ใช้

- Before approving a PR (target SLA: 1 working day). ก่อน approve PR.
- Before approving a design / ADR. ก่อน approve design / ADR.
- When asked to review a plan or code change. เมื่อถูกขอ review.

## Stance

- **Outsider** — forget who wrote it; read it cold. ลืมว่าใครเขียน อ่าน cold.
- **End-to-end** — the diff is just the starting point; trace into the real call graph. diff เป็นแค่จุดเริ่ม.
- **Cite or it didn't happen** — every claim cites a `file:line` or a trace step. ทุก claim อ้าง file:line.

## Workflow (do not skip a step) — Workflow ห้ามข้าม step

### 1. Intent — what is the goal? เป้าหมายคืออะไร?

- State the goal in your own words. If you can't → the artifact is underspecified → stop. ถ้าบอกไม่ได้ → หยุด.
- **Is there a simpler way?** Including "don't do it at all". มีทางที่ง่ายกว่าไหม รวมถึง "ไม่ทำเลย".
- Is there something already in the codebase that does this? มีของที่มีอยู่แล้วใช้ได้ไหม?

### 2. Trace — follow the real code path. ไล่ code path จริง.

- Entry point → call sites → branches → state mutated → exit.
- Include unchanged code around the diff (bugs hide at the seam). bug ซ่อนที่ seam.
- Document every place the trace surprised you. ทุกที่ที่ trace แล้วแปลกใจ.

### 3. Verify — do claims match the traced path? claim ตรงกับ path ไหม?

- Can the code path actually produce the claimed behavior? produce behavior ที่ claim ได้จริงไหม?
- Which input breaks it? (edge case, concurrent, error path, null). Input ไหนทำให้พัง?
- Did anything change silently? (performance, error semantics, contract). เปลี่ยนแบบ silent ไหม?
- Do the tests exercise the real path, or skip through a mock? test path จริงหรือ skip ผ่าน mock?

### 4. Report

Format: **Finding** → **Why it matters** → **Evidence** → **Suggested change**.
Order: blocker → major → nit.
Close with a one-line verdict: `ship` / `fix-then-ship` / `rework` / `reject`.

## For the tech lead (code-review SOP) — สำหรับ TL

- PR review SLA: 1 working day.
- No self-approve (charter: review must be independent). ห้าม self-approve.
- If you find a security concern → escalate per your security SOP. escalate.
- Record review feedback in the PR comment (written/auditable). บันทึก feedback ใน PR comment.

## Hard rules — กฎเหล็ก

- No rubber-stamping / "LGTM" without tracing. ห้าม rubber-stamp.
- If you find no issue, say what you traced — not just "looks fine". บอกว่า trace อะไรบ้าง.
- Mandatory simpler-alternative pass on every PR, no matter how small. mandatory simpler-alternative pass ทุก PR.
