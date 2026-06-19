---
name: weekly-review
description: >
  OPTIONAL SAMPLE — adapt to your org or delete. Review the past week —
  velocity, PR-review coverage, time per project, a KPI snapshot, and a bus-
  factor check — then plan the week ahead. Trigger Friday afternoon. (Glossary (TH):
  รีวิวสัปดาห์ที่ผ่านมา ดู velocity, % PR review, เวลาต่อโปรเจกต์, KPI snapshot, bus factor แล้ววางแผนสัปดาห์หน้า)
---

# Weekly Review

> **OPTIONAL SAMPLE — adapt to your org or delete.** The cadence, KPI set, and
> SOP references below are an example. Replace them with your own playbook and
> SOPs. Reference: your weekly cadence doc + your team's KPI set + your team
> charter (`docs/CHARTER.template.md`) bus-factor principle.

## Open the weekly note (Glossary (TH): เปิดโน้ตรายสัปดาห์)
- Path: `{{VAULT}}/work/weekly/<YYYY-Www>.md`
- Template: `{{VAULT}}/templates/weekly.md`

## Review checklist

### SOP routines this week (replace with your own SOP catalog)
- [ ] Backlog grooming done? (your grooming SOP)
- [ ] 1-on-1 with everyone, ≥1 session each? (your mentorship SOP)
- [ ] Test coverage checked (example targets ≥80% backend / ≥70% frontend)? (your testing SOP)
- [ ] Architecture docs updated if anything changed? (your docs SOP)
- [ ] Time report aggregated? (your time-tracking SOP)

### KPI snapshot — example set (Glossary (TH): ตัวอย่างชุด KPI ของทีม)
> These four are an example of one team's KPI scheme. Swap in your own.
- **(a) Hiring:** any interviews this week? rubric recorded?
- **(b) Leadership:** PR review at 100%? handbook updated when it should be?
- **(c) Risk:** any overload signal? estimate vs actual drifting apart?
- **(d) Delivery:** sprint on track? uptime within target (e.g. ≥99.5%)? critical errors at 0?

### Bus-factor check (Glossary (TH): เช็ก bus factor)
Maps to the charter's bus-factor principle.
> "What knowledge lived only in my head this week?"

If any → write it into a runbook or handbook before next week (see the
`bus-factor-reminder` skill).

### Plan the week ahead (Glossary (TH): วางแผนสัปดาห์หน้า)
- Sprint commitment: still accurate?
- Top 3 priorities to do first?
- Meetings that need prep?

## If an overload signal appears
→ use the `workload-balance` + `management-talk` skills.
