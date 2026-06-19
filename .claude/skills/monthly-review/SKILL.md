---
name: monthly-review
description: Review the past month, run the monthly SOP routine, assess your KPI set, and prep the leadership report. Review รายเดือน + รัน SOP + ประเมิน KPI + เตรียมรายงาน. Trigger in the last week of the month.
---

# Monthly Review

Reference (adapt to your own docs): your engineering playbook (monthly cadence) + your team's monthly SOPs (infra, backup/DR, dependency, reporting, overload). Replace the SOP names below with yours.

## Open the monthly note
- Path: `{{VAULT}}/work/monthly/<YYYY-MM>.md`
- Template: `{{VAULT}}/templates/monthly.md`

(Example vault paths — point them at your own notes.)

## Monthly SOP routine (do every item)

### Infrastructure
- [ ] **Backup mirror** — `git clone --mirror` every repo to offsite {{OBJECT_STORE}} (e.g. S3 / GCS / B2) on day 1 of the month
- [ ] **Secrets** expiring in <=30 days -> rotate
- [ ] **Dependency security alerts** — run your dependency-scan tooling (e.g. Dependabot / `npm audit` / `pip-audit`)
- [ ] **Access/security check** with your {{OWNER_ROLE}} — 2FA, remote env, access list correct?

### People / enablement
- [ ] **Report to {{OWNER_ROLE}}**: who completed what training/curriculum, gaps observed
- [ ] Update / add curriculum if a process changed

### Documentation
- [ ] Update the onboarding guide if anyone new joined this month

## KPI self-assessment

For each criterion, answer: evidence you have + trend (improving / flat / declining). Use **your team's own KPI set** — the four below are one example.

- **(a) Hiring quality:** rubric used for every interview? rejections documented with a reason?
- **(b) Leadership quality:** PR review 100%? a 1-on-1 with everyone?
- **(c) Risk management:** did you flag overload to your {{OWNER_ROLE}} in advance? estimates accurate?
- **(d) Delivery:** uptime this month? critical errors? sprint velocity?

(Example targets some teams use: uptime >=99.5%, critical incidents = 0. Set your own.)

## Prep the leadership report
Use the `management-talk` skill -> format: Monthly Report.
