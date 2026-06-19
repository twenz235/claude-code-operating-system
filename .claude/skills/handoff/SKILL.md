---
name: handoff
description: Summarize context to hand off between sessions or agents — covering goal, decisions, blockers, and next step. (สรุป context ส่งต่อระหว่าง session หรือ agent) Trigger before closing an unfinished session, before delegating to another agent, or before /compact.
---

# Handoff

Reference: Matt Pocock's handoff pattern (optional public methodology credit) + your multi-agent pipeline.

## When to use (เมื่อไหร่ใช้)

- Closing a session where the work isn't finished (the next session must be able to resume). (ปิด session ที่งานยังไม่จบ)
- Delegating to a subagent (Agent tool) that needs broad context. (delegate ให้ subagent ที่ต้อง context กว้าง)
- Before using `/compact` (preserve critical state before it gets truncated). (ก่อน /compact เก็บ state สำคัญ)
- Handing work between people (a teammate) — write it into a tracker comment. (ส่งงานต่อระหว่างคน → เขียนลง comment ของ {{TRACKER}})

## Handoff structure (5 sections) (โครงสร้าง 5 หัวข้อ)

```
## Goal
[one sentence: the desired endpoint — verifiable]

## State
- ✅ [done, with evidence/path]
- 🟡 [in progress, what the blocker is]
- ⏸️ [paused, and why]

## Decisions made (irrevocable)
- [decision 1] — because [reason] — ADR/PR link if any
- [decision 2] — ...

## Open questions
- [unanswered question — who needs to answer it]

## Next step (concrete, smallest unit)
- [what to do first, in which file, expected result]
```

## Rules (กฎ)

- **State must have evidence** — "✅ added migration" isn't enough; it must be "✅ migration 0042_xxx created and applied". (State ต้องมี evidence)
- **A decision must say why**, not just what — the next person needs to judge whether it still holds. (Decision ต้องบอก why)
- **Next step must be concrete** — "fix tests" isn't enough; it must be "run `<test cmd> tests/test_X::test_Y` and fix expected vs actual on line 42". (Next step ต้อง concrete)
- **No assumptions** — if you're unsure, write "not yet verified"; don't write as if you know. (ถ้าไม่แน่ใจ เขียน "ยังไม่ verify")

## Trigger before using a subagent (ก่อนใช้ subagent)

If you use the Agent tool (subagent_type=Explore/Plan/etc.) — put the handoff into the prompt:
> "Context from parent: {handoff block}. Task: {specific request}. Constraints: {what to avoid}."
