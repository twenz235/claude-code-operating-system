# Skills Index — Engineering Toolkit

> **This file is an index, not a skill.** มันไม่มี YAML frontmatter โดยตั้งใจ เพื่อไม่ให้ Claude Code โหลดเป็น skill ปลอม.
> The real skills live at `~/.claude/skills/<name>/SKILL.md` (one folder per skill).

These skills are a **dev / engineering operating system anyone can use** for Claude Code: a set of repeatable disciplines (review, deploy, debug, plan, cadence) plus a few orchestrators that drive a full dev loop. They are written **English-primary with a Thai gloss** — the bilingual character is intentional, keep it if it helps your team.

## Shared references

Skills point at a few things you provide for your own setup:

- **Your engineering playbook / responsibilities doc** — e.g. `<project-root>/docs/team-lead-responsibilities.md`
- **Your team charter** — e.g. `docs/CHARTER.template.md` (copy + fill with your own principles)
- **Your notes vault** — `{{VAULT}}/work/` (the second-brain / PKM folder where cadence skills write daily/weekly notes)
- **Methodology credits** — several patterns adapt public engineering practices (Karpathy, Matt Pocock, and common debugging methodology). These are optional credits, not dependencies.

> Skills cite "your SOPs" and "your charter" generically. Wherever you see `SOP-NN`, `{{TRACKER}}`, `{{DEPLOY_PLATFORM}}`, `{{OWNER_ROLE}}`, `<project-root>`, or `<TICKET-KEY>`, substitute your own. ไม่มีการฮาร์ดโค้ดชื่อบริษัท/คนจริงในชุดนี้.

---

## Group A: SOP Skills (your standard operating procedures)

จับคู่ skill กับ SOP ของทีมคุณ. แทน `SOP-NN` ด้วยรหัส SOP จริง (หรือชื่อกิจกรรม) ของคุณ.

> Code review uses Claude Code's built-in `/code-review`; `code-review-detail` below deep-dives a single finding.

| Skill | Trigger | Maps to |
|-------|---------|---------|
| `backend-api-contract` | Start a new API / change a contract — เริ่ม API ใหม่ หรือแก้ contract | your API/contract SOP |
| `code-review-detail` | A dev asks for a deep-dive on a review finding — ขออธิบายเชิงลึก | your code-review SOP |
| `cicd-deploy` | Pipeline change / production deploy doctrine + checklist | your CI/CD SOP |
| `deploy` | Deploy fe/be to any env, scaffold env/project, rollback, migrate ({{DEPLOY_PLATFORM}} template) | your deploy SOP |
| `infra-secrets-monitoring` | Secrets rotation, alert triage — หมุน secret, จัดการ alert | your infra SOP |
| `backup-dr` | Monthly mirror, quarterly DR drill | your backup/DR SOP |
| `security-privacy` | Feature touches PII, OWASP check — review ความปลอดภัย/ความเป็นส่วนตัว | your security SOP |
| `team-comms` | Standup, sprint planning, grooming, retro | your team-comms SOP |
| `task-manager` | Backlog grooming in {{TRACKER}}, onboarding | your task-mgmt SOP |
| `docs-maintenance` | Update handbook / architecture docs | your docs SOP |
| `mentorship-1on1` | 1-on-1, underperformance process — เมนเทอร์/จัดการคนต่ำกว่ามาตรฐาน | your mentorship SOP |

> **Note:** `security-privacy` frames the privacy review for whatever data-protection regime applies to you (GDPR / PDPA / CCPA), not one jurisdiction. `hiring-interview`, `refuse-list`, `weekly-review`, and `workload-balance` ship under **`examples/`** (org-specific cadence) rather than the core set — see below.

## Group B: Cross-cutting Engineering Skills

Core engineering disciplines — vendor- and org-neutral.

| Skill | Lineage | Role |
|-------|---------|------|
| `think-before-coding` | Karpathy | Ask before assuming — ถามก่อนสมมุติ |
| `simplicity-first` | Karpathy + KISS | Least code that solves it — โค้ดน้อยที่สุดที่แก้ปัญหา |
| `surgical-changes` | Karpathy | Touch only what's needed — แตะเฉพาะที่จำเป็น |
| `goal-driven-execution` | Karpathy | Translate task into verifiable success criteria |
| `grill-with-docs` | Pocock | Align before starting a feature — align ก่อนเริ่ม |
| `tdd` | Pocock | Red-green-refactor, vertical slices, coverage targets |
| `zoom-out` | Pocock | Get surrounding context before touching unfamiliar code |
| `improve-architecture` | Pocock | Quarterly architecture / testability review |
| `diagnose` | Pocock + common debugging methodology | Full debug loop (4 mantras) |
| `debug-mantra` | common debugging methodology | Compact 4-step (before escalating) |
| `post-mortem` | common debugging methodology | RCA after a validated fix |
| `scrutinize` | common debugging methodology | Review plan/PR as an outsider — verify every claim |

## Group C: Communication & Management Skills

| Skill | Lineage | Role |
|-------|---------|------|
| `management-talk` | — | Translate engineer-speak → {{OWNER_ROLE}} / leadership language |
| `to-ticket` | Pocock (to-prd) | Conversation/insight → a {{TRACKER}} ticket |
| `triage` | Pocock | Classify P0–P3 + impact matrix |

> **Note:** the conversation-to-ticket skill is named **`to-ticket`** — it targets whatever issue tracker you configure ({{TRACKER}}), with the tracker's own MCP/CLI tools plugged in.

