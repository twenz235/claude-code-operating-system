# Multi-agent team coordination (COORD) — usage guide

> A team of Claude Code sessions that work the same project **asynchronously**, coordinating through **files on disk** instead of a live connection. Each session plays one role, reads a shared board, and leaves messages for the others.
> _ทีมของ session Claude Code หลายตัวที่ทำงานโปรเจกต์เดียวกันแบบ async ผ่านไฟล์บนดิสก์ ไม่ใช่การต่อสายคุยกันสด ๆ — แต่ละ session รับบทบาทเดียว อ่าน board ร่วม แล้วฝากข้อความถึงกัน_

This guide assumes you've filled the placeholders (see [`PLACEHOLDERS.md`](PLACEHOLDERS.md)) and copied the `/coord-*` commands into your `.claude/commands/`. All paths here are repo-relative (`./coord/...`) — substitute `{{REPO_ROOT}}` for the absolute root if you keep the board outside the repo.

---

## Overview / ภาพรวม

The whole system exists to work around **one hard constraint**:

> **Claude Code sessions cannot signal each other.** A session runs, does work, and stops. It cannot ping another session, cannot block waiting for a reply on a live channel. There is no message bus, no shared memory between live processes.
> _session ส่งสัญญาณหากันโดยตรงไม่ได้ — รันแล้วหยุด ไม่มี bus ไม่มี shared memory ระหว่าง process_

So coordination is **async and file-based**. Each session:

1. reads the shared board and its own memory at startup,
2. does a unit of work,
3. writes the result + any message-to-another-role onto the board,
4. stops.

The missing piece — *getting the next session to actually run* — is filled two ways:

> **1) Self-wake (the default for a live session).** Each role launches a tiny background watcher at boot — **`coord/board-wake.sh <role>`** — that blocks until the board changes in a way that is **meaningful** (it ignores pure checkbox flips) **and relevant to that role** (an entry addressed to it / `all`, or its own STATUS row), then exits. A harness that **re-invokes the agent when a backgrounded process exits** then hands the session the diff, it reacts, and relaunches the watcher. A session can't wake *another* session — but it can watch the board and **wake itself**, so a running team coordinates without a human in the loop. _แต่ละ role boot watcher ปลุกตัวเองเมื่อบอร์ดมีงานถึง role นั้น_
>
> **2) {{HOST}} (cold start + fallback).** **{{HOST}}** is the human courier: opens a session that isn't running yet, and relays the "check the board" tap on harnesses that can't re-invoke a backgrounded process. {{HOST}} is **not** a role and does **not** do engineering work. With self-wake working, {{HOST}}'s job shrinks to *starting* sessions and being the fallback. _{{HOST}} = เปิด session ที่ยังไม่รัน + fallback ถ้า harness ปลุกเองไม่ได้_

This is the mental model for everything below: **sessions talk by writing; the watcher (or {{HOST}}) makes the reader show up.** The watcher relies on a `run_in_background` that re-invokes the session on process exit — if your harness lacks that, simply skip the watcher and let {{HOST}} carry every tap; everything else works unchanged.

---

## Prerequisites / สิ่งที่ต้องมีก่อน

1. **Fill the placeholders.** This system adds its own tokens on top of the base set — `{{HOST}}`, `{{INTEGRATION_BRANCH}}`, `{{PROTECTED_BRANCHES}}`, `{{DEV_URL}}`, `{{STAGING_URL}}`, `{{HEALTH_ENDPOINT}}`, `{{TIMEZONE}}`, `{{REPO_ROOT}}`, `{{BACKEND_REPO}}`, `{{FRONTEND_REPO}}`, `{{DOCS_REPO}}`, `{{QA_DIR}}`, `{{TEST_ACCOUNTS}}`, `{{STAKEHOLDER}}`. All are defined in [`PLACEHOLDERS.md`](PLACEHOLDERS.md). _เติม placeholder ให้ครบก่อน_

