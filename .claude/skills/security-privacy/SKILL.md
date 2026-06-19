---
name: security-privacy
description: Run the technical security & privacy review — OWASP, RBAC, and data-protection controls — for any feature that touches personal data (PII). Does not cover the formal DPO / legal-opinion role. Glossary (TH): รีวิว security + privacy เชิงเทคนิคสำหรับ feature ที่แตะ PII. Trigger when a new feature touches personal data, or a code review raises a security concern.
---

# Security Technical & Privacy

Reference: your team's job-description / responsibilities doc (security duties) + your engineering playbook ("what the tech lead does *not* own") + your team charter (security and data-protection principles).

> Data-protection framing: this skill is written against a generic personal-data regime (GDPR / PDPA / CCPA — pick yours). Examples below use one such regime; substitute your own legal requirements.

## In scope for the [tech lead] (you do this)
- **Technical data-protection controls**: encryption, RBAC, audit logs, data-retention enforcement in code.
- **OWASP Top 10 review** for code changes.
- **External-LLM data control**: do not send production PII to any external AI/LLM without going through policy.

## Out of scope (escalate, don't do yourself)
- The formal DPO role under your data-protection regime → escalate to a separate security/compliance reviewer or an external DPO (if applicable).
- Legal opinions about data-protection law → do not give a legal opinion.

## OWASP Security Checklist (per feature)

### Authentication & Authorization
- [ ] Token / session expiry is reasonable (e.g. JWT TTL)?
- [ ] RBAC is correct — a user's role grants no more permission than it should?
- [ ] No insecure direct object reference (IDOR)?

### Input Validation
- [ ] Validate every input coming from the user (never trust the client).
- [ ] SQL injection — using an ORM / parameterized queries?
- [ ] XSS — output is escaped?

### Data Protection (PII)
- [ ] Encrypt sensitive data at rest.
- [ ] Audit-log every access/modify of PII.
- [ ] Data retention: delete data when it expires.
- [ ] Never log PII in plain text.

### External LLM / AI
- [ ] Do not send production PII directly to an external LLM/AI.
- [ ] Any prompt used against an LLM is reviewed before it reaches production.

## Monthly security routine
- Confirm with your manager / ops lead: 2FA, remote-environment access, the production-access list.
- Check dependency security alerts with your dependency-scan tooling.

## Escalation
- A critical vulnerability found in code review → block the merge + notify a separate security/compliance reviewer.
- A breach or suspected breach → notify your manager / decision-maker immediately + document the timeline.
