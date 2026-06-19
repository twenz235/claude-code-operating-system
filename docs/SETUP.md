# Setup

A step-by-step guide to installing the Claude Code Operating System (CCOS) into your own `~/.claude` and notes vault. Work top to bottom; the optional sections at the end can be skipped on a first pass.

> **เริ่มจากบนลงล่าง (TH):** ทำตามลำดับ; ส่วน *optional* ท้าย ๆ ข้ามได้ในรอบแรก แล้วค่อยกลับมาเปิดทีหลัง

---

## 0. Prerequisites

- **Claude Code** installed and on your `PATH` (`claude --version`).
- **`jq`** — the hooks and the find/replace verification use it. The capture hook **fail-opens** without it (no crash) but writes no notes, so install it:
  - macOS: `brew install jq`  ·  Debian/Ubuntu: `sudo apt-get install jq`
  - Verify: `jq --version`
- **`git`** — for cloning, the secret-guard hook, and the optional config backup.
- **A notes vault** — any folder of Markdown files (Obsidian, a plain repo, etc.). This becomes `{{VAULT}}`.

---

## 1. Get the template

```bash
git clone <this-repo-url> ccos
cd ccos
```

Do **not** copy it into `~/.claude` yet — replace placeholders first (next step), so you never have half-substituted files live in your config.

---

## 2. Choose your placeholder values

Open `docs/PLACEHOLDERS.md` and decide a value for each `{{TOKEN}}`:
`{{ASSISTANT}}`, `{{USER}}`, `{{PROJECT}}`, `{{ORG}}`, `{{DOMAIN}}`, `{{REPO}}`, `{{VAULT}}`, `{{TRACKER}}`, `{{DEPLOY_PLATFORM}}`, `{{REGISTRY}}`, `{{OBJECT_STORE}}`, `{{OWNER_ROLE}}`.

Pick a short, filename-safe `{{ASSISTANT}}` slug — it ends up inside capture-note filenames.

---

## 3. Find / replace

Run the recipe from `docs/PLACEHOLDERS.md` (the `sed` loop), then confirm nothing remains:

```bash
grep -rn '{{' . --include='*.md' --include='*.json' --include='*.sh'   # expect: no output
```

> **ตรวจให้ครบ (TH):** ถ้า `grep '{{'` ยังเหลือ แปลว่ายังแทนไม่ครบ — แก้ก่อนไปต่อ

---

## 4. Write your charter from the template

Skills that gate on principles (`charter-check`, `grill-with-docs`) read **your** charter — they only know what you write down.

```bash
cp docs/CHARTER.template.md "<your-vault>/reference/charter.md"
```

Edit your copy: replace the sample principles with your team's real ones and **mark the non-negotiables** (the template uses ⛔). Keep it short — a handful of standing principles, not a policy binder. See `docs/CHARTER.template.md` for the format.

---

## 5. Set up the vault layout + `CLAUDE_VAULT`

The hooks and cadence skills assume this layout under your vault root. Create the folders the features you'll use need:

```
{{VAULT}}/
├── inbox/
│   └── fleeting/          # capture.sh writes one note per session here
│       └── .curated/      # archived captures after /curate (auto-created)
├── work/
│   ├── daily/             # daily notes (session-start.sh reads today's)
│   ├── weekly/  monthly/  quarterly/   areas/
│   └── 00-work-moc.md     # optional map-of-content entry
├── reference/
│   ├── charter.md         # your filled charter (step 4)
│   └── adrs/
├── templates/             # adr.md, daily.md, etc. (cadence skills reference these)
├── agent/
│   ├── proposals/         # self-upgrade proposals land here (and applied/)
│   └── upgrade-plan.md    # optional: your continuous-learning plan
└── .sync/                 # optional sync log + sync-all.sh
```

Quick create:

```bash
mkdir -p "<your-vault>"/{inbox/fleeting/.curated,work/daily,work/weekly,work/monthly,work/quarterly,work/areas,reference/adrs,templates,agent/proposals/applied}
```

Then point the hooks at it. The hooks default to `$HOME/notes`; override with `CLAUDE_VAULT` if your vault is elsewhere. Add to your shell profile (`~/.zshrc` / `~/.bashrc`):

```bash
export CLAUDE_VAULT="$HOME/path/to/your/vault"
export ASSISTANT_TAG="nova"        # your {{ASSISTANT}} slug — see step 6
```

> `ASSISTANT_TAG` defaults to `assistant`. Set it to match your `{{ASSISTANT}}` so capture-note filenames read naturally.

---

## 6. Install `.claude/` and wire the hooks

Copy the config into place (merge carefully if you already have a `~/.claude`):

