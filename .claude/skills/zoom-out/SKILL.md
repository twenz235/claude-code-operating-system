---
name: zoom-out
description: Gather surrounding context before editing unfamiliar code — read module structure, ADRs, tests, call-sites before touching a line / อ่านบริบทรอบ ๆ ก่อนแก้โค้ดที่ไม่คุ้น. Trigger before touching code whose call sites you haven't seen, when confused, or before a refactor.
---

# Zoom Out

Reference / อ้างอิง: public "zoom out" guidance (e.g. Matt Pocock) + your team charter principle on written/auditable decisions (there are ADRs to read).

## When to use / เมื่อไหร่ใช้

- You're about to edit a file you've never read. / จะแก้ไฟล์ที่ยังไม่เคยอ่าน
- You don't know where the function you'll change is called from. / ไม่รู้ว่า function ถูกเรียกจากไหน
- You feel "confused" about why the code is written this way. / งงว่าทำไมเขียนแบบนี้
- Before starting a refactor (don't touch until you see the whole picture). / ก่อน refactor — อย่าแตะถ้ายังไม่เห็นภาพรวม
- A sub-agent (Explore) just returned an excerpt but you still can't see the shape. / subagent คืน excerpt มาแต่ยังไม่เห็นภาพ

## 4-Step Zoom Out

### 1. Module map / แผนที่ module
- Read the module's public entry (`__init__.py` / `index.ts`) to learn the public API. / ดู entry เพื่อรู้ public API
- Read the folder structure (apps/, services/, components/) to understand the layering. / ดู structure เข้าใจ layering

### 2. Call sites / จุดที่เรียก
- `grep -rn "functionName(" --include="*.py"` to find real callers. / หา caller จริง
- How many callers? How does each use it? / caller กี่ที่? ใช้แบบไหน?
- If callers > 5 → refactor risk is high → add integration tests first. / caller > 5 → เสี่ยงสูง → integration test ก่อน

### 3. Related docs / เอกสารที่เกี่ยว
- ADRs that mention this module (`grep -rn "module-name" docs/adr/`). / ADR ที่พูดถึง module นี้
- CHANGELOG entries.
- File commit history (`git log -p <file> | head -100`). / ประวัติ commit ของไฟล์

### 4. Existing tests / เทสที่มีอยู่
- Is this function covered by tests? / มี test cover ไหม?
- Which edge cases do the tests cover? Which are uncovered? / cover edge case อะไรบ้าง ตัวไหนยัง?
- If there are no tests → **write a test before changing** (see tdd). / ไม่มี test → เขียน test ก่อนแก้

## Output before you touch code / Output ก่อนแตะโค้ด

```
## Zoom Out: [target function/module]

**Public surface:** [exported APIs]
**Call sites:** [N callers, key examples]
**Constraints learned:** [from ADRs / comments / tests]
**Risk areas:** [things that, if changed, will ripple]
**Plan:** [where to change first, and why]
**Pre-flight tests:** [tests that must pass identically before and after]
```

## Rules / กฎ

- **Don't edit before zooming out** if the file is unread and >50 lines. / ห้ามแก้ก่อน zoom out ถ้าไฟล์ยังไม่อ่าน (>50 บรรทัด)
- **Don't refactor until zoom-out is complete** — find all callers first. / ห้าม refactor จนกว่าจะหา caller ครบ
- **Don't trust an old ADR without verifying** — ADRs may be outdated (check the date). / ห้าม trust ADR เก่าโดยไม่ verify
- If after zooming out you still don't understand → use `grill-with-docs` or ask the human owner. / ยังไม่เข้าใจ → ใช้ grill-with-docs หรือถาม owner

## Sub-agent trigger / Trigger สำหรับ subagent

If you'll use an `Explore` agent, write the prompt: "Zoom out on {file}: list public surface, call sites, related ADRs, existing tests. Report only — do not edit."
