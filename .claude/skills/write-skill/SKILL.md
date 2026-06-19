---
name: write-skill
description: Scaffold a new skill following the toolkit template — frontmatter, trigger, discipline, body sections / สร้างสกิลใหม่ตาม template. Trigger when adding a skill to the set or reshaping an old one to match the pattern.
---

# Write a Skill

Reference / อ้างอิง: public "write a skill" guidance (e.g. Matt Pocock) + the existing skill set.

## When to use / เมื่อไหร่ใช้

- Adding a new skill to the skill set. / จะเพิ่ม skill ใหม่
- Tightening an old skill's description/trigger. / ปรับ description/trigger ให้ชัด
- Capturing a workflow that has recurred ≥3 times (rule of three). / workflow ที่เกิดซ้ำ ≥3 ครั้ง

## Before writing — answer 3 questions / ก่อนเขียน ตอบ 3 คำถาม

1. **Is the trigger clear?** — "When X happens, use this skill." If you can't answer in 10 seconds, the trigger isn't clear. / Trigger ชัดไหม? ตอบไม่ได้ใน 10 วิ = ไม่ชัด
2. **What is the skill's output?** — template? checklist? decision? It must be something concrete. / Output คืออะไร? ต้องจับต้องได้
3. **Does it overlap an existing skill?** — if one is 80%+ similar, extend it instead of creating a new one. / ทับกับของเดิมไหม? คล้าย 80%+ → extend อย่าสร้างใหม่

## Template

```yaml
---
name: <kebab-case>
description: <situation, English-first> Trigger <english trigger keywords for the matcher>
---

# <Title>

Reference / อ้างอิง: <source: public methodology / your SOP / your team charter principle>

## When to use / เมื่อไหร่ใช้
- <specific trigger 1>
- <trigger 2>
- <trigger 3>

## Steps (or Framework) / ขั้นตอน
### 1. <step name>
<detail>

### 2. ...

## Output Template (if any)
```
<concrete output format the skill produces>
```

## Rules / กฎ
- <invariant 1>
- <invariant 2>

## Exit / Escalation (if any)
- If <X> → use skill <Y> instead.
```

## Description rules (most important) / Description rules (สำคัญสุด)

The Claude Code skill matcher uses `description` to decide which skill to call.
Claude Code matcher ใช้ `description` ตัดสินว่าจะเรียก skill ไหน

Good description:
- Starts with a verb / a clear situation. / เริ่มด้วยกริยา หรือสถานการณ์ชัด
- Has the word "Trigger" followed by English keywords (helps the matcher). / มีคำ "Trigger" + keyword อังกฤษ
- ≤250 characters. / ≤250 ตัวอักษร
- States the output / specific domain. / ระบุ output/domain

Bad description:
- "Helps with code" (too broad). / กว้างเกิน
- "This skill is used when..." (verbose). / verbose
- No trigger keywords. / ไม่มี trigger keyword
- Over 300 chars (the matcher may truncate). / ยาวเกิน 300 chars

## Naming rules / กฎตั้งชื่อ

- Keep names short and kebab-case; no mandatory prefix (add your own namespace prefix only if your team wants one). / ชื่อสั้น kebab-case ไม่บังคับ prefix (ใส่ namespace prefix เองได้ถ้าทีมอยากใช้)
- A verb or a noun-of-output (not flowery). / กริยา หรือ noun-of-output
- ≤25 chars. / ≤25 ตัวอักษร

Example: `debug-mantra` (good), `the-debugging-helper-skill` (bad).

## Before committing a new skill / ก่อน commit skill ใหม่

1. Test the trigger in a fresh Claude Code session — does Claude call the skill on its own when you say the target sentence? / เทส trigger ใน session ใหม่
2. Update your skills index (e.g. `.claude/skills/README.md`) with a new row. / อัปเดต index เพิ่ม row
3. If the skill couples to a project pipeline, update that project's `<project-root>/CLAUDE.md`. / ถ้าผูกกับ pipeline ของโปรเจกต์ ให้อัปเดต CLAUDE.md ของโปรเจกต์นั้น

## After using it 2–3 times / หลังใช้ 2-3 ครั้ง

- Works well? → keep as-is. / ดีอยู่แล้ว เก็บไว้
- Forgot to call it? → the trigger isn't clear → tune the description. / ลืมเรียก → description ไม่ชัด → ปรับ
- Called too often (when it shouldn't be)? → description too broad → narrow it. / เรียกบ่อยเกิน → กว้างเกิน → narrow
