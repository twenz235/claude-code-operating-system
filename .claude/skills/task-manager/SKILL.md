---
name: task-manager
description: Maintain the backlog in your issue tracker — weekly grooming, onboarding the team into the tracker, and tracker MCP/CLI integration. ดูแล backlog + grooming + onboard ทีม. Trigger weekly (grooming) and when onboarding someone new.
---

# Task Manager

Reference (adapt to your own docs): your team's responsibilities doc + your engineering playbook. The examples below assume an issue tracker ({{TRACKER}}, e.g. Linear / Jira / GitHub Issues) driven via its MCP/CLI tools — swap in whatever you use.

## Weekly backlog grooming (e.g. Monday)

Checklist:
- [ ] Every story/issue has a clear description?
- [ ] Priority updated to match business need?
- [ ] Large stories broken into small tasks?
- [ ] Estimate (story point / time) filled in?
- [ ] Dependencies identified?
- [ ] Sprint goal still on target?

## Onboarding a new teammate into the tracker
- Create an account + assign them to a team
- Explain the workflow: inbox -> in progress -> in review -> done
- Point out the label convention you use
- Make sure any required agreements (e.g. NDA / IP assignment) are signed **before** granting access — a charter principle here is *written/auditable*. ทำเป็นลายลักษณ์ก่อนให้ access

## Tracker best practices
- **Every task has an owner** — no orphan tasks. ทุก task มี owner
- **Update status in real time** — don't batch-update at the end of the sprint
- **Record decisions in the ticket** — not only in team chat (keeps the decision auditable). บันทึก decision ใน ticket ไม่ใช่แค่แชต
- **Time tracking**: log time per project (use your time tracker, e.g. Toggl)

## ADR for the task manager
If you have an ADR for the tracker choice, link it here — otherwise see your ADR log at `{{VAULT}}/reference/adrs/` for how the tool was chosen.
