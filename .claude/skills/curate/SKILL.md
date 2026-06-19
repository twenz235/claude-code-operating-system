---
name: curate
description: Distill recent session captures into memory updates + write self-upgrade proposals. Runs a read-only curator subagent; the main agent persists results under an approval gate. กลั่น session capture ล่าสุด แล้วอัปเดต memory + เขียน proposal แก้ตัวเอง. Trigger when you want {{ASSISTANT}} to learn from past sessions (weekly cadence, or when the fleeting inbox has piled up).
---

# /curate — Distill knowledge + propose self-upgrades

**Purpose (EN):** Read what happened in recent sessions, pull durable facts into memory, and write *proposals* (never silent edits) for any change to {{ASSISTANT}}'s own behavior/skills/config.
**สรุปไทย:** อ่านสิ่งที่เกิดใน session ที่ผ่านมา ดึง fact ที่ควรจำเข้า memory และเขียน *ข้อเสนอ* (ไม่แก้เงียบ) สำหรับการเปลี่ยนพฤติกรรม/skill/config ของ {{ASSISTANT}} เอง

Reference: `{{VAULT}}/agent/upgrade-plan.md` (the continuous-learning plan) + the "self-upgrade rules" section of your `~/.claude/CLAUDE.md`.

> **The core split (กฎกลาง):** *facts about the user/project* may be written to memory directly. *Behavior / skill / CLAUDE.md / settings changes* may ONLY be written as proposals and must wait for human approval. This skill never applies a behavior change.

## Steps

1. **Spawn the `{{ASSISTANT}}-curator` subagent** (Agent tool, `subagent_type: {{ASSISTANT}}-curator`) and ask it to analyze:
   - Recent captures in `{{VAULT}}/inbox/fleeting/*-{{ASSISTANT}}-*.md` plus any other fleeting notes.
   - Recent daily notes in `{{VAULT}}/work/daily/`.
   - Current memory: read **every** memory dir relevant to the user — the per-project silos under `~/.claude/projects/<project>/memory/` (the canonical project silo **and** any silo that split off by cwd subfolder) **plus** the home silo `~/.claude/projects/<home>/memory/`, including each one's `MEMORY.md`.
     - **Silo policy (จาก review-proposals decision):** the canonical project silo is the **primary silo + source of truth** for that project's facts. Open project sessions from the project root so the canonical silo loads. Baseline user prefs (identity / communication style / working rules) live in `~/.claude/CLAUDE.md` (loaded on every cwd) — don't duplicate them inside a silo.
       - **Write/edit project facts in the canonical silo from now on.** The home silo may hold a **mirror** copy of project facts (in case a session is opened from `~`) → the mirror can go stale; the canonical silo is the real one. Any project fact still stranded in another silo (home, or a cwd-subfolder silo) → **consolidate it into canonical, don't leave it dangling.** (Facts stranded in a non-canonical silo can be lost silently — consolidate them; review-proposals step 5 is the safety net.)
   - The skill set in `~/.claude/skills/` + `~/.claude/CLAUDE.md`.
   - It returns a report with **two buckets** (A: memory facts / B: proposals). **It is read-only — it cannot write files.**

2. **Bucket A (memory facts)** — the main agent writes these itself (allowed by CLAUDE.md because these are "facts"):
   - `add` → create a new fact file + add a line to the `MEMORY.md` index.
   - `update` → edit the existing fact file.
   - `prune` → **archive into `memory/.archive/`, never hard-delete.** If unsure, ask the user first.

3. **Bucket B (proposals)** — **NEVER apply.** Write them all into one file `{{VAULT}}/agent/proposals/<YYYY-MM-DD>.md`:
   ```markdown
   ---
   tags: [agent, {{ASSISTANT}}, status/proposal]
   created: <datetime>
   ---
   ## <proposal title>
   - **Problem (ปัญหา):** ...
   - **Evidence (หลักฐาน):** ...
   - **Proposal (ข้อเสนอ):** ...
   - **Diff (การแก้ที่จะทำ):** <file + the change to make>
   - **Status:** pending
   ```

4. **Summarize for the user** briefly (สรุปสั้น ๆ): how many memory facts added/updated, how many proposals written, then tell them to run `/review-proposals` to decide on the proposals.

5. **Retention (archive distilled captures)** — once a capture (`*-{{ASSISTANT}}-*.md`) has been read and its facts pulled into memory, move it out of the live inbox: `mkdir -p "{{VAULT}}/inbox/fleeting/.curated"` then `mv` the file there (archive, don't delete — per vault convention). This keeps the fleeting inbox from bloating and shortens how long capture data sits exposed. **Interactive mode only** — the unattended mode is sandboxed away from the fleeting inbox, so it skips this and leaves the sweep to `/review-proposals` step 5.

## Iron rules (กติกาเหล็ก)
- **memory = writable; behavior/skill/CLAUDE.md = proposal only.** Never apply a behavior change inside this skill.
- If the curator reports nothing worth doing → write nothing, and say so plainly.
- Default mode = **interactive** (a human is watching; memory may be written directly). The **unattended / headless** mode uses the stricter rules below.

## Unattended mode (cron / scheduled task — no human) = PROPOSALS-ONLY
Runs via `~/.claude/hooks/curate-cron.sh` (headless `claude -p` with the sandbox profile `~/.claude/curate-sandbox.json`). Differences from default:
1. Analyze directly — **do NOT spawn the `{{ASSISTANT}}-curator` subagent.**
2. May read anything, but **may write to exactly one place: `{{VAULT}}/agent/proposals/<YYYY-MM-DD>.md`** (the sandbox denies all of `~/.claude/**`).
3. **Never touch memory directly** — any fact you'd want to add goes into the proposal under a `## Proposed memory additions` heading, for a human to apply via `/review-proposals`.
4. Behavior/skill changes → under a `## Proposed behavior/skill changes` heading — **never apply.**
5. Nothing high-signal → write nothing, stop.

> **Why (เหตุผล):** an agent running unattended can write a wrong fact (e.g. asserting a timer was installed when it wasn't). So in unattended mode everything passes through human review, with no exceptions.
