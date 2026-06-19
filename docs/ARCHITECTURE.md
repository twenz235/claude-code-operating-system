# Architecture

How the pieces of the Claude Code Operating System (CCOS) fit together — and why the **self-upgrade approval gate** is the design that makes the rest safe to run.

> **ภาพรวม (TH):** CCOS = ระบบปฏิบัติการสำหรับ Tech Lead/dev บน Claude Code — รวม standing rules + skills + agents + hooks + memory + ลูปอัพเกรดตัวเองที่มี "ประตูอนุมัติ" เป็นหัวใจความปลอดภัย

---

## The headline: the self-upgrade approval gate

Most of CCOS is ordinary configuration. The one genuinely load-bearing safety property is this:

> **The assistant can propose changes to its own behavior, but it can never apply them silently. Every change to a skill / `CLAUDE.md` / `settings.json` / an agent passes through one human-approved chokepoint, one item at a time.**

This is what makes it safe to let the system *learn from its own sessions on a schedule*. An agent that edits its own instructions unattended is a runaway risk; an agent that can only ever **write a proposal a human later approves** is auditable by construction.

### Two rails, deliberately separated

CCOS splits everything the assistant might want to persist into two rails with different trust levels:

| Rail | What it is | Who may write it | Where |
|------|-----------|------------------|-------|
| **Facts** | Durable facts about the user / project / decisions (preferences, paths, choices) | The assistant may write these **directly** (interactive) | `~/.claude/projects/<project>/memory/` + `MEMORY.md` |
| **Behavior** | Changes to the assistant's own skills, `CLAUDE.md`, settings, agents | **Proposal only** — applied by a human via `/review-proposals` | `{{VAULT}}/agent/proposals/` → `applied/` |

The split is enforced, not just documented: the read-only curator can't write at all, and the unattended cron run is **sandboxed out of `~/.claude` entirely** (it can write *only* the proposals dir). So even a confidently-wrong assistant cannot mutate its own brain without a human in the loop.

### The loop, end to end

```
        every session                    weekly (unattended)            on demand (human present)
   ┌────────────────────┐          ┌──────────────────────────┐      ┌──────────────────────────┐
   │  Stop hook          │          │  curate-cron.sh           │      │  /review-proposals        │
   │  capture.sh         │          │  (headless claude -p      │      │  approve / reject / edit  │
   │  → one redacted      │  reads   │   + curate-sandbox.json) │      │  ONE item at a time       │
   │    note per session  ├─────────▶│  reads everything,       │      │  → applies approved diffs │
   │  → inbox/fleeting/    │          │  writes ONLY proposals/  ├─────▶│  → moves file to applied/ │
   └────────────────────┘          └──────────────────────────┘      └──────────────────────────┘
            │                                  ▲                                   │
            │ next session                     │ /curate (interactive)             │ edits skills/CLAUDE.md/
            ▼                                  │ spawns read-only curator           ▼ settings — the ONLY place
   ┌────────────────────┐                     │ → main agent persists facts,      ~/.claude is mutated
   │ SessionStart hook   │                     │   writes proposals
   │ session-start.sh    │─────────────────────┘
   │ → injects latest    │
   │   handoff + daily +  │
   │   pending proposals  │
   └────────────────────┘
```

The gate is `/review-proposals`. Nothing reaches the assistant's own configuration except through it.

---

## The pieces

### 1. `CLAUDE.md` — standing rules

The user-level `CLAUDE.md` is the assistant's persona and permanent operating rules: how it communicates, how it works (think before coding, do only what's asked, KISS, explain design choices), git/prod safety, and the **self-upgrade rules** that mandate the two-rail split above. It loads on every session and is overlaid by a per-project `{{PROJECT}}/CLAUDE.md` when you open a project. Project rules win on conflict.

### 2. Skills — the repeatable disciplines

The skill toolkit (under `~/.claude/skills/<name>/SKILL.md`) is a dev / engineering operating system: code review, deploy, debug, TDD, planning, cadence (daily/weekly/monthly/quarterly), governance (charter check, ADR draft, bus-factor), plus orchestrators that drive a full dev loop. They are **English-primary with a Thai gloss** — the bilingual character is intentional. Skills cite *your* SOPs, *your* charter, and *your* tracker generically (`SOP-NN`, `docs/CHARTER.template.md`, `{{TRACKER}}`); nothing org-specific is hardcoded. The two self-upgrade skills — **`curate`** and **`review-proposals`** — are the engine of the approval gate.

