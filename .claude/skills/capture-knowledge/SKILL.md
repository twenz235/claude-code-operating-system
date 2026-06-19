---
name: capture-knowledge
description: Capture new knowledge into an inbox first, every time — don't judge or organize at capture time, organize later / จับความรู้เข้า inbox ก่อนเสมอ. Trigger when you hit an insight, a learning, or important information worth keeping.
---

# Capture Knowledge

Reference / อ้างอิง: inbox-first PKM practice + your team charter principles on written/auditable knowledge and no-irreplaceable-person (bus factor).

This skill assumes you keep a personal notes vault. The paths below use `{{VAULT}}` as the
vault root — point it at whatever you use (Obsidian, plain Markdown folder, a docs wiki, etc.).
สกิลนี้ใช้ `{{VAULT}}` เป็น root ของ notes vault — ชี้ไปที่เครื่องมือไหนก็ได้

## Principle: Inbox-First, always / หลักการ: เข้า inbox ก่อนเสมอ

Whatever it is → it goes into `{{VAULT}}/inbox/fleeting/` first. Organize later.
อะไรก็ตาม → เข้า `{{VAULT}}/inbox/fleeting/` ก่อน แล้วค่อย organize

The point is to lower capture friction to near zero. Sorting at capture time is what kills the habit.
จุดสำคัญคือลด friction ตอน capture ให้เกือบศูนย์ — การจัดระเบียบตอน capture คือสิ่งที่ทำให้เลิกทำ

## How to capture / วิธี capture

### A quick thought / insight / thought-insight เร็ว ๆ
Create a note at `{{VAULT}}/inbox/fleeting/<YYYY-MM-DD>-<slug>.md`:
```markdown
---
created: <datetime>
tags: [status/inbox, idea/insight]
---
<content>
```

### An article/doc you read and summarized / article ที่อ่านแล้วสรุป
Create at `{{VAULT}}/inbox/literature/<slug>.md`:
```markdown
---
created: <datetime>
source: <URL/Book>
tags: [status/inbox]
---
## Summary / สรุป
<your own words, not a copy>

## Key Insights
-

## Related
[[]]
```

### A work learning (bug fix, architecture decision) / work learning
- Drop the gist into the inbox first. / ใส่หลักสั้น ๆ เข้า inbox ก่อน
- Later, organize it into your work/domain notes (e.g. `{{VAULT}}/work/areas/` or `{{VAULT}}/library/technology/`). / ค่อย organize ไป work/domain ทีหลัง
- If the learning has bus-factor value (only-in-your-head knowledge), promote it to a runbook/handbook entry so the team isn't blocked without you. / ถ้าเป็นความรู้ที่อยู่ในหัวคนเดียว ให้ promote เป็น runbook/handbook

## Organize (weekly, or when the inbox fills up) / Organize (รายสัปดาห์ หรือเมื่อ inbox เต็ม)
For every inbox note, do one of three things / ทุก note ใน inbox ทำ 1 ใน 3:
1. **Process** → organize it into the right place (library / work / goals). / จัดไปที่ถูกต้อง
2. **Incubate** → change the tag to `#status/incubating` and let it sit. / เปลี่ยน tag เป็น incubating รอ
3. **Delete** → information that's no longer useful, drop it. / ลบทิ้ง

## Link every note (linking principles) / Link ทุก note
- `created:` — date created. / วันที่สร้าง
- `tags:` — relevant categories. / หมวดที่เกี่ยว
- `related:` — links to other related notes. / ลิงก์ไป note อื่นที่เกี่ยว

## Note / หมายเหตุ
The exact folder names and tag taxonomy are conventions — adapt them to your vault.
What matters is: capture-first, low friction, organize on a cadence, link everything.
ชื่อ folder/tag เป็น convention — ปรับตาม vault ของคุณได้ สิ่งที่สำคัญคือ capture ก่อน, friction ต่ำ, organize ตามรอบ, link ทุกอัน