```bash
cp -R .claude/skills .claude/agents .claude/hooks ~/.claude/
cp .claude/curate-sandbox.json ~/.claude/
# settings.json: merge by hand if you already have one (see below)
chmod +x ~/.claude/hooks/*.sh
```

`.claude/settings.json` registers two hooks the harness runs (not Claude):

- **`SessionStart` → `session-start.sh`** — injects continuity context (latest handoff capture + today's daily note + any pending proposals) into a new session.
- **`Stop` → `capture.sh`** — writes one redacted capture note per session into `{{VAULT}}/inbox/fleeting/`.

Both are **fail-open**: any error exits 0 so they can never break a session.

> Merge settings, don't blind-copy: if you already have `~/.claude/settings.json`, copy only the `hooks` block and any `permissions` you want. Then validate: `jq -e . ~/.claude/settings.json`.

### Keep the capture-note glob consistent

The capture filename is `${DATE}-${ASSISTANT_TAG}-${SHORT}.md`, and **three** places must agree on the `${ASSISTANT_TAG}` slug or continuity breaks:

| File | Uses the slug for |
|------|-------------------|
| `capture.sh` | **writes** the note: `*-${ASSISTANT_TAG}-*.md` |
| `session-start.sh` | **finds** the latest handoff via glob `*-"${ASSISTANT_TAG}"-*.md` |
| `curate-cron.sh` | **reads** captures matching `*-${ASSISTANT_TAG}-*.md` |

All three read `ASSISTANT_TAG` from the environment, so setting it **once** in your profile (step 5) keeps them aligned. If you instead hardcode a value, change it in all three.

### Verify the hooks

```bash
# capture: feed a fake Stop payload, confirm a note appears
echo '{"transcript_path":"/dev/null","session_id":"test1234","cwd":"'"$PWD"'"}' \
  | ~/.claude/hooks/capture.sh ; echo "exit=$?"
# (with a real transcript it writes to $CLAUDE_VAULT/inbox/fleeting/)

# session-start: feed a startup payload, confirm valid JSON additionalContext
echo '{"source":"startup"}' | ~/.claude/hooks/session-start.sh | jq .
```

Both must exit 0. The simplest real check: open a Claude session, do a few turns, end it, and look for a new file in `inbox/fleeting/`.

---

## 7. (Optional) Self-upgrade loop — curate-cron + reviewed sandbox

CCOS can learn from its own sessions on a schedule, but **only behind an approval gate** — see ARCHITECTURE.md for the design. Two pieces:

**a) The sandbox profile** (`~/.claude/curate-sandbox.json`) constrains the unattended run to **read anything, write only the proposals dir**, and **deny all writes under `~/.claude`**. Edit the two proposal globs to point at *your* vault if it isn't `$HOME/notes`:

```jsonc
"Write(${HOME}/notes/agent/proposals/**)"   // → ${HOME}/your-vault/agent/proposals/**
"Edit(${HOME}/notes/agent/proposals/**)"
```

**b) Schedule `curate-cron.sh`** (weekly is plenty). It runs headless `claude -p` with that sandbox and writes **proposals only** — it never edits memory, skills, or settings. Set `PROJECT_ROOT` / `CLAUDE_VAULT` / `ASSISTANT_TAG` in the job's environment.

macOS `launchd` (weekly) — example `~/Library/LaunchAgents/com.example.claude-curate.plist`:
```xml
<key>ProgramArguments</key>
<array><string>/bin/sh</string><string>-c</string>
  <string>CLAUDE_VAULT=$HOME/your-vault PROJECT_ROOT=$HOME/your-project ASSISTANT_TAG=nova $HOME/.claude/hooks/curate-cron.sh</string>
</array>
<key>StartCalendarInterval</key><dict><key>Weekday</key><integer>1</integer><key>Hour</key><integer>9</integer></dict>
```
Or cron: `0 9 * * 1 CLAUDE_VAULT=... PROJECT_ROOT=... ASSISTANT_TAG=nova ~/.claude/hooks/curate-cron.sh`

**c) Review the proposals through `/review-proposals`.** This is the only place CCOS may edit its own skills / `CLAUDE.md` / `settings.json`, one approved item at a time. `session-start.sh` surfaces pending proposals at the top of each session so you don't forget. Run `/curate` manually too whenever the fleeting inbox piles up.

> Logs land in `~/.claude/logs/curate-cron.log`. Check it after the first scheduled run.

---

## 8. (Optional) Install the `.githooks` secret guard

If you keep `~/.claude` (or any config) under git, wire the dependency-free pre-commit secret guard:

