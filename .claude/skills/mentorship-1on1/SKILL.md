---
name: mentorship-1on1
description: Run a 1-on-1 mentoring session (at least once per sprint) and a 5-step underperformance process. 1-on-1 mentoring + กระบวนการ underperformance 5 ขั้น. Trigger before a 1-on-1 or when handling underperformance.
---

# Mentorship & 1-on-1

Reference (adapt to your own docs): your team's job-description / responsibilities doc + your engineering playbook. Replace the section cites with your own.

## 1-on-1 regular session (>=1 per sprint)

- Template: `{{VAULT}}/templates/1on1.md`
- Notes: `{{VAULT}}/work/areas/team-coordination/1on1/<dev-name>/`

(These are example vault paths — point them at wherever your notes live. ปรับ path ให้ตรง vault ของคุณ)

Suggested agenda / Agenda แนะนำ:
1. What is the goal of this session?
2. Update from the dev (work, how they feel, blockers)
3. Feedback (lead -> dev and dev -> lead)
4. Growth: what skill does the dev want to develop?
5. Action items on both sides

**Always write it down** — a core charter principle is *written/auditable*: if it isn't recorded, it didn't happen. บันทึกทุกครั้ง ไม่บันทึก = ไม่เกิดขึ้น

## Underperformance 5-step process

**Do not skip a step.** ห้ามข้าม step — each step is documented and gated by the previous one.

### Step 1: Identify & document
- State the specific problem (with concrete examples)
- Record it in the 1-on-1 notes
- Not a gut feeling — have evidence. ไม่ใช่ gut feeling

### Step 2: Clarify expectations
- Spell out the expected standard clearly
- Have the dev confirm they understand
- Record it in the 1-on-1 notes

### Step 3: Support & resources
- What can the lead do to help? (mentoring, training, reduced scope)
- Set a review timeline

### Step 4: Formal warning (if steps 1–3 don't improve)
- Put it in writing
- Inform your {{OWNER_ROLE}} (manager / decision-maker) — keeps it auditable
- The {{OWNER_ROLE}} makes the final call — the tech lead advises, does not decide alone

### Step 5: Structural resolution
- If the local hiring market is constrained and you genuinely can't source a replacement, surface it to your {{OWNER_ROLE}} as a **structural** problem.
- A structural shortage is not a personal failure of the tech lead. ตลาดจ้างแคบ = ปัญหาเชิงโครงสร้าง ไม่ใช่ความผิด TL

## Fallback work (tech lead writes code to close a gap)
If the tech lead has to write code to cover a gap:
- That code still goes through review by **another reviewer** (e.g. a separate security/compliance reviewer) — never self-merge. ห้าม self-merge
- Record *why* it was necessary and inform your {{OWNER_ROLE}}.
