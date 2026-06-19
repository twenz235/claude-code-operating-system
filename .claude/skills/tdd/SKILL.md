---
name: tdd
description: Test-driven development, red-green-refactor, one behavior at a time (vertical slice — not horizontal coverage). Coverage threshold e.g. ≥80% backend / ≥70% frontend per your test SOP. TDD ทีละ behavior. Trigger when implementing a feature or fixing a bug.
---

# TDD — Test-Driven Development

Reference: a common red-green-refactor TDD methodology + your backend/API test SOP (coverage target, e.g. ≥80%) + the "quality over speed" charter principle. อ้างอิง TDD red-green-refactor + SOP test coverage + หลักการของทีม (charter) คุณภาพเหนือความเร็ว.

## When to use — เมื่อไหร่ใช้

- Implementing a new feature. implement feature ใหม่.
- Fixing a bug. fix bug.
- Refactoring that affects behavior. refactor ที่มีผลกับ behavior.

## Principles — หลักการ

**Good tests:** exercise the public interface; describe what the system does, not how. ทดสอบผ่าน public interface, บอกว่าทำอะไรได้ ไม่ใช่ทำอย่างไร.
**Bad tests:** mock internals, test private methods, break on refactor even when behavior is unchanged. mock internal, test private method, break เมื่อ refactor.

## Anti-pattern to avoid: horizontal slice — Anti-pattern ที่ห้ามทำ

```
WRONG:
  RED: test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

CORRECT (vertical slice):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  ...
```

## Workflow

### 1. Plan before writing — วางแผนก่อนเขียน

- [ ] Which interface will change? interface ที่จะเปลี่ยนคืออะไร?
- [ ] Which behavior matters most? (Don't cover every edge case.) behavior ไหนสำคัญที่สุด?
- [ ] Is there prior art in the codebase? (A similar test.) prior art มีไหม?
- [ ] Note your coverage target from the test SOP (example: backend ≥80%, frontend ≥70%). อ้างเกณฑ์ coverage.

### 2. Tracer bullet (first test) — Tracer bullet (test แรก)

RED: write one test → it fails. เขียน test 1 ตัว → ล้มเหลว.
GREEN: write the least code to pass. เขียนโค้ดน้อยที่สุดให้ผ่าน.

### 3. Loop

RED → GREEN, one behavior at a time, until done. ทีละ behavior จนครบ.

### 4. Refactor (only after GREEN) — Refactor หลัง GREEN เท่านั้น

- Cut duplication. ตัด duplication.
- Make the module deeper. ทำ module ให้ deep ขึ้น.
- Do all tests still pass? test ยังผ่านทุกตัวไหม?

## Checklist per cycle — Checklist ต่อ cycle

- [ ] The test describes behavior, not implementation. test บอก behavior ไม่ใช่ implementation.
- [ ] The test uses only the public interface. test ใช้แค่ public interface.
- [ ] The test survives a refactor. test รอด refactor ได้.
- [ ] The least code for this test. โค้ดน้อยที่สุดสำหรับ test นี้.
