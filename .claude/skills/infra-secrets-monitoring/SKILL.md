---
name: infra-secrets-monitoring
description: >
  Tend cloud infra, rotate secrets, and respond to error-tracker alerts / uptime
  monitors. Trigger daily (check alerts), monthly (secrets), quarterly (large
  rotation).
  Glossary (TH): ดูแล infra / หมุน secret / ตอบ alert.
---

# Infrastructure, Secrets & Monitoring

References: your infrastructure/security SOP + your engineering playbook
(cadence) + your team charter (`docs/CHARTER.template.md`): security.

> Tooling note: the products below (error tracker, uptime monitor, dependency
> scanners) are **examples** — substitute your own.

## Daily routine
- [ ] Check your error tracker (e.g. Sentry) — new errors / spikes.
- [ ] Check your uptime monitor (e.g. UptimeRobot / Pingdom) — every project green?
- [ ] On a critical alert → escalate per your incident SOP / use the `diagnose` skill.

## Monthly routine (first week)
- [ ] Find secrets/API keys expiring ≤ 30 days → rotate before they expire.
- [ ] Check your dependency-scan tooling (e.g. Dependabot / npm audit / pip-audit)
      → patch or open a ticket.
- [ ] Access check: is 2FA on for everyone, and is production access correct?

## Quarterly routine
- [ ] Large secrets-rotation pass (any key not rotated in ≥ 90 days).
- [ ] Dependency upgrades (minor/patch).

## Secret-management rules (security per your charter)
- Store secrets in a secret manager (not in code / not in a committed `.env`).
- No production data on a local machine.
- 2FA on every important service.
- VPN for production access.
- Full-disk encryption on the work machine.

## Monitoring setup standards
- Error tracker: on every project.
- Uptime monitor: on every production endpoint.
- Alert channel: as agreed with the team.
- On-call: the tech lead is primary (escalate to {{OWNER_ROLE}} if not resolved within your incident SLA (example: 4h)).

## Incident response
1. Alert → read the stack trace → assess severity.
2. Critical (user-facing) → use the `diagnose` skill + respond within your incident SLA (example: 4h).
3. If resolved → consider a `post-mortem` if the RCA is worth documenting.
4. Notify {{OWNER_ROLE}} if production is down beyond your threshold (example: 15 min).
