---
name: quarterly-kpi
description: Quarterly KPI / bonus self-review against your KPI set, plus a DR drill and an architecture review. Self-review รายไตรมาส + DR drill + architecture review. Trigger at the end of each quarter.
---

# Quarterly KPI Review

Reference (adapt to your own docs): your engineering playbook (quarterly cadence + KPI/bonus criteria) + your DR-drill and architecture-review SOPs.

## Open the quarterly note
- Path: `{{VAULT}}/work/quarterly/<YYYY>-Q<n>.md`
- Template: `{{VAULT}}/templates/quarterly.md`

## Quarterly routine

### DR drill
- [ ] Restore the database from a real backup
- [ ] Measure RTO (Recovery Time Objective) and RPO (Recovery Point Objective)
- [ ] Record: date, RTO, RPO, pass/fail, what needs fixing
- [ ] If RTO exceeds target -> update the runbook before next quarter. RTO เกิน → แก้ runbook ก่อนไตรมาสหน้า

### Architecture review
- [ ] Re-read the whole handbook / architecture docs — still up to date?
- [ ] Existing ADRs — still correct?
- [ ] Use the `improve-architecture` skill to scan for deepening opportunities

### Secrets rotation
- [ ] Any key not rotated in >=90 days -> rotate it

### Dependency upgrade
- [ ] Minor/patch upgrades across every project

## KPI bonus self-review

For each criterion: self-score (1–5) + your strongest evidence. Use **your team's own KPI set** — the four below are one example.

**(a) Hiring-process quality**
- Rubric for every interview: yes/no
- Rejections documented with a reason: yes/no
- Hiring funnel doc updated: yes/no

**(b) Leadership quality**
- PR review 100% all quarter: yes/no
- Handbook updated on time: yes/no
- >=1 1-on-1 per sprint, every sprint: yes/no

**(c) Risk management**
- Flagged every overload to your {{OWNER_ROLE}} in advance: yes/no
- Estimate vs actual within an acceptable band: yes/no
- No surprise deadline misses: yes/no

**(d) Delivery**
- Uptime >=99.5% every month: yes/no
- Critical incidents = 0, or response <=4h: yes/no
- Sprint feature delivery on plan: yes/no

(These targets are examples — set your own.)

## Send to leadership
Use the `management-talk` skill -> format: Quarterly KPI Report.
