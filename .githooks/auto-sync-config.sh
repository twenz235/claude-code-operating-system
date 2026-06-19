#!/bin/sh
# auto-sync-config.sh — push ONLY the "config" of ~/.claude to a private backup remote ({{REPO}}).
#
# DELIBERATE BOUNDARY: this pushes CONFIG ONLY. Durable memory (projects/) is NEVER staged here —
# it is the PII choke point and stays a manual, human-reviewed push. Do not add projects/ to PATHS.
#
# ขอบเขตที่ตั้งใจ: sync แค่ "config" เท่านั้น — memory (projects/) ไม่แตะอัตโนมัติเด็ดขาด
# เพราะเป็นจุดเสี่ยง PII → ต้องให้คนตรวจแล้ว push เองทีหลัง อย่าเอา projects/ ใส่ใน PATHS
#
# Run by a scheduler (e.g. launchd/cron, daily). Log → ~/.claude/logs/config-sync.log
#
# Config via env:
#   GIT          git binary    (default: /usr/bin/git)
#   SYNC_REMOTE  git remote    (default: origin)
#   SYNC_BRANCH  git branch    (default: main)
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin
GIT="${GIT:-/usr/bin/git}"
REPO="$HOME/.claude"
REMOTE="${SYNC_REMOTE:-origin}"
BRANCH="${SYNC_BRANCH:-main}"
LOG="$HOME/.claude/logs/config-sync.log"
mkdir -p "$(dirname "$LOG")" 2>/dev/null || true

# config-only allowlist — memory/projects intentionally absent (PII choke point)
PATHS="CLAUDE.md RTK.md settings.json curate-sandbox.json skills agents hooks .githooks .gitignore"

cd "$REPO" || { echo "$(date '+%F %T') ERR: no $REPO" >> "$LOG"; exit 1; }

# stage config paths only (memory/projects never enters)
$GIT add -- $PATHS 2>/dev/null

# no config change → quiet no-op
if $GIT diff --cached --quiet -- $PATHS; then
  echo "$(date '+%F %T') no config change" >> "$LOG"
  exit 0
fi

# commit config paths only (won't sweep up memory the user may have staged) — pre-commit hook scans secrets
if $GIT commit -m "auto-sync config $(date '+%F %T')" -- $PATHS >/dev/null 2>&1; then
  if $GIT push "$REMOTE" "$BRANCH" >/dev/null 2>&1; then
    echo "$(date '+%F %T') pushed config OK" >> "$LOG"
  else
    echo "$(date '+%F %T') ERR: push failed (ssh/network?)" >> "$LOG"; exit 1
  fi
else
  echo "$(date '+%F %T') BLOCKED: commit stopped by pre-commit hook (secret?) — not pushed" >> "$LOG"; exit 1
fi
