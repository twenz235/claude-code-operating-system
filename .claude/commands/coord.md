---
description: The coord engine — read the coordination board, handle entries addressed to this session's role/instance, act, tick, reply, update STATUS, relay via the host.
---

# /coord — the coordination engine

This is the **shared loop every role runs.** The role commands (`/coord-manager`,
`/coord-design`, `/coord-worker`, `/coord-qa`, `/coord-security`) each set up *who you
are*, then defer the actual board mechanics to this file. Read this once; every role
behaves the same way here.

> นี่คือ "ลูปกลาง" ที่ทุก role รันเหมือนกัน — role command บอกแค่ว่าคุณเป็นใคร
> ส่วนกลไกอ่าน/เขียนบอร์ดอยู่ในไฟล์นี้ทั้งหมด

The board is a **file-as-message-bus**: every session reads one shared file, finds the
entries addressed to it, acts, and writes its reply + status back. **No session talks to
another directly** — coordination is always through the board. What carries the "go look
at the board" tap is one of two things: a **self-wake watcher** each live session runs for
itself (below), or **{{HOST}}** (the human courier) for cold starts and as a fallback.
_session คุยกันผ่านบอร์ดอย่างเดียว — ปลุกด้วย self-wake watcher (ของแต่ละ session) หรือ {{HOST}} เดินสาร (cold start / fallback)._

---

## ⚠ No-guessing (binding — overrides every step below)

Never guess on a **load-bearing** fact — token / permission scope, API behavior, a
config/env value, file/branch state, or how the existing code actually works. **Verify
until certain** (read / test / grep / call it) before you assert, advise, open work, tick
a card, or report on the board. If you genuinely can't find out, write **"don't know"**
and keep digging — never paper over the gap with a guess. Every "probably / I assume" on a
load-bearing point becomes a verify step first. _ห้ามเดาเรื่อง load-bearing — verify จนแน่ใจก่อน · ไม่รู้ให้บอกว่าไม่รู้ ห้ามมั่ว._

---

## ⚡ Self-wake watcher (boot · background) — sessions wake themselves
<!-- A boot preamble that runs before the numbered protocol below (which starts at §0). -->


Removes the old "sessions can't wake each other" limit **for already-running sessions.** At
startup, launch your watcher in the **background**:

```
bash ./coord/board-wake.sh <me>        # run_in_background: true   (qa-2 → board-wake.sh qa-2)
```

It blocks until `./coord/BOARD.md` changes in a way that is **both meaningful and relevant
to you**, then exits and prints the diff:

- **meaningful** — it ignores pure `[ ]`↔`[x]` checkbox flips (a bare tick is an ack, not
  new work). _ข้าม checkbox flip._
- **relevant to you** — an entry `→ <me>` / `to=<me>` / `to=all`, or **your own STATUS row
  changed**. **`manager` wakes on *every* meaningful change** (it tracks the whole team);
  every other lane wakes only on its own work (family match: `qa` covers `qa-1`/`qa-2`).
  _เกี่ยวกับ role เท่านั้น · manager = ทุก meaningful change._

On wake: a harness that **re-invokes the agent when a backgrounded process exits** hands
you the diff → you react → **relaunch the watcher every time** (loop). _ถูกปลุก → อ่าน diff → ทำงาน → relaunch ทุกครั้ง._

> **Dependency.** This relies on a `run_in_background` that re-invokes the session on
> process exit. If your harness can't do that, drop step 0 and let **{{HOST}}** relay the
> tap instead (everything else in this file works unchanged). BOARD path defaults to
> `./coord/BOARD.md`; override with `COORD_BOARD` if the board lives elsewhere.
> _harness ปลุกไม่ได้ → ข้าม step 0 ใช้ {{HOST}} เดินสารแทน._

---

## 0. Know who you are

Your **role** and (for parameterized roles) your **instance** come from the role command
you were started with:

| Role command | Role identity | Instance arg |
|---|---|---|
| `/coord-manager` | `manager` | — (single instance) |
| `/coord-design` | `design` | — (single instance) |
| `/coord-security` | `security` | — (single instance) |
| `/coord-worker <n>` | `worker-<n>` | `$ARGUMENTS` / `$1` → `1`, `2`, … |
| `/coord-qa <n>` | `qa-<n>` | `$ARGUMENTS` / `$1` → `1`, `2`, … |

- **worker** and **qa** are *one command each*, parameterized by an **instance arg**. The
  arg (`$ARGUMENTS`, i.e. `$1`) selects two things: your **memory file**
  (`./coord/mem/worker-<n>.md`) and your **board lane** (`worker-<n>` in STATUS + as a
  `to=` target). `/coord-worker 2` → you are `worker-2`. _arg เลือก mem file + lane._
- If you genuinely don't know your role/instance, **ask {{HOST}} one line first — don't
  guess.** _ไม่รู้บทบาท → ถาม 1 บรรทัด อย่าเดา._

> Throughout this file, **`<me>`** = your full lane id (e.g. `manager`, `worker-2`,
> `qa-1`, `security`). **`<n>`** = your instance number for parameterized roles.