### 3. Agents — bounded sub-roles

Agents are spawned by skills for a narrow job with a narrow tool set:

- **`curator`** — read-only analyst (`tools: Read, Grep, Glob` only). Reads captures, daily notes, memory, and the skill set, then returns **two buckets** (A: memory facts / B: behavior proposals). It physically cannot write, so it cannot blur the two rails.
- **`shipit-loop`** — drives the make→test→fix loop for the `shipit` / `test` orchestrators.
- **`tracker-card`** — turns work into tracker tickets via your tracker's tools.
- **`strategic-reviewer`** — outsider review of plans/PRs/changes.

Orchestrators stop at safe gates: they may merge to your **integration branch** but open a **PR only** for `main`/`staging`/`prod`, leaving the production merge to a human.

### 4. Hooks — what the harness runs (not Claude)

Hooks are scripts the Claude Code harness executes around a session. CCOS uses three, all **fail-open** (any error exits 0 so a session is never broken):

- **`session-start.sh`** (SessionStart) — injects continuity: the latest handoff capture, today's daily note, and any pending proposals, as `additionalContext`. Skips on `compact` (context already present).
- **`capture.sh`** (Stop) — writes one digest note per session (asks, tools, files touched, last reply) into `{{VAULT}}/inbox/fleeting/`. It **redacts** common secret/credential shapes before writing and skips trivial turns (no-spam gate).
- **`curate-cron.sh`** (scheduler, optional) — the unattended weekly curate; see the approval gate above.

All three agree on the `${ASSISTANT_TAG}` capture-note glob (`*-${ASSISTANT_TAG}-*.md`) so write → find → read line up.

### 5. Memory — durable, siloed, PII-aware

Durable facts live under `~/.claude/projects/<project>/memory/`, with a `MEMORY.md` index that auto-loads. The **canonical project silo is the source of truth** for a project's facts; the home silo may hold a mirror but can go stale. Memory is the **PII choke point**: the optional config backup never stages `projects/`, and pruning prefers **archive over delete** (`memory/.archive/`). Facts may be written directly by the assistant (interactive) — but anything *behavioral* is forced onto the proposal rail.

---

## How a session flows

1. **Start** — `session-start.sh` injects the previous handoff + today's daily + pending proposals, so the session resumes with continuity.
2. **Work** — the user invokes skills (`/deploy`, the built-in `/code-review`, cadence skills, …); skills may spawn bounded agents; everything respects `CLAUDE.md` standing rules and your charter.
3. **End** — `capture.sh` writes one redacted digest of the session to the fleeting inbox.
4. **Distill** — `/curate` (interactive) or `curate-cron.sh` (weekly, sandboxed) reads recent captures and proposes: facts → memory, behavior → proposals.
5. **Gate** — `/review-proposals` walks the pending proposals with you one at a time and applies only what you approve, moving each file to `applied/`. This is the **only** path that mutates the assistant's own config.

---

## Safety boundaries at a glance

- **Approval gate** — behavior changes are proposal-only; `/review-proposals` is the single apply point, interactive-only, one item per decision, every apply traceable to an approval.
- **Sandbox** — the unattended curate can write *only* the proposals dir; all of `~/.claude/**` is denied.
- **Read-only curator** — the analysis agent has no write tools at all.
- **Fail-open hooks** — capture/session-start never break a session; they exit 0 on any error.
- **Secret redaction + secret guard** — `capture.sh` scrubs credential shapes before writing; the pre-commit hook blocks secrets and sensitive filenames from entering a config repo.
- **PII choke point** — durable memory is never auto-pushed; archive over delete.
- **Branch gates** — orchestrators merge integration branches only; production merges need a human.

> **สรุปความปลอดภัย (TH):** หัวใจคือ "แก้ตัวเองต้องผ่าน /review-proposals เสมอ" — อย่างอื่น (sandbox, curator อ่านอย่างเดียว, hook fail-open, redaction, secret guard, PII choke) คือชั้นป้องกันรอบ ๆ ประตูบานนั้น