2. **Install the commands + the watcher.** Copy the team-coordination commands into your commands dir so they're invokable as slash commands, and keep `coord/board-wake.sh` executable (`chmod +x`):
   - `/coord` — the **engine** (shared protocol all roles read; not a role itself).
   - `/coord-manager` `/coord-design` `/coord-worker` `/coord-qa` `/coord-security` — the **role bootstraps**.
   - `coord/board-wake.sh` — the **per-role self-wake watcher** each role launches in the background at boot (see Overview). Reads `./coord/BOARD.md` by default; set `COORD_BOARD` to point elsewhere.

3. **Create the board + memory layout** under `./coord/`:
   ```
   ./coord/
     BOARD.md            # the shared async message board (all roles read+append)
     board-wake.sh       # per-role self-wake watcher (run_in_background at boot)
     mem/
       manager.md        # one memory file per role / instance
       design.md
       worker-1.md       # worker instances: worker-<n>
       worker-2.md
       qa-1.md           # qa instances: qa-<n>
       security.md
     archive/            # rotated BOARD entries (keep BOARD.md short)
   ```
   _วาง BOARD + watcher + memory ไว้ใต้ `./coord/`_

4. **Decide your timezone once.** All board timestamps use `{{TIMEZONE}}`, declared once in the board legend so nobody has to guess. _ตั้ง timezone ครั้งเดียวใน legend_

---

## The roles / บทบาท

Five role commands. **worker** and **qa** are *single* commands parameterized by an **instance argument** (`$ARGUMENTS` / `$1` → `"1"`, `"2"`, …); the arg picks the memory file and the board lane. The other three are singletons.

| Role | Command | Duty (หน้าที่) | Owns board lanes |
|------|---------|----------------|------------------|
| **Manager** | `/coord-manager` | Triages incoming work, assigns cards, promotes finished+verified work, keeps the board tidy. The integration owner. _triage, assign, promote, ดูแล board_ | `TRIAGE`, `ASSIGN`, `DONE` (closes), `FYI` |
| **Design** | `/coord-design` | Turns a request/bug-list into a design + cards for workers. Does **not** implement. _ออกแบบ → การ์ด ไม่ลงมือเขียนเอง_ | `ASSIGN` (emits), `HANDOFF` (to worker), `QUESTION`/`ANSWER` |
| **Worker(N)** | `/coord-worker <n>` | Implements an assigned card on a branch, opens the PR, hands off to QA. One instance per `<n>`. _ลงมือทำการ์ด เปิด PR ส่งต่อ QA_ | `HANDOFF` (to qa-`<n>`), `QUESTION`, `BLOCKED` |
| **QA(N)** | `/coord-qa <n>` | Verifies a worker's PR against acceptance criteria; SHIP / SHIP-WITH-NOTES / BLOCK. One instance per `<n>`. _ตรวจ PR เทียบ acceptance ออกผล ship/block_ | `HANDOFF` (to security or manager), `BLOCKED`, `ANSWER` |
| **Security** | `/coord-security` | Audits security-touching PRs along generic dimensions (below); gate before promotion. _ตรวจความปลอดภัย PR ที่แตะของอ่อนไหว_ | `HANDOFF` (to manager), `BLOCKED`, `FYI` |

### Git permissions per role / สิทธิ์ git ต่อ role

The git charter (full version below) is enforced **per role** — not everyone can merge.

| Role | May branch | May push | May open PR | May merge into `{{INTEGRATION_BRANCH}}` | May touch `{{PROTECTED_BRANCHES}}` |
|------|:----------:|:--------:|:-----------:|:---------------------------------------:|:----------------------------------:|
| Manager | — | — | yes | **yes** (after gates pass) | **never** (PR only, human merges) |
| Design | — | — | — | — | never |
| Worker(N) | yes | yes | yes | no (hands to QA → manager) | never |
| QA(N) | — | — | — | no (reports SHIP/BLOCK) | never |
| Security | — | — | — | no (gate only) | never |