---

## 1. Load your own memory first (per-role durable working memory)

Each role keeps a **durable working-memory file** so a session that dies mid-task can be
restarted and pick up exactly where it left off. _memory ถาวรของแต่ละ role — session ตายแล้วเปิดใหม่มาต่อได้._

1. **Before doing anything:** read your own memory file `./coord/mem/<me>.md`
   (sections like `NOW` / `IN-FLIGHT` / `DECISIONS` / `GOTCHAS`). Resume straight from
   `NOW`. _อ่าน mem ตัวเองก่อน → ทำต่อจาก NOW._
2. **While working:** update `./coord/mem/<me>.md` at **every meaningful step**
   (start/finish a task · a decision · hitting a gotcha · before your context fills up).
   Treat it as a **save-point**, not a shutdown chore. _อัปเดต mem ทุก step สำคัญ — เป็น save-point._
3. **Write only your own role's file** (`<me>.md`) — never another role's. This is what
   keeps concurrent sessions race-free. _เขียนเฉพาะไฟล์ role ตัวเอง กัน race._
4. Prune entries that have been `DONE` for more than a few days into
   `./coord/mem/_archive/`. _ย้าย DONE เก่าเข้า _archive/._

> The memory files live under `./coord/mem/` (repo-relative). One file per lane —
> `manager.md`, `design.md`, `security.md`, `worker-<n>.md`, `qa-<n>.md`.

---

## 2. Read the board

Read **`./coord/BOARD.md`** in full — the **How-to-use** header (read once), the **STATUS**
block (current state of every lane), and the recent **LOG** entries. _อ่านบอร์ดทั้งไฟล์._

The board has three sections:

- **STATUS** — one row per lane, the current one-line state of each session.
- **LOG** — the thread of entries (newest at the bottom). This is where work is addressed,
  accepted, answered, and handed off.
- (header) **How to use / legend** — entry-head format, TYPE vocab, who-opens-which-card,
  and the timezone declaration ({{TIMEZONE}}, declared once there).

---

## 3. The loop — handle what's addressed to you

1. **Find your work.** Scan LOG for entry heads where `to=` is **`<me>`**, your **role
   family** (e.g. `qa` matches `qa-1`/`qa-2`), or **`all`** — *and* the head is still
   `[ ]` (unticked). Those are the open items waiting on you. _หา entry to=<me>/role/all ที่ยัง [ ]._

2. **If you have work** → do it per your role's responsibilities, then on the board:
   - **Tick the head** `[ ]` → `[x]` to claim/close it.
   - **Append a threaded reply** directly under that entry (do *not* start a new
     top-level entry for a reply):
     ```
     ↳ [<me>] <MM-DD HH:MM> · <TYPE> · <text>
     ```
     `<TYPE>` ∈ `TRIAGE` · `ASSIGN` · `HANDOFF` · `QUESTION` · `ANSWER` · `DONE` ·
     `BLOCKED` · `FYI`.
   - **Overwrite your own STATUS row** to reflect your current state, always with a
     timestamp. _เขียนทับ STATUS ของตัวเอง + timestamp._

3. **If nothing is addressed to you** → update your STATUS row to `idle` / available and
   note briefly that there's no pending work. _ไม่มีงานค้าง → STATUS ว่าง + รายงานสั้น._

4. **To send new work to another lane** → append a **fresh entry** at the bottom of LOG
   (read the latest entry first, to avoid a write race). If that lane's session is running,
   its `board-wake.sh` watcher wakes it on the entry; if it isn't open yet (or the harness
   can't re-invoke), tell {{HOST}}: *"start/relay `/coord` to `<lane>`."* _ส่งงาน = append entry ใหม่ · session ที่รันอยู่ปลุกเอง · ไม่งั้นบอก {{HOST}} เปิด/relay._

---

## 4. Entry & reply format (the board contract)

**Entry head** (a new top-level item):
```
### [ ] <MM-DD HH:MM> · <from> → <to> · <TYPE> · <ref>
```
- `[ ]` open · `[x]` accepted-or-done
- `<from>` / `<to>` = a lane (`manager` / `design` / `worker-<n>` / `qa-<n>` / `security`)
  or `all`
- `<ref>` = a tracker card id `<CARD-ID>` (format example: `<CARD-ID>`, e.g.
  `FEAT-123`-shaped) **or** a short slug

**Threaded reply** (nested under the entry it answers):
```
↳ [<me>] <MM-DD HH:MM> · <TYPE> · <text>
```

