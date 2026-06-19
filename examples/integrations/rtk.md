# Optional integration: rtk (Rust Token Killer)

> **Optional add-on.** rtk is a third-party CLI proxy that token-optimizes routine dev operations (claimed 60–90% savings on read-heavy commands). The operating-system core does **not** depend on it. Include this file only if you've installed rtk and want it; otherwise skip it (see "If you don't use rtk" below). _ส่วนเสริม ไม่ใช่แกนหลัก — ใส่เฉพาะถ้าติดตั้งและอยากใช้._

## What it does
A wrapper around common CLI commands that strips noisy output before it reaches the model, so dev operations cost fewer tokens.

## Meta commands (call `rtk` directly)

```bash
rtk gain              # Show token-savings analytics
rtk gain --history    # Command usage history with savings
rtk discover          # Analyze Claude Code history for missed opportunities
rtk proxy <cmd>       # Execute a raw command without filtering (for debugging)
```

## Install verification

```bash
rtk --version         # Should print: rtk X.Y.Z
rtk gain              # Should work (not "command not found")
which rtk             # Verify you're calling the right binary
```

> **Name collision:** if `rtk gain` fails, you may have a different project also named `rtk` (e.g. `reachingforthejack/rtk`, "Rust Type Kit") on your PATH. Check `which rtk`. _ระวังชื่อชนกับ rtk อีกตัว — เช็ค `which rtk`._

## Hook-based usage
When wired up, a Claude Code `PreToolUse` hook transparently rewrites eligible commands, e.g. `git status` → `rtk git status`, with no token overhead in the prompt. See your harness hook docs for how to register a `PreToolUse` command-rewrite hook pointing at rtk.

## If you don't use rtk
This is the default for the template — nothing to do, since the core `CLAUDE.md` only references rtk as an _optional_ integration. To be fully clean:
1. **Remove the `PreToolUse` rewrite hook** for rtk from `~/.claude/settings.json` (if you ever added one). _ลบ PreToolUse hook ของ rtk ออกจาก settings.json._
2. **Remove any `@`-include of this file** (or of an rtk reference doc) from your `CLAUDE.md`. The template ships rtk as a standalone example and does **not** `@`-include it, so there's usually nothing to remove. _ลบ `@`-include ของไฟล์นี้ออกจาก CLAUDE.md ถ้ามี._
3. Optionally delete this file.