> **Security-touching PRs:** no self-merge by anyone. They must pass `/coord-security` first, and only the manager merges into `{{INTEGRATION_BRANCH}}` afterward. _PR ที่แตะ security ห้าม self-merge — ผ่าน security ก่อน แล้ว manager ค่อย merge_

> There is **no external-dev role/session.** If your flow involves an optional external dev that {{HOST}} tracks out-of-band, mention them generically in a `FYI` entry — they have **no session and no lane**. _ไม่มี role/session ของ external dev — ถ้ามี dev นอกที่ {{HOST}} ตามอยู่ ก็แค่ใส่ FYI กลาง ๆ ไม่มีเลน_

---

## Bootstrapping a session / สตาร์ท session

To bring a role online, {{HOST}} runs its command (with an instance arg for worker/qa):

```
/coord-manager
/coord-design
/coord-worker 1
/coord-qa 1
/coord-security
```

Every role command does the **same boot sequence** at startup, so a freshly-opened session resumes warm:

> **0) launch the self-wake watcher (background) → 1) own memory → 2) BOARD → 3) `/coord` (the engine).**
> _ลำดับ boot: ปลุก watcher (background) → memory ตัวเอง → BOARD → /coord_

Step 0 — `bash ./coord/board-wake.sh <role>` with `run_in_background: true` — is what lets the session wake itself later; steps 1–3 are the warm read. On a harness without background re-invoke, skip step 0 and rely on {{HOST}} to relay.

- **own memory** (`./coord/mem/<role>.md`, or `worker-<n>.md` / `qa-<n>.md`) → "where was I, what did I decide, what's in flight." _ฉันค้างอะไรไว้_
- **BOARD** (`./coord/BOARD.md`) → "what's addressed to me, what changed." _มีอะไรถึงฉัน_
- **`/coord`** → the protocol itself: legend, entry format, the tick/reply/handoff state machine. It is the **engine, not a role** — every role reads it, nobody "is" it. _โปรโตคอลกลาง ทุก role อ่าน ไม่มีใครเป็นมัน_

After reading, the session acts, writes its result + relay note to the board, updates its own memory save-point, and stops.

---

## The BOARD protocol / โปรโตคอล BOARD

`./coord/BOARD.md` is the single shared channel. Everyone **reads** all of it and **appends** to it; nobody rewrites someone else's entry. The `/coord` engine defines the format; this is the human-readable version.

### Legend (top of the board) / หัวบอร์ด

The board opens with a fixed legend so any session can parse it cold:

```
LEGEND
  timezone : {{TIMEZONE}}        # all timestamps below are in this zone
  roles    : manager · design · worker-<n> · qa-<n> · security
  wake     : each running role self-wakes via coord/board-wake.sh on lane-relevant changes
  relay    : {{HOST}} opens sessions for cold starts / relays "relay to <role>" as fallback
  STATUS   : current owner/state per active card (the at-a-glance table)
  LOG      : the append-only message stream (newest at bottom)
```

The board has two parts:

- **STATUS** — a small table, the at-a-glance "who owns what right now" view. Updated in place as cards move. _ตารางสั้น ใครถืออะไรอยู่_
- **LOG** — the append-only stream of entries. Never edited after the fact; you append a reply or a tick instead. _สตรีมต่อท้าย ไม่แก้ย้อนหลัง_

### Entry-head format / รูปแบบหัว entry

Every LOG entry starts with a one-line head, then a body:

```
[<HH:MM>] <from> → to=<role> TYPE=<TYPE> ref=<CARD-ID> [pr=<PR#> sha=<SHA>]
  <body: what happened / what's needed>
```

- `<HH:MM>` is in `{{TIMEZONE}}`.
- `to=<role>` is the addressee lane (`to=qa-1`, `to=manager`, …). For "anyone on that role," drop the instance (`to=qa`).
- `ref=<CARD-ID>` ties it to a tracker card; `pr`/`sha` are format-example placeholders — fill with your real `<PR#>` / `<SHA>`.

