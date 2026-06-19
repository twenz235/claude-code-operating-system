---
name: goal-driven-execution
description: Translate a task into verifiable success criteria, then loop until verification passes — and always tie the task back to your team's KPIs. (แปล task เป็น success criteria ที่ตรวจสอบได้ แล้ว loop จน verify ผ่าน) Trigger when you take on a new task or start a sprint.
---

# Goal-Driven Execution

Reference: goal-driven-agent practice (optional public methodology credit) + your team's KPI set + your team charter.

## When to use (เมื่อไหร่ใช้)
- Taking on a new task. (รับ task ใหม่)
- Starting a sprint. (เริ่ม sprint)
- A task whose criteria are still vague ("just make it work"). (criteria ยังไม่ชัด)

## Translate task → success criteria (แปล task → success criteria)

| Instead of saying | Translate to |
|-------------------|--------------|
| "Add validation" | "Write a test for invalid input, then make it pass" |
| "Fix the bug" | "Write a test that reproduces it, then make it pass" |
| "Refactor X" | "Tests pass both before and after" |
| "Build feature Y" | "User story X works without breaking existing tests" |

## Plan template for a multi-step task

```
1. [step] → verify: [measurable check]
2. [step] → verify: [measurable check]
3. [step] → verify: [measurable check]
```

## Tie back to your team's KPIs (เชื่อมกับ KPI ของทีม)

Before starting a task, ask which KPI it relates to. The set below is an **example** — replace with your own team's KPIs:

- **(a)** hiring quality — rubric complete? rejection reasons recorded? (rubric ครบ? เหตุผลปฏิเสธบันทึกแล้ว?)
- **(b)** leadership quality — PR reviews done? handbook updated? (PR review ครบ? handbook อัปเดต?)
- **(c)** risk management — told your manager / decision-maker if overloaded? estimate accurate? (แจ้งเมื่อ overload? estimate ตรง?)
- **(d)** delivery — uptime within target (example: ≥99.5%)? critical errors = 0? (uptime ถึงเป้า? critical = 0?)

## Iron rules (กฎเหล็ก)
- "Make it work" is not a success criterion — it must be measurable. (ต้องวัดได้)
- Loop until the real criteria pass, not just until it "looks okay". (loop จนผ่าน criteria จริง)
