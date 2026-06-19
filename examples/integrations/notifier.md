# Optional integration: desktop / phone notifier

> **Optional add-on.** Wire a `Notification` hook to a small script that pings you (desktop toast, phone push, chat message, …) when the agent needs your input or finishes a task. The operating-system core does **not** depend on it. Include this only if you want it; otherwise skip it (see "If you don't use a notifier" below). _ส่วนเสริม ไม่ใช่แกนหลัก — ใส่เฉพาะถ้าอยากให้แจ้งเตือน._

## What it does
The harness runs your script on the `Notification` event and passes it the notification text. The script does whatever you want with it — show a system notification, send a push to your phone, post to a chat channel, etc.

> **Host-specific.** The actual command depends on your OS and which notifier you use, so the template ships **no** notifier wired up — you provide the script. _ผูกกับเครื่อง/OS ของคุณ — คุณเขียนสคริปต์เอง template ไม่ผูกตัวจริงมาให้._

## Example: wire a `Notification` hook
Add a `Notification` entry under `hooks` in `~/.claude/settings.json`, pointing at your own script:

```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/notify.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

A minimal `~/.claude/hooks/notify.sh` (make it executable with `chmod +x`) reads the event from stdin and forwards the message to whatever notifier you have installed:

```sh
#!/bin/sh
# Read the hook payload (JSON on stdin) and forward the message text to your notifier.
# อ่าน payload จาก stdin แล้วส่งข้อความต่อไปยัง notifier ที่คุณติดตั้งไว้.
message=$(cat)
# Replace the next line with your own OS / push / chat command:
#   - desktop toast, phone push, or a post to a chat channel
your-notifier-command "$message"
```

Swap `your-notifier-command` for the real tool on your machine. Keep secrets (tokens, webhook URLs) out of the committed file — read them from the environment or a gitignored local config.

## If you don't use a notifier
This is the default for the template — nothing to do, since the core ships no `Notification` hook.
1. Don't add a `Notification` entry to `~/.claude/settings.json`. _ไม่ต้องเพิ่ม Notification hook ใน settings.json._
2. Optionally delete this file. _ลบไฟล์นี้ทิ้งได้ถ้าไม่ใช้._