### TYPE vocabulary / ประเภท entry

Keep entries typed so the state machine is unambiguous:

| TYPE | Meaning |
|------|---------|
| `TRIAGE` | New work landed; needs sorting/priority. _งานใหม่เข้า รอจัด_ |
| `ASSIGN` | A card handed to a specific worker. _มอบการ์ดให้ worker_ |
| `HANDOFF` | Work moves to the next stage (worker→qa→security→manager). _ส่งต่อขั้นถัดไป_ |
| `QUESTION` | A blocker that needs another role to answer. _ถาม รอคำตอบ_ |
| `ANSWER` | A reply to a `QUESTION`. _ตอบ_ |
| `DONE` | Stage complete from the sender's side. _ฝั่งผู้ส่งเสร็จแล้ว_ |
| `BLOCKED` | Cannot proceed; states the blocker. _ติด ไปต่อไม่ได้_ |
| `FYI` | No action required; context only. _แค่แจ้ง ไม่ต้องทำอะไร_ |

Card **types** (for `ref` cards) stay generic: **Feature / Bug / Improvement**. Board **types** are the TYPE column above. _ชนิดการ์ด = Feature/Bug/Improvement ; ชนิด entry = ตาราง TYPE_

### The tick / reply / handoff state machine / กลไกสถานะ

Three moves keep the board moving without anyone rewriting history:

1. **tick** — acknowledge you've picked up an entry addressed to you: append a short `to=<sender> TYPE=ANSWER` (or update STATUS to show you now own it). Signals "seen, mine now." _เห็นแล้ว รับไป_
2. **reply** — answer a `QUESTION` with an `ANSWER` referencing the same `ref`. The asker's next session reads it and unblocks. _ตอบคำถาม_
3. **handoff** — finish your stage and pass ownership: append `TYPE=HANDOFF to=<next-role>` + the artifact (`pr`/`sha`), update STATUS to the next owner, and add a **"relay to `<next-role>`"** note so {{HOST}} knows who to wake. _เสร็จขั้นตัวเอง → ส่งต่อ + บอกให้ relay_

> **State lives in two places, consistently:** the LOG entry (the durable message) **and** the STATUS table (the current-owner snapshot). Move both together. _state อยู่ 2 ที่ ต้องขยับพร้อมกัน: LOG + STATUS_

### Archiving / การ archive

Keep `BOARD.md` short so cold reads stay cheap. When the LOG grows long or a card reaches a final `DONE`/promote, **move its closed entries** into `./coord/archive/<period>.md` and leave only active cards in `BOARD.md`. STATUS holds only live cards. _ย้าย entry ที่ปิดแล้วไป archive ให้ BOARD สั้น เหลือแต่ที่ยัง active_

---

## Per-role memory / memory ของแต่ละ role

Each role keeps its own memory file (`./coord/mem/<role>.md`, or `worker-<n>.md` / `qa-<n>.md`). It is the session's continuity across restarts — because the session itself forgets everything on stop.

Structure each memory file with four sections:

