---
name: management-talk
description: Translate engineer-to-engineer content into language for management / leadership; adapt to channel (issue tracker, team chat, email, standup, meeting). แปลงเนื้อหา engineer→management ตาม channel. Trigger when reporting up (monthly/quarterly) or escalating an incident.
---

# Management Talk

Translate deeply technical updates into something a non-engineer decision-maker can act on.
แปลงอัปเดตเชิงเทคนิคให้ผู้บริหาร/ผู้ตัดสินใจที่ไม่ใช่วิศวกร เอาไปตัดสินใจต่อได้

Reference (adapt to your own docs): a common engineering "management-talk" practice + your team's reporting SOPs (monthly report, overload notification). Replace these with your team's SOP names where applicable.

## When to use / เมื่อไหร่ใช้
- Monthly report to your {{OWNER_ROLE}} (manager / decision-maker / ops lead)
- Quarterly report (e.g. KPI / bonus self-review)
- Advance overload notification (flag capacity risk before it bites)
- Escalate a production incident to leadership
- Turn a post-mortem into a leadership-facing version

## Audience: your {{OWNER_ROLE}}
The reader is a decision-maker, not an engineer. Assume they:
- CAN read product/feature names and ticket keys (e.g. `PROJ-123`)
- do NOT read function names, file paths, or commit SHAs
- WANT: status, business impact, owner, next step

ปรับสมมติฐานนี้ตาม {{OWNER_ROLE}} จริงของคุณ — บางคนอ่านเทคนิคได้มากกว่านี้

## Channel shapes

### Monthly report (structured)
```
## Monthly summary [YYYY-MM]

**People / enablement:** [who completed what training / curriculum, gaps observed]
**Infrastructure:** [backup mirror done, secrets rotated, dependency alerts status]
**KPI snapshot** (use your own KPI set — example below):
- (a) Hiring: [one line]
- (b) Leadership: [one line]
- (c) Risk: [one line]
- (d) Delivery: uptime X%, critical errors: X
**Action items for next month:** [list]
```

### Overload notification
```
**[date] — Heads-up: capacity nearing limit**
Cause: [project A + B overlap during window X]
Expected impact: [delivery Y may slip N days]
Options: [A] or [B] — requesting your input
```
ส่งล่วงหน้า ไม่ใช่ตอนพังแล้ว — จุดเด่นคือ "แจ้งก่อน"

### Async / chat (short)
```
**[Lead update]** [one-line summary] — details in [ticket/doc link]
```

## Translation rules
- **Keep:** product name, ticket key, PR number, dev's name, tool name (your issue tracker, error tracker, etc.)
- **Strip:** function name, file path, commit SHA, struct/field name
- **Translate:** mechanism → cause-and-effect in plain language (1–2 sentences) แปลกลไก → เหตุ-ผลแบบภาษาคน

## Hard rules / กฎเหล็ก
- Never invent facts — if you don't know, say you don't know. ห้ามมั่ว
- Never strip the ticket key or PR number (they are the audit trail).
- State coverage honestly — if you only tested some configs, say so. บอก coverage ตรง ๆ
