---
name: daily-startup
description: Start the workday cleanly — check error/uptime monitors, prep for standup, open the daily note, and set today's todos. Glossary (TH) — เริ่มวันให้ครบ. Trigger at the start of the workday.
---

# Daily Startup

Reference: your team's daily cadence (engineering playbook) + your SOPs for monitoring and standup.

## Routine (~5 minutes)

### 1. Check error tracker & uptime
- Open your error tracker (e.g. Sentry) — any new critical errors?
- Open your uptime monitor (e.g. UptimeRobot / Pingdom) — is every project green?
- If there's an alert → handle it before standup (use the `diagnose` skill).

### 2. Check the PR queue
- Open your code host — how many PRs are waiting?
- Anything open longer than 1 working day → prioritize it today.

### 3. Open today's daily note
Path: `{{VAULT}}/work/daily/<YYYY-MM-DD>.md`
Create it from the template: `{{VAULT}}/templates/daily.md`

> Glossary (TH): เปิด daily note ของวันนี้จาก template.

### 4. Set today's todos
- Carry over anything unfinished from yesterday.
- Pull tasks from your issue tracker's sprint board.
- Mark priority (what must be done before you log off).

### 5. Standup prep
Prepare to answer 3 questions:
1. What did you do yesterday?
2. What will you do today?
3. Any blockers?

### 6. Start time tracking
Start your time tracker (e.g. Toggl, or your issue tracker's timer) for the first task.
