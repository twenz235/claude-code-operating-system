---
name: debug-mantra
description: A compact 4-step debug discipline to run before escalating to a full systematic debugger. (วินัย debug 4 ขั้นแบบกระชับ ก่อน escalate ไป debugger เต็มรูปแบบ) Trigger on first sight of a bug, an error-tracker alert, or before a deep diagnose.
---

# Debug Mantra (Compact 4-Step)

Reference: a common debugging methodology, distilled into a fast pre-flight before the full bug-fix pipeline.

## When to use (เมื่อไหร่ใช้)

- A newly reported bug (from a dev, a user, or your error tracker). (bug รายงานใหม่)
- Before invoking a full systematic debugger — run this first. (ก่อนเรียก debugger เต็มรูปแบบ ลองวิ่งผ่านนี้ก่อน)
- Before forming a hypothesis in your head. (ก่อนเขียน hypothesis ในหัว)

## 4 steps — don't skip, don't reorder (4 ขั้น ห้ามข้าม ห้ามสลับลำดับ)

### 1. Reproduce — make it happen again first
- Do you have a minimal reproduction yet? (curl command / test case / step-by-step) (มี minimal repro แล้วหรือยัง)
- If you can't reproduce → STOP, go back and ask the reporter for data, don't guess. (reproduce ไม่ได้ → STOP ขอ data จาก reporter อย่าเดา)
- Record the reproduction in the issue/PR description. (บันทึก repro ลง issue/PR)

### 2. Trace — walk the real fail path, line by line
- From the entry point (request/event) all the way to the error. (จาก entry ไปจน error)
- Use logging/breakpoints/print — don't just read the code and guess. (ห้ามอ่านโค้ดอย่างเดียวแล้วเดา)
- Record at each step: input → expected → actual. (บันทึก input → expected → actual)

### 3. Falsify — prove the hypothesis right or wrong
- Have at least 2 hypotheses (the one you think is right + one you think is wrong). (มี hypothesis อย่างน้อย 2 ข้อ)
- Find a direct way to prove it (change input, mock a dependency, swap a version). (หาวิธีพิสูจน์ตรง ๆ)
- Don't accept the first hypothesis that "seems to fit" — falsify the others too. (อย่ายอมรับอันแรกที่ดูเข้ากัน)

### 4. Cross-reference — compare against what you already know
- Have you seen this pattern before? (post-mortem registry, agent-improvement log) (เคยเห็น pattern นี้ไหม)
- Any related ADR or commit message? (มี ADR/commit ที่เกี่ยวข้องไหม)
- Compare with the docs/spec of the library you're using. (เทียบกับ doc ของ library)

## Iron rules (กฎเหล็ก)

- Never skip step 1 (reproduce) — fixing a bug you can't reproduce is "guessing". (ห้ามข้าม reproduce)
- Don't move to step 2 before step 1 is done. (ห้ามไปขั้น 2 ก่อนขั้น 1 เสร็จ)
- After step 4, if still stuck → escalate to a full systematic debugger; don't loop the mantra again. (escalate อย่าวน mantra ซ้ำ)
- Once you find the root cause → continue with `post-mortem` (write the RCA). (เจอ root cause → ต่อด้วย post-mortem)

## Output Template

```
## Bug: [short description]

**Reproduce:** [exact steps / minimal repro]
**Trace:** [fail path summary, key line where actual ≠ expected]
**Falsified:** [hypotheses considered and their status]
**Cross-ref:** [past incidents / ADR / doc related]
**Root cause:** [statement]
**Fix plan:** [what to change, where]
```