```bash
cp -R .githooks ~/.claude/
git -C ~/.claude config core.hooksPath .githooks
chmod +x ~/.claude/.githooks/*
```

It **hard-blocks** sensitive filenames (`.credentials.json`, `*.pem`, `*.key`, `settings.local.json`, `*-private.md` — add your own sensitive filename patterns) and scans staged diffs for key/token/private-key shapes. A genuine false positive can be bypassed with `git commit --no-verify` (use sparingly).

---

## 9. (Optional) Config-only backup, memory excluded

`auto-sync-config.sh` pushes **only the config** of `~/.claude` to a private remote on a schedule. **Durable memory (`projects/`) is never staged** — it's the PII choke point and stays a manual, human-reviewed push. The allowlist is fixed in the script (`CLAUDE.md`, `settings.json`, `skills`, `agents`, `hooks`, `.githooks`, etc.); don't add `projects/`. Configure the remote/branch via `SYNC_REMOTE` / `SYNC_BRANCH` and schedule it like step 7. The pre-commit guard runs on every commit, so a leaked secret blocks the push.

---

## 10. (Optional) Integrations

CCOS keeps third-party integrations **opt-in** so the core stays vendor-neutral:

- **Token-saving CLI proxy** (PreToolUse hook that rewrites Bash) — register under `hooks.PreToolUse`. See `examples/integrations/rtk.md`.
- **Desktop / phone notifier** (Notification hook) — host-specific; see `examples/integrations/notifier.md`.

These are removed from the shipped `settings.json` on purpose; add only what you use.

---

## 11. Wire your tracker (`{{TRACKER}}`)

Skills like `to-ticket`, `task-manager`, `design-cards`, and the `tracker-card` agent target a generic tracker.

1. If your tracker has an MCP server, connect it and add its **read-only** tools to `settings.local.json` (not the committed `settings.json`) — see the example file's MCP note (`mcp__YOUR_TRACKER__list_issues`, etc.).
2. Replace `<TICKET-KEY>` with your prefix (e.g. `PROJ`) and set your project taxonomy where the skills reference it.

---

## 12. Tune defaults

In `~/.claude/settings.json`:

- **`effortLevel`** (`low | medium | high | xhigh`) — lower for fast/cheap replies, higher for thorough edge-case checking. Per-message overrides (e.g. `quickmode` / `deepdive`) work if your `CLAUDE.md` defines them.
- **`permissions.allow`** — keep it as narrow as is safe; add commands you run often. Machine-specific or path-bound permissions belong in `settings.local.json` (gitignored), not the committed file.
- **`agentPushNotifEnabled`** — `false` to silence agent push notifications.

---

## 13. Verify the whole thing

```bash
grep -rn '{{' ~/.claude --include='*.md' --include='*.json' --include='*.sh'   # no leftover tokens
jq -e . ~/.claude/settings.json && jq -e . ~/.claude/curate-sandbox.json        # valid JSON
ls -l ~/.claude/hooks/*.sh                                                       # all executable
echo '{"source":"startup"}' | ~/.claude/hooks/session-start.sh | jq .            # valid hook output
```

Then open a real session: confirm the SessionStart context appears, run a couple of turns, end it, and check a capture note landed in `{{VAULT}}/inbox/fleeting/`.

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| No capture note after a session | `jq` missing, or `CLAUDE_VAULT` wrong | `jq --version`; confirm `CLAUDE_VAULT` points at a writable vault |
| SessionStart context empty | No prior capture / no daily note yet; or running on `compact` | Normal on a fresh vault — it fills in after the first real session |
| Capture written but handoff never loads | `ASSISTANT_TAG` mismatch between `capture.sh` and `session-start.sh` | Set `ASSISTANT_TAG` once in your profile; re-check the glob in both |
| `curate-cron` does nothing / `claude binary not found` | `claude` not on the cron/launchd `PATH` | Hardcode the binary path or extend `PATH` in the job; read `~/.claude/logs/curate-cron.log` |
| Unattended curate tries to write memory/skills | Sandbox not applied | Confirm `--settings ~/.claude/curate-sandbox.json` is passed; the deny rule covers `~/.claude/**` |
| `/review-proposals` won't run headless | By design — it requires a human to approve | Run it interactively only |
| pre-commit blocks a legitimate file | Filename/pattern false positive | Rename, or `git commit --no-verify` (sparingly) |
| `jq -e .` fails on `settings.json` | Comment (`//`) keys, or a syntax slip | Remove `//` keys if your harness rejects them; re-validate |
| Tokens still show as `{{...}}` at runtime | Find/replace skipped some files | Re-run step 3's `grep` and `sed` |
