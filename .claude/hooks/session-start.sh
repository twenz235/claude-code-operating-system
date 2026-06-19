#!/usr/bin/env bash
# session-start.sh — SessionStart hook (Phase 1, "Load")
# Injects the latest handoff capture + today's Daily note + pending proposals as
# additionalContext so a new session resumes with continuity. Fail-open: always exit 0.
# Registered in ~/.claude/settings.json under hooks.SessionStart (no matcher).
#
# ตอนเปิด session ใหม่ → ฉีดบริบทต่อเนื่อง (handoff ล่าสุด + daily วันนี้ + proposal ค้าง)
# เข้าไปเป็น additionalContext เพื่อให้ทำงานต่อจากที่ค้างได้ทันที (fail-open เสมอ)
#
# Config via env:
#   CLAUDE_VAULT   notes-vault root            (default: $HOME/notes)
#   ASSISTANT_TAG  capture-note filename slug   (default: assistant)
#                  MUST match capture.sh + curate-cron.sh
set -uo pipefail

VAULT="${CLAUDE_VAULT:-$HOME/notes}"
ASSISTANT_TAG="${ASSISTANT_TAG:-assistant}"
FLEETING="$VAULT/inbox/fleeting"
DAILY="$VAULT/work/daily"
PROPOSALS="$VAULT/agent/proposals"

INPUT="$(cat 2>/dev/null)" || exit 0
command -v jq >/dev/null 2>&1 || exit 0

SOURCE="$(printf '%s' "$INPUT" | jq -r '.source // empty' 2>/dev/null)"
# skip on compaction — context already present this session
[ "$SOURCE" = "compact" ] && exit 0

TMP="$(mktemp 2>/dev/null)" || exit 0
trap 'rm -f "$TMP"' EXIT

# latest capture = previous session's handoff (glob must match capture.sh output)
LASTCAP="$(ls -t "$FLEETING"/*-"${ASSISTANT_TAG}"-*.md 2>/dev/null | head -1)"
if [ -n "${LASTCAP:-}" ] && [ -f "$LASTCAP" ]; then
  { echo "## Latest handoff ($(basename "$LASTCAP"))"; sed -n '7,60p' "$LASTCAP"; echo; } >> "$TMP"
fi

# today's daily note
TODAY="$(date +%Y-%m-%d)"
if [ -f "$DAILY/$TODAY.md" ]; then
  { echo "## Today's daily note ($TODAY)"; sed -n '1,40p' "$DAILY/$TODAY.md"; echo; } >> "$TMP"
fi

# pending self-upgrade proposals (excluding the README) — surface for review
PEND="$(ls "$PROPOSALS"/*.md 2>/dev/null | grep -v README || true)"
if [ -n "${PEND:-}" ]; then
  { echo "## ⚠️ Pending proposals — run the review-proposals skill:"
    printf '%s\n' "$PEND" | while read -r p; do echo "- $(basename "$p")"; done; } >> "$TMP"
fi

[ -s "$TMP" ] || exit 0
jq -nc --rawfile ctx "$TMP" \
  '{hookSpecificOutput:{hookEventName:"SessionStart", additionalContext:("[memory] Continuity from the previous session / บริบทต่อเนื่องจาก session ก่อน:\n\n" + $ctx)}}'
exit 0