| Section | Holds |
|---------|-------|
| **NOW** | The one thing I'm on right now — the resume point. _กำลังทำอะไรอยู่ จุด resume_ |
| **IN-FLIGHT** | Cards/PRs I've touched that aren't closed yet. _ของที่ค้างยังไม่ปิด_ |
| **DECISIONS** | Choices I made + why (so I don't relitigate them). _ตัดสินใจอะไรไปแล้ว + เหตุผล_ |
| **GOTCHAS** | Traps I hit, so future-me doesn't repeat them. _หลุมที่เคยตก_ |

Discipline / กติกา:

- **Save-point discipline** — before stopping, write **NOW** so the next start knows exactly where to resume. The board says what's *addressed to you*; memory says what *you were doing*. _ก่อนหยุด เขียน NOW ไว้เสมอ_
- **Write only your own** memory file. Never edit another role's memory. _เขียนแค่ของตัวเอง_
- **Prune** — keep it lean. Move settled DECISIONS to a footnote, drop stale IN-FLIGHT once closed. A bloated memory file slows every cold start. _ตัดให้สั้น_

> Memory files describe **operational state**, not the project's source of truth. Decisions that outlive the coordination go to your tracker/docs, not here. _memory = สถานะการทำงาน ไม่ใช่ source of truth ของโปรเจกต์_

---

## The relay model in practice / โมเดล relay จริง

Because no session can signal another, **every handoff has two parts**:

1. the **board entry** (`TYPE=HANDOFF to=<next-role>` + artifact), and
2. a plain **"relay to `<next-role>`"** line naming who should pick it up next.

How the next session shows up depends on whether it's running:

- **It's already running** → its own `board-wake.sh` watcher sees the new entry (it's addressed to that role), exits, and the harness re-invokes it with the diff. **No human needed.** The "relay to" line is then just a human-readable breadcrumb. _session ที่รันอยู่ → watcher ปลุกเอง_
- **It's not running yet (cold start), or the harness can't re-invoke** → {{HOST}} reads the "relay to" line and opens (or re-prompts) that role's session, whose boot sequence picks the handoff up. _ยังไม่เปิด / harness ปลุกไม่ได้ → {{HOST}} เปิดให้_

That's the whole loop — self-driving while the team is live, with {{HOST}} covering cold starts and as a fallback.

### Worked example — a feature end to end / ตัวอย่างฟีเจอร์ครบวง

A Feature card flows **design → worker → qa → security → manager-promote**:

```
[09:10] manager → to=design   TYPE=ASSIGN   ref=<CARD-ID>
   New Feature card triaged. Design it and cut worker cards.
   relay to design.
```
{{HOST}} opens design.
```
[09:40] design → to=worker-1  TYPE=HANDOFF  ref=<CARD-ID>
   Design done (link in card). One worker card. Acceptance criteria in card.
   relay to worker-1.
```
{{HOST}} opens worker-1.
```
[11:20] worker-1 → to=qa-1    TYPE=HANDOFF  ref=<CARD-ID> pr=<PR#> sha=<SHA>
   Implemented + tests green locally. PR open against {{INTEGRATION_BRANCH}}.
   relay to qa-1.
```
{{HOST}} opens qa-1.
```
[13:05] qa-1 → to=security    TYPE=HANDOFF  ref=<CARD-ID> pr=<PR#>
   SHIP-WITH-NOTES — meets acceptance; touches auth, so routing to security.
   relay to security.
```
{{HOST}} opens security.
```
[14:30] security → to=manager TYPE=HANDOFF  ref=<CARD-ID> pr=<PR#>
   No findings on the audited dimensions. Cleared to promote.
   relay to manager.
```
{{HOST}} opens manager.
```
[14:45] manager → to=ALL      TYPE=DONE     ref=<CARD-ID> sha=<SHA>
   Merged into {{INTEGRATION_BRANCH}} (merge-commit). CI green. Card closed.
```

If a stage **blocks** instead, it appends `TYPE=BLOCKED` / `TYPE=QUESTION` with a relay back to whoever can unblock, and the chain pauses there until answered. _ถ้าติด ก็ BLOCKED/QUESTION + relay กลับไปคนที่ปลดล็อกได้_

---

## Scaling instances / สเกลหลาย instance

`worker` and `qa` scale by running **more than one instance** of the same command, each with a different arg:

```
/coord-worker 1      /coord-qa 1
/coord-worker 2      /coord-qa 2
```

