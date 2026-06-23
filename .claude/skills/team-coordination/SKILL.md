---
name: team-coordination
description: >-
  Entry point to COORD — an async, file-based multi-agent team for Claude Code.
  Several role sessions (manager, design, worker, qa, security) coordinate by
  reading and writing a shared on-disk BOARD message bus. Each role self-wakes off
  the board via a background watcher, with a human (the {{HOST}}) opening sessions
  for cold starts / relaying as a fallback, and each role keeping its own memory
  file. Use this to understand the system, then run /coord-<role> to take
  a seat. Glossary (TH) — จุดเริ่มของ COORD — ทีม multi-agent แบบ async
  ที่คุยกันผ่านไฟล์ BOARD บนดิสก์ แต่ละ role ปลุกตัวเองด้วย watcher มีคน ({{HOST}}) เปิด
  session/relay เป็น fallback และแต่ละ role มี memory ของตัวเอง. Trigger when you want to set up or join a
  multi-session team, understand the COORD board / roles / self-wake + human-relay model, or
  are asked to act as manager/design/worker/qa/security.
---

# Team Coordination (COORD)

COORD is an **asynchronous, file-based multi-agent team** for Claude Code. There is no live RPC and no shared
process — every role is a **separate Claude Code session**, and they coordinate by reading and writing **plain
files on disk**. Each role runs a background **self-wake watcher** (`coord/board-wake.sh`) that re-invokes its own
session when the board gets work in its lane; a **human (the {{HOST}})** opens sessions for cold starts and relays
as a fallback. That's the whole trick: durable, inspectable, and resumable, because the entire team state is just
files you can open and read.

> **Glossary (TH):** COORD คือทีม multi-agent แบบ **async ที่คุยกันผ่านไฟล์**. ไม่มี RPC สด ไม่มี process ร่วม —
> แต่ละ role คือ Claude Code คนละ session คุยกันผ่าน **ไฟล์บนดิสก์** · แต่ละ role มี **self-wake watcher** (`coord/board-wake.sh`)
> ปลุกตัวเองเมื่อบอร์ดมีงานถึงเลนตัวเอง · **คน ({{HOST}})** เปิด session ตอน cold start + relay เป็น fallback.
> ข้อดี: state ทั้งทีมเป็นไฟล์ เปิดอ่าน ตรวจสอบ และทำต่อทีหลังได้.

## The mental model / โมเดลความคิด

- **Roles, not threads.** Each role is its own session you open with a slash command:
  - **`/coord`** — the engine / shared protocol every role loads.
  - **`/coord-manager`** — plans, triages, assigns, and integrates. Owns the board's flow.
  - **`/coord-design`** — turns requests into designs and tracker cards for workers to build.
  - **`/coord-worker <n>`** — implements one lane. The `<n>` is an **instance arg** (`"1"`, `"2"`, …).
  - **`/coord-qa <n>`** — verifies a lane. Same **instance arg** pattern.
  - **`/coord-security`** — the read-only security merge-gate (backed by the `rbac-security-auditor` agent).
- **The BOARD is the message bus.** All cross-role messages are rows on a shared on-disk board, tagged by
  **lane** and **message type** — `TRIAGE / ASSIGN / HANDOFF / QUESTION / ANSWER / DONE / BLOCKED / FYI`. A role
  reads the board, acts, and writes its reply back as a new row. Nobody talks directly to another session.
- **Sessions self-wake; the {{HOST}} covers cold starts.** A session can't ping *another*, but each role launches
  a background watcher (`coord/board-wake.sh <role>`) at boot that wakes its **own** session when the board gets
  work in its lane — so a running team coordinates itself, no human tap per message. The **{{HOST}}** (a human
  courier, **not** a participant who does the roles' work) opens sessions that aren't running yet, and relays
  manually as a fallback on harnesses that can't re-invoke a backgrounded process.
- **Per-role memory.** Each role keeps a durable memory file at `./coord/mem/<role>.md` — for parameterized
  roles it's `./coord/mem/worker-<n>.md` / `./coord/mem/qa-<n>.md`. A role re-reads its own memory on wake so it
  survives a restart with full context.

> **(TH):** Role = session (เปิดด้วย slash command) · BOARD = ไฟล์กลางที่ทุก role อ่าน/เขียน (มี lane + ชนิดข้อความ) ·
> แต่ละ role ปลุกตัวเองด้วย watcher · {{HOST}} = เปิด session/relay เป็น fallback ไม่ใช่คนทำงานแทน role · แต่ละ role มี memory ที่ `./coord/mem/<role>.md`.

## Running multiple instances / รันหลาย instance

`worker` and `qa` are **one command each, parameterized by an instance arg** (`$ARGUMENTS` / `$1` → `"1"`, `"2"`,
…). The arg does two things: it **selects the memory file** (`./coord/mem/worker-<n>.md`) and it **selects the
board lane** that instance owns. So you run **parallel lanes** by opening the same command in several sessions
with different args:

```
session A:  /coord-worker 1     # owns lane worker-1, memory ./coord/mem/worker-1.md
session B:  /coord-worker 2     # owns lane worker-2, memory ./coord/mem/worker-2.md
session C:  /coord-qa 1         # verifies lane qa-1,   memory ./coord/mem/qa-1.md
```

> **(TH):** `worker` กับ `qa` เป็น **คำสั่งเดียว** ที่รับ **instance arg** (`$1` = `"1"`, `"2"`, …) — arg เลือกทั้ง
> **ไฟล์ memory** และ **lane บนบอร์ด** ของ instance นั้น. เปิดคำสั่งเดิมหลาย session ด้วย arg ต่างกัน = ได้หลาย lane ขนานกัน.

## How to start / เริ่มยังไง

1. **First time?** Do the one-time setup (create `./coord/`, the board file, the `./coord/mem/` folder, and the
   git/test conventions) → see **`coord/SETUP.md`**.
2. **Take a seat** by running the role you want: `/coord-manager`, `/coord-design`, `/coord-worker <n>`,
   `/coord-qa <n>`, or `/coord-security`. Each one loads the `/coord` engine, reads the board, reads its own
   memory, and tells you what's waiting in its lane.
3. **Mostly hands-off once live.** A running session's watcher wakes it when new rows land in its lane — you don't
   relay each message. As the {{HOST}} you only *open* sessions for cold starts (and relay manually if your harness
   can't re-invoke a backgrounded process).

For the full protocol — the board schema, the message-type semantics, the board legend (including the declared
{{TIMEZONE}}), the per-role responsibilities, and the git charter (merge only into {{INTEGRATION_BRANCH}} with a
merge commit, never touch {{PROTECTED_BRANCHES}}, security-touching PRs get no self-merge) — read
**`docs/team-coordination.md`**. For first-run scaffolding, read **`coord/SETUP.md`**.

> **(TH):** ครั้งแรกทำ setup ที่ `coord/SETUP.md` → เปิด role ที่ต้องการด้วย `/coord-<role>` (boot watcher เอง) → session ที่รันอยู่
> ปลุกตัวเองเมื่อมี row ใหม่ในเลนตัวเอง · {{HOST}} แค่เปิด session ตอน cold start. โปรโตคอลเต็ม (schema ของบอร์ด, ชนิดข้อความ, legend + {{TIMEZONE}}, หน้าที่แต่ละ role, git charter)
> อยู่ที่ **`docs/team-coordination.md`**.
