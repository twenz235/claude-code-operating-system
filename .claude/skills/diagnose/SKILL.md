---
name: diagnose
description: A 4-mantra debug discipline for hard bugs — reproduce → trace the fail path → falsify hypotheses → cross-reference breadcrumbs. (วินัย debug 4 ข้อ สำหรับ bug ยาก) Trigger on a bug report or a production incident / error-tracker alert.
---

# Diagnose — Debug Mantra

Reference: a common debugging methodology + Matt Pocock's diagnose pattern (optional public methodology credit) + your monitoring SOP + your team charter.

## Recite before starting a debug session (verbatim)

> **Mantra:**
> 1. **First is reproducibility.** Can the issue be reproduced reliably?
> 2. **Know the fail path.** Debugger first; then source trace + knob enumeration; then in-code instrumentation.
> 3. **Question your hypothesis.** What would disprove it?
> 4. **Every run is a breadcrumb.** Cross-reference all of them.

---

## Phase 1: Build a feedback loop (the heart of everything)

**Never propose a fix before you have a reliable repro.** (ห้ามเสนอ fix ก่อนมี repro ที่ reliable)

Ways to build a repro (try in order):
1. Failing test
2. curl / HTTP script against the dev server
3. CLI invocation + fixture input
4. Replay a captured trace (HAR, log dump)
5. A throwaway minimal harness

**Flaky bug:** raise the reproduction rate first (50% = debuggable, 1% = not yet). (flaky → ยก repro rate ก่อน)
**No repro at all:** stop, say so straight, ask for artifacts (log, HAR, screen recording). (ไม่มี repro → หยุด ขอ artifact)

## Phase 2: Know the fail path

1. **Debugger first** — one breakpoint beats ten log lines. (breakpoint 1 จุด ดีกว่า log 10 จุด)
2. **Source trace + knob enumeration** — config flags, env vars, branch conditions, timing.
3. **In-code instrumentation** — tag logs with a prefix like `[DBG-a4f2]`, clean up with one grep. (cleanup ด้วย grep เดียว)

## Phase 3: Falsify the hypothesis

- Generate 3–5 hypotheses before testing any one of them. (สร้าง 3–5 hypothesis ก่อนทดสอบ)
- **Run the disproof first** — only believe a hypothesis if it survives. (run disproof ก่อน รอดได้ค่อยเชื่อ)
- Each hypothesis must state a prediction: "if X is the cause, Y will..." (ระบุ prediction)

## Phase 4: Breadcrumb ledger

Record **every** experiment in the session:
> `[experiment] → [outcome] → [ruled in/out]`

When a new hypothesis arrives: check it's consistent with **every** prior observation. (ตรวจว่าสอดคล้องกับทุก observation เดิม)
If not consistent → refine or discard. (ไม่สอดคล้อง → refine หรือ discard)

## After the fix (หลัง fix แล้ว)

- Write a regression test (if there's a correct seam). (เขียน regression test ถ้ามี seam ที่ถูกต้อง)
- Re-run any runbook-sync step if the runbook changed. (sync runbook ถ้าเปลี่ยน)
- Propose a post-mortem if this bug is worth documenting (use the `post-mortem` skill). (เสนอ post-mortem)
- Propose an architecture review if you couldn't find a good seam (use the `improve-architecture` skill). (เสนอ architecture review ถ้าหา seam ดีไม่ได้)

## For the tech lead specifically (สำหรับ [tech lead] โดยเฉพาะ)

- A critical error-tracker alert → respond within your incident SLA (example: ≤4 hours, a delivery KPI). (response ตาม SLA)
- Record the outcome in the relevant per-area note in your notes vault: `{{VAULT}}/work/areas/`. (บันทึกผลใน vault ที่เกี่ยวข้อง)