- **The arg selects two things:** the memory file (`worker-<n>.md`) **and** the board lane. Worker 1 reads/writes `worker-1`; worker 2 reads/writes `worker-2`. _arg เลือก memory + เลน_
- **Lane addressing** — address a specific instance with `to=qa-1`, or "whichever qa is free" with `to=qa` (no instance). Be specific when a card is already mid-flight with one instance; be generic when handing fresh work to the pool. _ระบุ to=qa-1 เจาะ instance / to=qa เผื่อใครว่าง_
- **Worktree isolation** — give each worker instance its **own git worktree** so two instances never fight over the working tree. Worker 1 and worker 2 build on separate branches in separate checkouts. _แต่ละ worker ใช้ worktree แยก กันชนกัน_
- **Dedupe rule** — before picking up a card, check STATUS: if another instance already owns that `ref`, **don't double-grab it.** One card, one active instance. _เช็ค STATUS ก่อนหยิบ ถ้ามี instance อื่นถืออยู่แล้ว อย่าหยิบซ้ำ_

> Document which instances are "live" in your run by listing them in the board legend or a `FYI` entry, so {{HOST}} knows there are e.g. two workers and one QA to relay between. _จดว่ารัน instance ไหนอยู่บ้าง เพื่อให้ {{HOST}} รู้ว่าต้อง relay ใครบ้าง_

---

## Git charter / ธรรมนูญ git

The same delivery discipline as the rest of this operating system, scoped to the team:

- **Merge only into `{{INTEGRATION_BRANCH}}`.** Feature/fix work integrates there first. _merge เข้า {{INTEGRATION_BRANCH}} เท่านั้น_
- **Merge-commit, never squash/rebase-merge.** Use `git merge --no-ff` / `gh pr merge --merge`. Squashing drops ancestry → broken graph + phantom conflicts next round. _ใช้ merge-commit เสมอ ห้าม squash_
- **Never touch `{{PROTECTED_BRANCHES}}` directly.** For those, open a **PR only** and let a human (via {{HOST}}) merge. No session merges a protected branch. _ห้ามแตะ {{PROTECTED_BRANCHES}} ตรง ๆ — เปิด PR ให้คนกด_
- **Security-touching PRs: no self-merge.** Must clear `/coord-security` first, then the manager merges. _PR ที่แตะ security ห้าม self-merge_
- **AI attribution — optional documented preference.** Some teams omit AI co-author trailers from commits/PRs; others keep them. Decide once and record it; left unstated, the harness default applies. _AI attribution เป็น preference ที่จดไว้ ไม่ใช่กฎตายตัว_

---

## Quality gates / ด่านคุณภาพ

Work is **promoted** (merged into `{{INTEGRATION_BRANCH}}`) only after it's **verified**, not merely "done."

- **Promote verification** — the manager checks the QA verdict + CI before merging; "worker says done" is not enough. _manager เช็คผล QA + CI ก่อน merge_
- **QA verdict vocabulary** — every QA handoff carries one of:
  | Verdict | Meaning |
  |---------|---------|
  | **SHIP** | Meets acceptance criteria, no caveats. _ผ่าน ไม่มีเงื่อนไข_ |
  | **SHIP-WITH-NOTES** | Acceptable to merge, but with documented follow-ups/caveats. _ผ่านแบบมีหมายเหตุ_ |
  | **BLOCK** | Fails acceptance; states why + what to fix. _ไม่ผ่าน บอกเหตุ_ |
