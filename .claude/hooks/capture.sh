#!/usr/bin/env bash
# capture.sh — Stop hook (Phase 1, "Capture")
# Reads the session transcript and writes/overwrites ONE capture note per session
# into your notes-vault fleeting inbox. Fail-open: must never break the session.
# Registered in ~/.claude/settings.json under hooks.Stop (no matcher).
#
# จับ session ที่เพิ่งจบ → เขียนโน้ตสรุป 1 ไฟล์ต่อ session ลง inbox ของ vault
# (กฎเหล็ก: ต้องไม่ทำให้ session พัง — error ทุกชนิด exit 0 เงียบ ๆ)
#
# Config via env (override in your shell profile or settings.json):
#   CLAUDE_VAULT   notes-vault root            (default: $HOME/notes)
#   ASSISTANT_TAG  capture-note filename slug   (default: assistant)
#                  MUST match session-start.sh + curate-cron.sh
set -uo pipefail

VAULT="${CLAUDE_VAULT:-$HOME/notes}"
FLEETING="$VAULT/inbox/fleeting"
ASSISTANT_TAG="${ASSISTANT_TAG:-assistant}"

# redact common secret/credential shapes before writing to the vault.
# ลบรูปทรง secret/credential ที่พบบ่อยก่อนเขียนลง vault (กัน key หลุดเข้าโน้ต)
scrub() {
  sed -E \
    -e 's/sk-ant-[A-Za-z0-9_-]{8,}|sk-[A-Za-z0-9]{16,}/[redacted-key]/g' \
    -e 's/gh[posru]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}/[redacted-token]/g' \
    -e 's/AKIA[0-9A-Z]{16}/[redacted-aws]/g' \
    -e 's/AIza[A-Za-z0-9_-]{20,}|xai-[A-Za-z0-9-]{20,}/[redacted-key]/g' \
    -e 's/([Bb]earer )[A-Za-z0-9._-]{12,}/\1[redacted]/g' \
    -e 's#(postgres|postgresql|mysql|mongodb|redis|amqps?)://[^:@/ ]+:[^@/ ]+@#\1://[redacted]@#g' \
    -e 's/(([Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]|[Pp][Aa][Ss][Ss][Ww][Dd]|[Tt][Oo][Kk][Ee][Nn]|[Aa][Pp][Ii][_-]?[Kk][Ee][Yy]|[Ss][Ee][Cc][Rr][Ee][Tt])"?[[:space:]]*[:=][[:space:]]*)[^[:space:]"]{6,}/\1[redacted]/g' \
    -e 's/-----BEGIN[A-Z ]*PRIVATE KEY-----/[redacted-private-key]/g'
}

INPUT="$(cat 2>/dev/null)" || exit 0
command -v jq >/dev/null 2>&1 || exit 0

TRANSCRIPT="$(printf '%s' "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)"
SESSION="$(printf '%s' "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)"
CWD="$(printf '%s' "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)"
[ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ] || exit 0
[ -n "$SESSION" ] || SESSION="unknown"

# real user asks (string content, minus command/system wrappers)
# คำสั่ง/คำถามจริงของผู้ใช้ (ตัด wrapper ของ command/system/tool ออก)
ASKS="$(jq -r 'select(.type=="user" and (.message.content|type=="string")) | .message.content' "$TRANSCRIPT" 2>/dev/null \
  | grep -vE '^[[:space:]]*<' \
  | grep -vE 'command-name|command-message|command-args|local-command|system-reminder|task-notification|tool-use-id|output-file|truncated [0-9]+ chars|full result in|</?result>|</?summary>|</?status>' \
  | sed '/^[[:space:]]*$/d' | scrub)"
ASK_COUNT="$(printf '%s\n' "$ASKS" | sed '/^[[:space:]]*$/d' | wc -l | tr -d ' ')"

# tools histogram + total
TOOLS="$(jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="tool_use") | .name' "$TRANSCRIPT" 2>/dev/null \
  | sort | uniq -c | sort -rn | awk '{printf "%s×%s  ", $2, $1}')"
TOOL_TOTAL="$(jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="tool_use") | .name' "$TRANSCRIPT" 2>/dev/null | wc -l | tr -d ' ')"

# files touched
FILES="$(jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="tool_use" and (.name=="Edit" or .name=="Write" or .name=="NotebookEdit" or .name=="MultiEdit")) | .input.file_path // empty' "$TRANSCRIPT" 2>/dev/null | sort -u)"

# slash commands + Skill-tool invocations
CMDS="$(jq -r 'select(.type=="user" and (.message.content|type=="string")) | .message.content' "$TRANSCRIPT" 2>/dev/null \
  | grep -oE '<command-name>[^<]+</command-name>' | sed -E 's#</?command-name>##g' | sort -u | tr '\n' ' ')"
SKILLS="$(jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="tool_use" and .name=="Skill") | .input.skill // empty' "$TRANSCRIPT" 2>/dev/null | sort -u | tr '\n' ' ')"

# last assistant text reply (snippet)
LAST_SNIP="$(jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="text") | .text' "$TRANSCRIPT" 2>/dev/null \
  | sed '/^[[:space:]]*$/d' | tail -1 | scrub | head -c 400)"

# no-spam gate: skip trivial turns (จบเร็วถ้า turn ไม่มีสาระ)
if [ "${TOOL_TOTAL:-0}" -eq 0 ] && [ "${ASK_COUNT:-0}" -lt 2 ]; then exit 0; fi

mkdir -p "$FLEETING" 2>/dev/null || exit 0
DATE="$(date +%Y-%m-%d)"
TS="$(date '+%Y-%m-%d %H:%M')"
SHORT="${SESSION:0:8}"
# capture-note filename: keep the ${ASSISTANT_TAG} slug consistent across all hooks
OUT="$FLEETING/${DATE}-${ASSISTANT_TAG}-${SHORT}.md"

{
  echo "---"
  echo "tags: [status/inbox, ${ASSISTANT_TAG}/capture]"
  echo "created: $TS"
  echo "session: $SESSION"
  echo "cwd: $CWD"
  echo "---"
  echo
  echo "# session capture — $TS"
  echo
  echo "**Project (cwd):** \`$CWD\`"
  echo
  echo "**Asks / requests (${ASK_COUNT}) — สิ่งที่ถาม/สั่งไป:**"
  printf '%s\n' "$ASKS" | sed '/^[[:space:]]*$/d' | cut -c1-200 | sed 's/^/- /' | head -15
  echo
  if [ -n "${CMDS}${SKILLS}" ]; then echo "**Commands/skills:** ${CMDS}${SKILLS}"; echo; fi
  if [ -n "$TOOLS" ]; then echo "**Tools (${TOOL_TOTAL}):** $TOOLS"; echo; fi
  if [ -n "$FILES" ]; then
    echo "**Files touched — ไฟล์ที่แตะ:**"
    printf '%s\n' "$FILES" | sed 's#^#- `#' | sed 's#$#`#'
    echo
  fi
  if [ -n "$LAST_SNIP" ]; then
    echo "**Last reply — สถานะล่าสุด:**"
    printf '%s\n' "$LAST_SNIP" | sed 's/^/> /'
  fi
} > "$OUT" 2>/dev/null

exit 0
