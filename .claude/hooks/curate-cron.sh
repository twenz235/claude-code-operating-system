#!/usr/bin/env bash
# curate-cron.sh — unattended weekly "curate" via headless `claude -p` (Phase 3).
# PROPOSALS-ONLY mode: sandboxed (--permission-mode dontAsk + --settings allowlist) so it
# can READ anything but WRITE only to the proposals dir. It is denied ALL writes under
# ~/.claude (memory/skills/agents/CLAUDE.md/settings). Any memory facts it wants go INTO
# the proposal for the human to apply via the review-proposals skill. It never applies anything. Fail-open.
#
# รัน weekly แบบไม่มีคนเฝ้า: อ่านได้ทุกอย่าง แต่เขียนได้ที่เดียวคือโฟลเดอร์ proposals
# (approval-gate: ห้าม apply เอง — ทุกข้อเสนอรอคนรีวิวผ่าน review-proposals skill)
#
# Config via env:
#   PROJECT_ROOT   repo the curate run cd's into   (default: $HOME/project)
#   CLAUDE_VAULT   notes-vault root                 (default: $HOME/notes)
#   ASSISTANT_TAG  capture-note filename slug        (default: assistant)
#                  MUST match capture.sh + session-start.sh
set -uo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

PROJ="${PROJECT_ROOT:-$HOME/project}"
VAULT="${CLAUDE_VAULT:-$HOME/notes}"
ASSISTANT_TAG="${ASSISTANT_TAG:-assistant}"
LOGDIR="$HOME/.claude/logs"
LOG="$LOGDIR/curate-cron.log"
SANDBOX="${CURATE_SANDBOX:-$HOME/.claude/curate-sandbox.json}"
mkdir -p "$LOGDIR" 2>/dev/null || true

CLAUDE_BIN="$(command -v claude || true)"
if [ -z "$CLAUDE_BIN" ]; then echo "$(date '+%F %T') ERROR: claude binary not found in PATH" >> "$LOG"; exit 0; fi
cd "$PROJ" 2>/dev/null || exit 0

# Note: the prompt references $VAULT and $ASSISTANT_TAG via envsubst-style expansion below,
# so the headless run reads the same paths/globs the capture hook writes to.
PROMPT="$(cat <<EOF
You are running UNATTENDED — this is the weekly scheduled "curate" maintenance run, NO human present. Follow your curate skill (~/.claude/skills/curate/SKILL.md), ADAPTED for UNATTENDED / PROPOSALS-ONLY mode:
1. Do the analysis YOURSELF — do NOT spawn a subagent.
2. Read: recent capture notes in "${VAULT}/inbox/fleeting/" (files matching *-${ASSISTANT_TAG}-*.md), recent Daily notes, the durable memory under this project's memory dir + MEMORY.md, the skill set in ~/.claude/skills/, and ~/.claude/CLAUDE.md.
3. You may write to ONE place only: "${VAULT}/agent/proposals/{YYYY-MM-DD}.md". You are sandboxed OUT of memory, skills, CLAUDE.md, settings — that is intentional. Do NOT try to write them.
4. Put EVERYTHING you'd recommend into that proposal file, in two sections:
   - "## Proposed memory additions" — durable facts worth remembering (the human applies them to memory via the review-proposals skill). Do NOT write memory yourself.
   - "## Proposed behavior/skill changes" — each: problem / evidence / proposal / diff. NEVER apply — proposals only.
5. If nothing is high-signal, write NOTHING and stop. Be conservative — never invent facts.
6. If you see more than a handful of stale "*-${ASSISTANT_TAG}-*.md" captures still in "${VAULT}/inbox/fleeting/" (not already under .curated/), add a short note under "## Proposed behavior/skill changes" recommending an interactive retention sweep via the review-proposals skill. Do NOT move or write them yourself — you are sandboxed out of fleeting by design.
EOF
)"

echo "$(date '+%F %T') --- curate-cron start (proposals-only) ---" >> "$LOG"
"$CLAUDE_BIN" -p "$PROMPT" \
  --permission-mode dontAsk \
  --settings "$SANDBOX" \
  --max-turns 50 \
  >> "$LOG" 2>&1
echo "$(date '+%F %T') --- curate-cron end (exit=$?) ---" >> "$LOG"
exit 0
