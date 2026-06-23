# claude-code-operating-system (ภาษาไทย)

> **ระบบปฏิบัติการสำหรับนักพัฒนา/วิศวกรบน [Claude Code](https://docs.anthropic.com/en/docs/claude-code)** — ชุด skill + agent + hook + ลูปอัปเกรดตัวเองแบบมี approval gate + ทีม multi-agent (COORD) ให้ Claude Code ทำงานอย่างมีวินัยแบบ senior engineer
> 🇬🇧 English: **[README.md](README.md)**

นี่คือ **template repo** — fork มาแล้ววางใน `~/.claude` (ระดับ user) หรือใน project, เติม placeholder, wire hooks แล้ว assistant ของคุณจะได้ชุดวินัยวิศวกรรมที่ใช้ซ้ำได้ (review, deploy, debug, plan, cadence) + ชั้นความต่อเนื่องที่จำข้าม session ได้ และเสนอการอัปเกรดตัวเอง **โดยไม่แก้ตัวเองเงียบ ๆ**

> เอกสารต้นฉบับเขียน **อังกฤษเป็นหลัก + ไทยกำกับ** — ไฟล์นี้คือฉบับไทยแบบย่อสำหรับเริ่มเร็ว รายละเอียดเต็มอยู่ใน `docs/` (อังกฤษ)

---

## ⚡ วิธีใช้กับ Claude Code (ง่ายสุด — ให้ Claude เซ็ตอัพให้)

ไม่ต้องรัน `sed` หรือไล่เติม placeholder เอง — **เปิด Claude Code ใน repo นี้ แล้วบอกประมาณนี้:**

```
ผมอยากใช้ operating system นี้กับ Claude Code ของผม
ช่วยอ่าน docs/SETUP.md กับ docs/PLACEHOLDERS.md แล้วเซ็ตอัพให้หน่อย:
ถามค่า placeholder ที่จำเป็นทีละข้อ (ชื่อ assistant, โปรเจกต์, tracker,
vault ฯลฯ) แล้วแทนค่าให้ทั้ง repo, สร้าง vault layout, และ wire hooks
ใน settings.json ให้ด้วย
```

Claude จะ:
1. อ่าน `docs/SETUP.md` + `docs/PLACEHOLDERS.md` เพื่อเข้าใจว่าต้องตั้งอะไรบ้าง
2. **ถามค่าที่ขาด** ทีละข้อ (assistant name, project, tracker, vault path, integration/protected branch ฯลฯ)
3. รัน find/replace แทน `{{TOKEN}}` ทุกไฟล์ในรีโป
4. สร้างโฟลเดอร์ vault layout + wire `SessionStart` / `Stop` hooks ใน `settings.json`
5. ตรวจ `grep '{{'` ว่าไม่มี token ค้าง แล้วสรุปให้

อยากทำทีละส่วนก็ได้ เช่นบอกว่า **"เซ็ตอัพเฉพาะ team coordination (COORD) ให้หน่อย"** หรือ **"ขอแค่ skill toolkit ไม่เอา COORD"**

> 💡 อยากเริ่มจากแบบ manual? ดู **[docs/SETUP.md](docs/SETUP.md)** (ทีละ step) + **[docs/PLACEHOLDERS.md](docs/PLACEHOLDERS.md)** (sed recipe เติม placeholder)

---

## 🚩 3 ฟีเจอร์เด่น (ที่ session Claude Code เปล่า ๆ ทำไม่ได้)

### 🚀 `/shipit` — คำสั่งเดียว วิ่งทั้งเส้น delivery
รับ design ที่ตกลงแล้ว → วิ่งครบวง: **implement → test loop (red→fix→green) → commit → push → เปิด PR → merge เข้า integration branch → report.** หยุดทุก human gate (เปิด PR ให้ protected branch แต่ไม่กด merge เอง) · test ที่กิน token รันใน subagent แยก context หลักไม่รก

### 🧪 `/test` — "เขียวไหม?" โดยไม่ ship
ครึ่ง verify ของ shipit · **auto-detect คำสั่งเทสของ repo** รัน unit→e2e ใน loop แยก แล้วคืน verdict **ตามจริง** (pass / fail / flaky / SKIP ไม่ปลอม pass) · ไม่แตะ git

### 👥 COORD — เปลี่ยน N session เป็นทีม dev เดียว
รันหลาย session เป็น **manager · design · worker · qa · security** แบ่งงานผ่าน **BOARD** ไฟล์เดียวบนดิสก์ · แต่ละ role มี **self-wake watcher** (`coord/board-wake.sh`) ปลุก session ตัวเองเมื่อบอร์ดมีงานถึงเลนตัวเอง → ทีมที่รันอยู่ประสานกันเอง คนเดินสารแค่ตอน cold start / fallback · scale `worker`/`qa` ได้ไม่จำกัด (`/coord-worker 1`, `2`, …)

---

## 🧠 Headline: ลูปอัปเกรดตัวเองแบบมี approval gate

assistant เรียนรู้จาก session ตัวเอง แต่ **แก้ skill/rule ตัวเองเงียบ ๆ ไม่ได้เด็ดขาด** — มี 2 ราง:

1. **`/curate`** — อ่าน session capture + daily note + memory ปัจจุบัน แล้วแยกเป็น 2 ถัง:
   - **ถัง A — ข้อเท็จจริง** (เกี่ยวกับคุณ/โปรเจกต์/decision) → เขียนลง memory ได้เลย
   - **ถัง B — การแก้พฤติกรรม/skill/config** → เขียนเป็น **proposal เท่านั้น ไม่ apply เอง**
   (รอบ weekly อัตโนมัติ = proposals-only + sandbox เขียนได้แค่โฟลเดอร์ proposals)
2. **`/review-proposals`** — **จุดเดียว**ที่ change ต่อ skill / `CLAUDE.md` / `settings.json` / agent จะถูก apply ได้ และ **เฉพาะหลังคุณอนุมัติทีละข้อ**

> *ข้อเท็จจริงราคาถูก · การแก้พฤติกรรมต้องผ่าน gate* = คุณสมบัติความปลอดภัยแกนกลางของทั้งระบบ

---

## 📦 มีอะไรในนี้

```
.claude/
  commands/    /coord engine + /coord-{manager,design,worker,qa,security} (ทีม COORD)
  skills/      ~45 skill (toolkit + team-coordination + curate / review-proposals)
  agents/      subagent: curator, shipit-loop, strategic-reviewer, tracker-card
  hooks/       session-start.sh (โหลด context) · capture.sh (จับ session) · curate-cron.sh (weekly)
  settings.json
.githooks/     pre-commit secret guard + config-only backup (memory ไม่ขึ้น git)
coord/         BOARD.md + board-wake.sh (self-wake watcher) + mem/ (memory ต่อ role)
examples/      skill/integration เฉพาะองค์กร (copy ไปปรับเอง)
vault-skeleton/ โครง notes-vault เปล่า
docs/          PLACEHOLDERS.md · SETUP.md · ARCHITECTURE.md · team-coordination.md
```

- **~45 skills** — SOP (review/deploy/infra/security/team), วินัย engineering (think-before-coding, TDD, surgical-changes, diagnose, post-mortem), การสื่อสาร/จัดการ, cadence รายวัน/สัปดาห์/เดือน, governance (charter-check, ADR, bus-factor) + orchestrator (`/shipit`, `/test`, `/design-cards`)
- **agents** — `curator` (read-only วิเคราะห์ ไม่เขียนไฟล์), `shipit-loop` (วน test แยก context), `strategic-reviewer`, `tracker-card`
- **hooks** — โหลด handoff/daily/proposals ตอนเปิด session · จับ digest ทุก session · weekly curate (ทั้งหมด fail-open)

---

## 🔒 ความปลอดภัย

- **pre-commit secret guard** (`grep` ล้วน ไม่มี dependency) — บล็อกไฟล์/diff ที่มี key/token/PEM (`sk-…`, `ghp_…`, AWS `AKIA…`) · false positive ใช้ `git commit --no-verify`
- **config-only backup** — ถ้า back `~/.claude` ขึ้น remote ส่วนตัว จะ push **เฉพาะ config** · durable memory (`projects/`) = จุดเสี่ยง PII **ไม่เคย** auto-stage
- **memory/PII ไม่ขึ้น version control** (ดู `.gitignore`)
- **รอบ unattended = sandbox** เขียนได้แค่โฟลเดอร์เดียว

---

## เริ่มเลย

แนะนำให้ใช้ทาง **"ให้ Claude เซ็ตอัพให้"** ด้านบน — เร็วและพลาดยากกว่า. ถ้าจะทำเอง:

```bash
# 1. fork แล้ว copy เข้า ~/.claude (ระดับ user) หรือ project root
cp -r claude-code-operating-system/.claude/* ~/.claude/

# 2. ทำ hooks ให้ executable
chmod +x ~/.claude/hooks/*.sh

# 3. เติม placeholder ({{ASSISTANT}}, {{PROJECT}}, {{VAULT}}, {{TRACKER}}, …)
#    ดู docs/PLACEHOLDERS.md (มี sed recipe ครบ)
```

walkthrough เต็ม: **[docs/SETUP.md](docs/SETUP.md)** · COORD: **[docs/team-coordination.md](docs/team-coordination.md)**

---

## License

MIT — ดู [`LICENSE`](LICENSE)
