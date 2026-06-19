# claude-code-operating-system

> A **dev / engineering operating system** for [Claude Code](https://docs.anthropic.com/en/docs/claude-code): skills + agents + hooks + a safe self-upgrade loop. For any engineer who wants Claude Code to behave with discipline.
> ระบบปฏิบัติการสำหรับนักพัฒนา/วิศวกรบน Claude Code — ชุด skill + agent + hook + ลูปอัปเกรดตัวเองแบบมี approval gate

This is a template repo. Fork it, drop it into `~/.claude` (user-level) or a project, fill in the placeholders, wire up the hooks — and your assistant gains a repeatable set of engineering disciplines (review, deploy, debug, plan, cadence) plus a continuity layer that remembers across sessions and proposes its own improvements **without ever editing itself silently**.

It is written **English-primary with a Thai gloss**. The bilingual character is intentional — keep it if it helps your team, strip the Thai if it doesn't. No load-bearing instruction is Thai-only.

---

## Why it exists

Claude Code is powerful but stateless and undisciplined by default: every session starts cold, every important habit has to be re-explained, and an agent that can edit its own config is one bad turn away from rewriting its own rules. This repo encodes a working engineer's habits as **skills the model can invoke on trigger**, **agents that isolate token-heavy or read-only work**, and **hooks that carry context across sessions** — then puts a **human approval gate** in front of any change the assistant wants to make to itself.

The goal: an assistant that behaves like a disciplined senior engineer, gets a little better each week, and can never silently change its own operating rules.

---

## What's inside (high-level map)

```
.claude/
  skills/            ~45 invokable skills (skill toolkit + curate / review-proposals)
    README.md        the skills index — start here
  agents/            subagents: curator, shipit-loop, strategic-reviewer, tracker-card
  hooks/             session-start.sh (load) · capture.sh (capture) · curate-cron.sh (weekly)
  settings.json      user-level settings template (hooks, permissions, effort)
  settings.local.json.example   per-machine override (gitignored when real)
  curate-sandbox.json           proposals-only sandbox for the unattended curate run
.githooks/
  pre-commit         dependency-free secret guard (blocks keys/credentials)
  auto-sync-config.sh           config-only backup push (memory NEVER synced)
examples/            opt-in, org-specific skills + integrations + charter + notes
vault-skeleton/      empty notes-vault layout the cadence skills write into
docs/                PLACEHOLDERS.md · SETUP.md · ARCHITECTURE.md · CHARTER.template.md
```

### The skills (≈45)
An engineering toolkit grouped by purpose — SOP skills (review, deploy, infra, security/privacy, team comms), cross-cutting engineering disciplines (think-before-coding, TDD, surgical-changes, diagnose, post-mortem), communication/management (escalation language, conversation→ticket, triage), daily/weekly/monthly cadence, token-saving modes, governance (charter-check, ADR draft, bus-factor), and a few **orchestrators** that drive a full dev loop. The full map lives in [`.claude/skills/README.md`](.claude/skills/README.md).

### The agents
Subagents spawned by skills to keep work isolated:
- **`curator`** — read-only analyst for the self-upgrade loop (cannot write files).
- **`shipit-loop`** — runs the token-heavy red→fix→rerun test loop in its own context; never commits/pushes/merges.
- **`strategic-reviewer`** — outsider review of a plan/PR/change.
- **`tracker-card`** — turns a design into tickets in your issue tracker.

### The hooks
- **`session-start.sh`** (SessionStart) — injects the previous session's handoff, today's daily note, and any pending self-upgrade proposals as context, so a new session resumes warm. Fail-open.
- **`capture.sh`** (Stop) — writes one digest note per session into your notes vault. Fail-open.
- **`curate-cron.sh`** (scheduler, weekly) — the unattended half of the self-upgrade loop (see below).

---

## Headline feature: a safe self-upgrade loop (approval gate)

The assistant learns from its own sessions — but it can **never edit its own skills/rules silently**. Two rails:

1. **`/curate`** — reads recent session captures, daily notes, and current memory, then splits findings into **two buckets**:
   - **Bucket A — facts** about you/your projects/decisions → may be written to durable memory directly.
   - **Bucket B — behavior/skill/config changes** → written only as **proposals**, never applied.
   The weekly unattended run (`curate-cron.sh`) is **proposals-only** and sandboxed (`curate-sandbox.json`): it can read anything but write **only** to the proposals folder — denied all writes under `~/.claude`.

2. **`/review-proposals`** — the **single chokepoint** where a change to a skill / `CLAUDE.md` / `settings.json` / an agent can be applied, and **only after you approve it, one item at a time**. Not approved = not touched.

This split — *facts are cheap, behavior changes are gated* — is the core safety property of the whole system. Everything the assistant does to itself is written down and auditable.

---

## Security posture

- **Pre-commit secret guard** (`.githooks/pre-commit`) — dependency-free (pure `grep`). Hard-blocks sensitive filenames (`.credentials.json`, `*.pem`, `*.key`, `settings.local.json`) and scans staged diffs for key/token/private-key patterns (`sk-…`, `ghp_…`, AWS `AKIA…`, PEM blocks, OAuth secrets). False positive? `git commit --no-verify` — deliberately.
- **Config-only backup** (`.githooks/auto-sync-config.sh`) — if you back your `~/.claude` up to a private remote, this pushes **config only**. Durable memory (`projects/`) is the **PII choke point** and is **never** auto-staged — it stays a manual, human-reviewed push.
- **Memory/PII excluded from version control** — see [`.gitignore`](.gitignore). Memory contains facts about real people and projects; it does not belong in a public (or even an auto-pushed private) repo.
- **Unattended runs are sandboxed** — the weekly curate run has write access to exactly one folder.

---

## Quick start

```bash
# 1. Fork, then copy the operating system into your user-level Claude config
#    (or into a project root for project-scoped use).
cp -r claude-code-operating-system/.claude/* ~/.claude/
cp claude-code-operating-system/.githooks/* ~/.claude/.githooks/   # if backing up ~/.claude as a repo

# 2. Make the hooks executable
chmod +x ~/.claude/hooks/*.sh ~/.claude/.githooks/* 2>/dev/null

# 3. Fill in the placeholders ({{USER}}, {{PROJECT}}, {{VAULT}}, {{TRACKER}}, ...)
#    see docs/PLACEHOLDERS.md for the full dictionary
```

Then:
- **Wire the hooks** — `settings.json` already registers `SessionStart` → `session-start.sh` and `Stop` → `capture.sh`. Point `CLAUDE_VAULT` / `ASSISTANT_TAG` at your own notes vault (defaults: `$HOME/notes`, `assistant`). The three hooks share the same vault + filename slug — keep them in sync.
- **Create your notes vault** — copy `vault-skeleton/` to wherever `CLAUDE_VAULT` points (it's the empty layout the cadence skills write into).
- **Fill your charter** — copy `docs/CHARTER.template.md` to `{{VAULT}}/reference/charter.md` and write your own inviolable principles; the governance skills read it.
- **Schedule the weekly curate** (optional) — point a `launchd`/`cron` job at `curate-cron.sh` for the unattended proposals-only run.

Full walkthrough: **[`docs/SETUP.md`](docs/SETUP.md)**.

---

## Customizing the charter

Skills that gate on principles (`charter-check`, `adr-draft`, governance) read **your team charter**, not a hardcoded one. Start from [`docs/CHARTER.template.md`](docs/CHARTER.template.md), fill it with your own principles, and mark which are **inviolable**. The skills only know what you write down. คัดลอก template แล้วเติมหลักการของทีมคุณเอง — skill จะอ่านอันนั้น

A worked example charter lives under [`examples/charter/`](examples/charter/).

> **On AI attribution:** some setups prefer to omit AI co-author lines from commits/PRs. That's an **optional, documented preference** — not a rule baked into these skills. Document it in your charter or commit convention if you want it; otherwise the harness default applies.

---

## Optional integrations & examples

Anything tied to a specific vendor or org policy ships under `examples/` so you copy + adapt rather than run as-is:
- **`examples/integrations/`** — opt-in hook notes you wire up yourself: `rtk.md` documents a token-saving CLI proxy (`PreToolUse`), and there's a documented slot for a desktop/phone notifier (`Notification`). The core `settings.json` leaves these slots empty on purpose.
- **`examples/skills/`** — org-specific cadence skills (`hiring-interview`, `refuse-list`, `weekly-review`, `workload-balance`) whose compensation/market/KPI/role framing is yours to fill.
- **`examples/agents/`**, **`examples/notes/`**, **`examples/charter/`** — sample agents, note templates, and a filled charter.

Substitute `{{TRACKER}}`, `{{DEPLOY_PLATFORM}}`, `{{OBJECT_STORE}}`, `{{REGISTRY}}`, `{{OWNER_ROLE}}`, `<project-root>`, `<TICKET-KEY>` with your own tools and conventions — see [`docs/PLACEHOLDERS.md`](docs/PLACEHOLDERS.md).

---

## Bilingual note

Headings, structure, and the first statement of every instruction are in **English** so an English-first reader can follow. A **Thai gloss** rides alongside where it adds nuance. This is a feature, not leftover translation — natural bilingual, not machine-translated. If you only work in one language, deleting the gloss is safe; never delete a load-bearing English instruction.

---

## Contributing

New or modified skills should follow the toolkit's pattern (`write-skill` scaffolds one). Keep contributions **PII-free**, apply the **placeholder rules**, and preserve the **bilingual gloss**. Details in [`CONTRIBUTING.md`](CONTRIBUTING.md).

## License

MIT — see [`LICENSE`](LICENSE).

## Credits (optional)

Several skill patterns adapt **public** engineering practices (e.g. Andrej Karpathy's coding-discipline notes, Matt Pocock's workflow patterns, and common debugging methodologies). These are optional credits, not dependencies — see [`.claude/skills/README.md`](.claude/skills/README.md) for the per-skill lineage.