- **QA ticks the Acceptance Criteria honestly after verifying.** The card is the single source of truth for progress, so its AC must mirror reality: PASS = `[x]`; FAIL / pending = `[ ]` + reason; device- or host-gated (QA can't run it) = `[ ]` + who must. **Never tick an untested criterion.** A bare "verified" with stale checkboxes hides which AC actually passed. _เทสเสร็จติ๊ก AC ตามจริง ห้ามติ๊กข้อที่ยังไม่เทส_
- **CI-green** — a card is not promotable while CI is red. The manager waits for green (or runs the gate) before merging. _CI ต้องเขียวก่อน promote_

---

## Working discipline / กติกาการทำงาน

Cross-role conventions that keep the board trustworthy:

- **No-guessing (binding).** Never guess on a load-bearing fact — permission scope, API behavior, a config/env value, file/branch state, how the existing code works. **Verify until certain** before you assert, assign, change code, tick a card, or report; if you genuinely can't find out, say **"don't know"** and keep digging rather than masking it. A board entry stated as fact is trusted by every other role. _ห้ามเดาเรื่อง load-bearing — verify จนแน่ใจ ไม่รู้ให้บอกว่าไม่รู้_
- **Move the card to match reality.** Start → *in progress*, out for verify → *in review*, verified → *done*. Tracker state tracks the work, not the other way round. _ขยับสถานะการ์ดตามงานจริง_
- **Code-to-test, not test-to-code.** Acceptance criteria / specs are the target — make the code satisfy them; never bend a test or an AC to match what the code happens to do. _แก้โค้ดให้ผ่าน spec/AC ไม่บิด test_
- **Consolidate by default.** One card with sub-criteria beats many tiny cards; split only across genuinely different repos / lanes / domains. _รวบ 1 การ์ด · แยกเฉพาะจำเป็น_
- **A long batch → one branch, one PR.** Group related work to cut CI churn; separate commits per sub-item. _งานชุดยาว = 1 branch + 1 PR_
- **Stay in your lane.** Testers test and hand bugs back; designers design; workers implement. Route work to the lane that owns it. _ทำตามบทบาท ไม่ข้ามเลน_
- **Preview a UI change before you card it.** For anything visual, attach a before→after preview (screenshot / mock) to the card when you open it, so reviewers see the delta up front. _การ์ด UI = โชว์ before→after ก่อนเปิด_

---

## Secrets & safety / ความลับ & ความปลอดภัย

- **Never commit test accounts, UUIDs, or keys.** Use a local-only `{{TEST_ACCOUNTS}}` placeholder — **fill it locally, NEVER commit it.** Real credentials, test logins, tokens, and IDs stay out of the board, out of memory, and out of git. _ห้าม commit test account/UUID/key — เติม local อย่าขึ้น git_
- **`.gitignore` the secrets.** Keep the file holding `{{TEST_ACCOUNTS}}` (and anything under `./coord/` that captures live values) gitignored. The board and memory are operational notes, not a credential store. _ใส่ .gitignore กันไฟล์ secret_
- **Staging shell needs {{HOST}} approval.** No session runs commands against staging/production on its own; running a shell against `{{STAGING_URL}}` requires explicit {{HOST}} approval first. Never pull production data onto a personal machine. _รัน shell ใส่ staging ต้องให้ {{HOST}} อนุมัติก่อน_

---

## Troubleshooting / แก้ปัญหา

- **Stale-SHA check** — a session may be looking at an old deploy. Verify what's actually live by hitting `{{HEALTH_ENDPOINT}}` on `{{DEV_URL}}` / `{{STAGING_URL}}` and comparing the reported `<SHA>` against the PR's. If they differ, the env hasn't picked up the merge yet — don't conclude from a stale read. _เช็ค SHA จริงผ่าน {{HEALTH_ENDPOINT}} ก่อนสรุป_
- **Board write races** — two sessions appending at once can clobber. Mitigate by **append-only** discipline (never rewrite an existing entry), keeping entries small, and — if a race is suspected — re-reading the tail before appending. {{HOST}} serializes relays, so two roles rarely write at the exact same instant. _กัน race ด้วยการ append อย่างเดียว + อ่าน tail ก่อนเขียน_
- **Resume from NOW** — if a session looks lost after a restart, the fix is almost always: re-read its memory **NOW** line, then the board. NOW is the save-point; trust it over re-deriving state. _หลง → อ่าน NOW ก่อน_

---

> **Bilingual note.** Headings and the first statement of every instruction are English; the Thai gloss rides alongside where it adds nuance. Delete the gloss if your team is English-only — never delete a load-bearing English line. _ลบ gloss ไทยได้ถ้าทีมใช้อังกฤษล้วน แต่ห้ามลบบรรทัดอังกฤษที่สำคัญ_