## Group D: Personal Productivity / Cadence Skills

Writes into your notes vault (`{{VAULT}}/work/...`).

| Skill | Trigger |
|-------|---------|
| `daily-startup` | Start of day — เริ่มวัน |
| `daily-shutdown` | End of day — ก่อนเลิกงาน |
| `monthly-review` | Last week of the month — สัปดาห์สุดท้ายของเดือน |
| `quarterly-kpi` | End of quarter — สิ้นไตรมาส |
| `capture-knowledge` | New learning/insight — เจอความรู้ใหม่ |
| `meeting-capture` | Before/after a meeting — ก่อน/หลังประชุม |

> **Note:** `weekly-review` lives under **`examples/`** (its KPI/velocity framing is org-specific). See the examples section below.

## Group E: Token / Context Productivity

| Skill | Trigger |
|-------|---------|
| `caveman` | Long loop / context near full → token-compressed mode |
| `handoff` | Closing an unfinished session / before `/compact` / delegating to a subagent |

## Group F: Governance Skills

| Skill | Trigger |
|-------|---------|
| `charter-check` | Before a non-routine important decision — เช็คกับ charter ของทีม |
| `adr-draft` | Before committing an important, hard-to-reverse decision |
| `bus-factor-reminder` | Weekly check — knowledge stuck in one person's head |

> **Note:** `refuse-list` (politely declining out-of-scope work) lives under **`examples/`** because its scope boundaries are role/org-specific.

## Group G: Meta

| Skill | Trigger |
|-------|---------|
| `write-skill` | Add a new skill (short kebab name, no mandated prefix) |

## Group H: Orchestrators (conductor skill + spawned agents)

These drive a multi-step loop and spawn helper agents.

| Skill | Trigger | Pairs with agent |
|-------|---------|------------------|
| `shipit` | "ship it / run the whole loop" after design is agreed — full loop feature → integration branch | `shipit-loop` |
| `design-cards` | "design X then open cards" / a bug list to break into cards — design + tracker cards for devs (does not implement) | `Explore`, `tracker-card` |
| `test` | "is it green? / test this PR before review / run tests + report, don't ship" — `shipit` minus the delivery half | `shipit-loop` |

> The orchestrators stop at safe gates: they may merge into your **integration branch** (e.g. `dev`/`develop`) but open a **PR only** for `main`/`staging`/`prod` so a human approves the production merge. Adjust branch names to your flow.

> **Multi-agent team coordination.** The `team-coordination` skill explains the `/coord-*` multi-session team workflow — several Claude Code sessions working one project **asynchronously** through a shared **BOARD** file. Each role runs a background **self-wake watcher** (`coord/board-wake.sh`) that wakes its own session on lane-relevant board changes, so a running team coordinates itself; a human courier opens sessions for cold starts / relays as a fallback. It pairs with the `/coord` engine + `/coord-{manager,design,worker,qa,security}` commands; `worker`/`qa` run as multiple instances (`/coord-worker 1`, `2`, …). Full guide: [`docs/team-coordination.md`](../../docs/team-coordination.md). _ทีม session หลายตัวทำงานพร้อมกันผ่าน BOARD · แต่ละ role มี self-wake watcher · คนเดินสารแค่ cold start / fallback_

## Group I: Self-upgrade (approval gate)

How the toolkit improves itself **without ever editing its own config silently** — distillation and application are split across two skills, with your approval as the only chokepoint.

| Skill | Trigger |
|-------|---------|
| `curate` | Distill recent session captures → memory facts + write proposals for any skill/`CLAUDE.md`/settings/agent change. Never edits config silently — proposals only. |
| `review-proposals` | The single chokepoint that **applies** a proposed skill/`CLAUDE.md`/settings/agent change — one item per your explicit approval. |

> `curate` and `review-proposals` are a pair: `curate` writes proposals, `review-proposals` is the gate that applies the approved ones. `curate` also has an **unattended, proposals-only mode** (`curate-cron.sh` + `curate-sandbox.json`) — it can run on a schedule to draft proposals, but it still can only propose; nothing is applied until you approve it through `review-proposals`.

---

## Examples (org-specific skills, opt-in)

Some skills encode cadence/policy that is too organization-specific to ship as core. They live under **`examples/`** so you can copy + adapt rather than run as-is:

- `hiring-interview` — technical interview funnel + paid trial (compensation, market, and roles are yours to fill)
- `refuse-list` — out-of-scope refusal + who to redirect to (depends on your team's role split)
- `weekly-review` — weekly velocity / KPI / bus-factor snapshot (KPI set is org-specific)
- `workload-balance` — time-per-project aggregation + overload escalation to {{OWNER_ROLE}}

---

## Vault path

```
{{VAULT}}/work/
```

## Sync (optional)

If your vault has a sync script, run it after cadence skills write notes:

```bash
bash {{VAULT}}/.sync/sync-all.sh
```

## Charter

Skills that gate on principles read **your team charter**. Start from the scaffold and fill it with your own inviolable principles:

```
docs/CHARTER.template.md   →   {{VAULT}}/reference/charter.md (your filled copy)
```

> Mark which principles are inviolable for your team. Skills like `charter-check` will surface the relevant ones before a decision — but they only know what you write down.

## A note on AI attribution

Some setups prefer to **omit AI co-author attribution** from commits/PRs. That is an **optional, documented preference** — not a hard rule baked into these skills. If you want it, document it in your charter or commit-convention doc and the skills will respect it; otherwise the harness default applies.
