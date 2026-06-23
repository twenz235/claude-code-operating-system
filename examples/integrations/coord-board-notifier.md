# Optional integration: COORD board desktop notifier (macOS)

> **Optional add-on, macOS-only.** A `launchd` agent that fires a **desktop notification**
> when one chosen "alert role" changes its STATUS row on the COORD board. This pings a
> **human**; it is *not* the same thing as the per-role `board-wake.sh` watcher, which wakes
> **agent sessions**. Skip this entirely if you don't want desktop toasts. _ส่วนเสริม macOS — เด้ง noti หาคนเมื่อ STATUS ของ role ที่เลือกเปลี่ยน_

## Why only one "alert role"

With per-role self-wake (`coord/board-wake.sh`) in place, the agent sessions coordinate
themselves — they don't need a human to relay taps. So the human usually wants **one** quiet
channel, not a toast from every lane. The convention here: notify only when the **manager**
(the team tracker) changes STATUS; every other role self-wakes silently. Pick whichever
single role is your at-a-glance signal — `manager` is the default. _self-wake ทำให้ agent ประสานกันเอง → คนต้องการช่องเตือนเดียว (default = manager)_

## What it does

`launchd` watches the board file; on change, a small script diffs the STATUS rows and, if
your chosen alert role's row changed, shows a macOS notification via `osascript` (no
`terminal-notifier` install needed).

## The watch script

Save as e.g. `~/.config/coord-board-watch.sh` and `chmod +x`. Set the two values at top.

```sh
#!/usr/bin/env bash
# Notify (macOS desktop) when ALERT_ROLE's STATUS row on the COORD board changes.
BOARD="${COORD_BOARD:-$HOME/path/to/your/repo/coord/BOARD.md}"   # absolute path for launchd
ALERT_ROLE="${ALERT_ROLE:-manager}"                              # the single role to alert on
STATE="$HOME/.config/coord-board-watch.state"
[ -f "$BOARD" ] || exit 0

cur="$(sed -n '/^## STATUS/,/^## LOG/p' "$BOARD" | grep -E "^- ${ALERT_ROLE} ")"
[ -z "$cur" ] && exit 0
[ ! -f "$STATE" ] && { printf '%s\n' "$cur" > "$STATE"; exit 0; }   # first run: seed, no noti
prev="$(cat "$STATE" 2>/dev/null)"
[ "$cur" = "$prev" ] && exit 0                                       # unchanged → silent

# sanitize for osascript: strip the lane prefix + quote/backtick/backslash, truncate
msg="$(printf '%s' "$cur" | sed -E "s/^- ${ALERT_ROLE} +//; s/[*\`\"\\\\]//g" | cut -c1-200)"
osascript -e "display notification \"${msg}\" with title \"COORD board\" subtitle \"${ALERT_ROLE} changed\"" 2>/dev/null
printf '%s\n' "$cur" > "$STATE"
```

## The launchd plist

Save as `~/Library/LaunchAgents/com.example.coord-board-watch.plist` (rename the label to
your own reverse-DNS), then load it. `WatchPaths` fires on change; `StartInterval` is a
backup poll; `RunAtLoad` seeds the state file once.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.example.coord-board-watch</string>
  <key>ProgramArguments</key>
  <array><string>/bin/bash</string><string>/Users/you/.config/coord-board-watch.sh</string></array>
  <key>WatchPaths</key><array><string>/Users/you/path/to/your/repo/coord/BOARD.md</string></array>
  <key>StartInterval</key><integer>180</integer>
  <key>RunAtLoad</key><true/>
</dict></plist>
```

```sh
launchctl load -w ~/Library/LaunchAgents/com.example.coord-board-watch.plist   # enable
launchctl list | grep coord-board                                              # confirm running
launchctl unload -w ~/Library/LaunchAgents/com.example.coord-board-watch.plist # disable
```

## ⚠ Gotcha: Full Disk Access (TCC) — the silent-failure trap

If your board lives under `~/Desktop`, `~/Documents`, `~/Downloads`, etc., macOS TCC blocks
`/bin/bash` from reading it **until you grant Full Disk Access** to `/bin/bash`:

> **System Settings → Privacy & Security → Full Disk Access → add `/bin/bash`.**

Without it the watcher **fails silently** — its log fills with `Operation not permitted` and
no notification ever fires, even though `launchctl list` shows it "running." FDA can only be
granted via the GUI (Touch ID / password); `tccutil` / CLI can't grant it. You may also need
to allow notifications for the script the first time. Keep the board outside those protected
folders to avoid the requirement entirely. _ถ้า BOARD อยู่ใต้ ~/Desktop ฯลฯ ต้องให้ Full Disk Access แก่ /bin/bash ไม่งั้น watcher เงียบสนิท_

## If you don't use it

Default. Don't install the plist; the per-role `board-wake.sh` self-wake still works on its
own — it doesn't depend on this notifier. Optionally delete this file. _ไม่ใช้ก็ข้าม — self-wake ทำงานได้เองโดยไม่ต้องมี notifier นี้_