**Card TYPES** (in {{TRACKER}}) and **who opens which**:
- **design → Feature** (Feature cards + ADRs only)
- **qa → Bug / Improvement** (default: roll findings into *one* card, don't shatter)
- **security → Bug** (when an audit confirms a vuln)
- **manager → opens no cards** — prioritizes / assigns / promotes only

**Handoff rule:** when one lane finishes and another must continue (worker → qa to verify,
security → worker to fix), write a `HANDOFF` entry naming the target lane + the ref + what
to check, then tick your own work `[x]`. _เสร็จแล้วต้องส่งต่อ → เขียน HANDOFF._

---

## 5. Board-write discipline (don't get this wrong)

- **Re-read the latest entry right before you write** — another session may have written
  since you loaded the file. This is the primary race guard. _อ่าน entry ล่าสุดก่อนเขียนเสมอ กัน race._
- **All timestamps = {{TIMEZONE}}**, declared once in the board legend — don't repeat the
  zone per entry. _เวลา = {{TIMEZONE}} เสมอ._
- **Archive closed threads:** when an entry is fully closed (`[x]` + a terminal
  `DONE`/`BLOCKED` reply) **and** LOG has grown long, move the whole block into
  `./coord/archive/<YYYY-MM>.md`. Keep LOG lean. _ปิดครบแล้วบอร์ดยาว → ย้ายเข้า archive._

---

## 6. Working discipline (shared by every role)

Conventions that keep the board honest and the work traceable:

- **Move the card to match reality.** When you start a card move it to *in progress*, when
  it's out for verification *in review*, when it's verified *done* — keep the tracker state
  in step with what's actually happening, not lagging behind. _ขยับสถานะการ์ดตามงานจริง._
- **Code-to-test, not test-to-code.** The acceptance criteria / spec are the target — make
  the code satisfy them; never bend a test (or an AC) to match what the code happens to do.
  _แก้โค้ดให้ผ่าน spec/AC ไม่บิด test ให้ตรงโค้ด._
- **Consolidate by default.** One card with sub-criteria (A/B/C/D) beats a shower of tiny
  cards; split only when items genuinely belong to different repos / lanes / domains.
  _รวบ 1 การ์ด default · แยกเฉพาะจำเป็น._
- **A long batch → one branch, one PR.** Group a run of related work into a single branch +
  PR (separate commits per sub-item) to cut CI churn — don't open a PR per micro-change.
  _งานชุดยาว = 1 branch + 1 PR._
- **Stay in your lane.** A tester tests and hands bugs back; it doesn't fix. A designer
  designs; it doesn't implement. Route the work to the lane that owns it. _ทำตามบทบาท ไม่ข้ามเลน._
- **Preview a UI change before you card it.** For anything visual, capture a before→after
  preview (screenshot / mock) and put it on the card when you open it, so reviewers see the
  delta up front instead of guessing from prose. _การ์ด UI = โชว์ before→after ก่อนเปิด._

---

## 7. Git charter (shared by every role)

These apply to *every* lane; each role command may tighten them further.

- **Merge only into {{INTEGRATION_BRANCH}}.** A feature branch → PR → may merge into
  {{INTEGRATION_BRANCH}} once CI is green. _merge ได้แค่ {{INTEGRATION_BRANCH}}._
- **Merge-commit only — no squash, no rebase-merge** (`git merge --no-ff` /
  `gh pr merge --merge`). Squash drops ancestry → broken graph + phantom conflicts.
  _ใช้ merge-commit เสมอ ห้าม squash/rebase._
- **Never touch {{PROTECTED_BRANCHES}}.** Promotion into a protected branch is **escalated
  to {{HOST}}** — open a PR only, never self-merge. _ห้ามแตะ {{PROTECTED_BRANCHES}} — escalate {{HOST}}._
- **Security-touching PRs = no self-merge.** Any PR that touches permissions / querysets /
  serializers / auth → a human (or the security lane's gate) signs off before merge.
  _PR แตะ security = no self-merge._
- **AI-attribution trailers = optional, documented preference.** Pick once for your team —
  with or without `Co-Authored-By:` / "generated with" lines — record it, and be
  consistent. _AI attribution = preference ที่จดไว้ ไม่ใช่กฎตายตัว._

---

## 8. Running multiple instances (worker / qa)

`worker` and `qa` are designed to run **several sessions in parallel**, e.g. `worker-1`
and `worker-2`, or `qa-1` and `qa-2`. Each instance:

- is started with its number: `/coord-worker 1`, `/coord-worker 2`, `/coord-qa 1`, …
- reads + writes **only its own** memory file `./coord/mem/<role>-<n>.md`,
- owns its own **STATUS row** and its own **lane** (`worker-<n>` / `qa-<n>`).

**Coordinating same-role instances (avoid double-picking):** before grabbing a `to=<role>`
(family-addressed) item, check the **STATUS rows and `↳` replies of your sibling
instances** first, so two sessions don't take the same work. A manager can target a
specific instance (`to=worker-2`) or the family (`to=qa` = whoever's free picks it up).
_to=<role> = ใครว่างหยิบ; เช็คพี่น้อง lane ก่อน อย่าหยิบซ้ำ._

**Adding more instances:** just start `/coord-worker 3` (etc.), add a matching STATUS row
to the board, and create `./coord/mem/worker-3.md`. Nothing else changes. _เพิ่ม instance = เปิด /coord-worker 3 + เพิ่ม STATUS row + mem file._

---

## Extra note from {{HOST}} (if any): $ARGUMENTS
