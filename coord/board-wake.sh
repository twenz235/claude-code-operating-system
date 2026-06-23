#!/usr/bin/env bash
# board-wake.sh <role> [poll] — per-role SELF-WAKE watcher for the coord BOARD.
#
# Watches the shared board and wakes *this role's* session only on a change that is BOTH
# meaningful AND relevant to the role. This is what lets a live session wake ITSELF when
# work lands — no human "go look at the board" tap required for already-running sessions.
#
# How it plugs in: each role command launches this at boot with run_in_background. The
# script BLOCKS until a relevant change, then EXITS + prints the diff. A harness that
# re-invokes the agent when a backgrounded process exits then hands the diff back to the
# session, which reacts and RELAUNCHES the watcher (loop). Without such a harness, fall
# back to {{HOST}} relaying the tap manually.
#
#   role: manager | design | security | worker-<n> | qa-<n>   (any lane id on the board)
#     - manager  = wake on EVERY meaningful change (it tracks the whole team)
#     - any other = wake only when the change targets the role:
#         "→ <role>" · "to=<role|group|all>" · "→ all" · or the role's own STATUS row changed
#       group = the role with its trailing instance number stripped (qa-2 → qa, worker-1 → worker)
#   ALWAYS skips checkbox-only flips ([ ]<->[x]) — a bare tick is an ack, not new work.
#
# BOARD path:  $COORD_BOARD if set, else ./coord/BOARD.md  (run from your repo root).
# Portable across macOS (md5) and Linux (md5sum); uses fswatch if present, else polls.
set -u
ROLE="${1:?usage: board-wake.sh <role>   e.g. manager · worker-1 · qa-2 · design · security}"
GROUP="$(printf '%s' "$ROLE" | sed -E 's/-?[0-9]+$//')"      # qa-2 -> qa, worker-1 -> worker
BOARD="${COORD_BOARD:-./coord/BOARD.md}"
POLL="${2:-5}"
[ -f "$BOARD" ] || { echo "no board file: $BOARD (set COORD_BOARD or run from your repo root)"; exit 0; }

_md5(){ if command -v md5 >/dev/null 2>&1; then md5; else md5sum | cut -d' ' -f1; fi; }   # macOS | Linux
BASE="${TMPDIR:-/tmp}/board-wake-$(printf '%s' "$BOARD" | _md5 | cut -c1-8)-${ROLE}.base"  # per repo+role
norm(){ sed 's/\[[ xX]\]//g' "$1" 2>/dev/null | _md5; }                  # hash ignoring checkbox state
statuslines(){ sed -n '/^## STATUS/,/^## LOG/p' "$1" 2>/dev/null | grep -E '^- [a-z]'; }
filehash(){ _md5 < "$1" 2>/dev/null; }

cp "$BOARD" "$BASE"
base_norm="$(norm "$BASE")"
last_hash="$(filehash "$BOARD")"
HF=0; command -v fswatch >/dev/null 2>&1 && HF=1

while :; do
  if [ "$HF" = 1 ]; then fswatch -1 "$BOARD" >/dev/null 2>&1; else sleep "$POLL"; fi
  cur_hash="$(filehash "$BOARD")"; [ "$cur_hash" = "$last_hash" ] && continue
  last_hash="$cur_hash"
  [ "$(norm "$BOARD")" = "$base_norm" ] && continue                      # checkbox-only flip -> skip
  [ "$ROLE" = "manager" ] && break                                       # manager = every meaningful change
  added="$(diff "$BASE" "$BOARD" 2>/dev/null | grep -E '^>')"
  printf '%s' "$added" | grep -qE "(→[[:space:]]*(${ROLE}|${GROUP}|all)\b|to=(${ROLE}|${GROUP}|all)\b|/all\b)" && break
  diff <(statuslines "$BASE") <(statuslines "$BOARD") 2>/dev/null | grep -qE "^[<>] - ${ROLE} " && break
  # meaningful, but not about this role -> keep watching (don't wake)
done

echo "=== BOARD changed (relevant to ${ROLE}) ==="
echo "--- STATUS lines changed ---"
diff <(statuslines "$BASE") <(statuslines "$BOARD") 2>/dev/null | grep -E '^>' | sed 's/^> //' | cut -c1-300 | head -20
echo "--- new LOG lines ---"
diff "$BASE" "$BOARD" 2>/dev/null | grep -E '^>' | sed 's/^> //' | grep -vE '^[[:space:]]*$' | tail -25 | cut -c1-300
echo "=== /diff ==="
