# Team Charter (template)

> **Copy this file, fill it with YOUR principles, and save it as your charter.**
> Suggested location: `{{VAULT}}/reference/charter.md`. This is a scaffold — the principles below are **neutral samples to replace**, not rules to adopt as-is.

A charter is a **short** list of standing principles your team's decisions must respect. Keep it small — a handful you actually live by beats a long list nobody reads. Some principles are **non-negotiable**: they override convenience, deadlines, and even contracts. Mark those clearly.

> **ธรรมนูญทีม (TH):** รายการหลักการสั้น ๆ ที่ทุกการตัดสินใจต้องเคารพ — บางข้อ "ยกเลิกไม่ได้" (เหนือความสะดวก/เดดไลน์/สัญญา) ให้ทำเครื่องหมายให้ชัด ตัวอย่างด้านล่างเป็น placeholder ให้แทนที่ด้วยของจริง

## How this file is used

- **`charter-check`** surfaces the relevant principles before a non-routine, significant decision and forces you to check against the non-negotiables. It only knows what you write here.
- **`grill-with-docs`** reads it (as `{{VAULT}}/reference/charter.md`) when aligning on a new feature.

So the value of this file is proportional to how honestly you fill it in. Vague principles produce vague checks.

## Conventions

- Mark a non-negotiable principle with **⛔**. Everything else is a strong default that can bend with a documented reason.
- One line each. If a principle needs a paragraph to explain, it's probably two principles.
- Order doesn't imply priority unless you say so.

---

## Principles

> Replace every row below with your own. These three are illustrative only.

| # | Principle | Non-negotiable? | Notes |
|---|-----------|-----------------|-------|
| 1 | **Decisions are written down and auditable** — significant choices get a record (ADR / note), not just a verbal agreement. | ⛔ | Future readers must be able to reconstruct *why*. |
| 2 | **Quality over speed** — we don't ship known-broken work to hit a date; we re-plan the date instead. | ⛔ | A deadline is a constraint, not a reason to skip review/tests. |
| 3 | **No single point of failure (bus factor)** — knowledge that lives in one person's head gets written into a runbook within the week. |  | Anyone on the team can be unavailable without blocking the work. |

> Add the rest of yours below — e.g. security-by-default, legal correctness, code-must-be-explainable, confidentiality, IP protection. Decide which carry **⛔**.

---

## Applying a principle (when a decision is in play)

1. **Identify** which principles this decision touches.
2. **Check the non-negotiables (⛔):** does the decision conflict with any?
   - **Conflicts →** don't do it. No exception. Escalate to your {{OWNER_ROLE}} with the reasoning.
   - **No conflict →** record that the check passed and why.
3. **Write it down** (per principle #1) — an ADR or a decision note, depending on context.

> **ใช้งานจริง (TH):** เจอ decision สำคัญ → ดูว่าแตะหลักการข้อไหน → ถ้าขัดข้อ ⛔ ห้ามทำ ให้ escalate; ถ้าไม่ขัด บันทึกเหตุผลไว้

---

## Optional: documented preferences (not principles)

Some teams keep lightweight conventions here too — they're preferences, not inviolable principles. For example, **whether to include AI co-author attribution in commits/PRs** is an optional, documented choice: if your team wants it omitted (or required), write it down here and the skills will respect it. Left unstated, the harness default applies. Keep these clearly separate from the ⛔ principles above so the distinction stays honest.
