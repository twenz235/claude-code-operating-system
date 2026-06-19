---
name: cicd-deploy
description: CI/CD pipeline management and production deployment behind a manual approval gate only — never skip a gate. จัดการ CI/CD และ deploy production ผ่าน manual approval เท่านั้น ห้ามตัด gate. Trigger when changing the pipeline or deploying to production.
---

# CI/CD and Deployment

Reference / อ้างอิง: your team's job-description / responsibilities doc + your engineering playbook (deployment SOP) + charter principle "quality > speed".

## Pipeline Requirements (mandatory) / pipeline ต้องมี

Every project must have / ทุก project ต้องมี:
1. **Lint** — code style check.
2. **Type check** — static analysis.
3. **Unit tests** — with a coverage report.
4. **Integration tests**.
5. **Security scan** — dependency audit (your dependency-scan tooling, e.g. npm audit / pip-audit) + SAST.
6. **Build** — the artifact builds.
7. **Manual approval gate** before production.

**Do NOT skip any gate to hit a deadline (charter: quality > speed — inviolable).** / ห้าม skip gate ใดเพื่อกำหนดเวลา

## Environments (minimum 2) / Environment ขั้นต่ำ 2
- **Staging/Preview** — auto-deploy from the main/dev branch. / auto-deploy จาก main/dev
- **Production** — manual approval by the [tech lead] only. / manual approval โดย [tech lead] เท่านั้น

## Pre-deploy checklist (production) / checklist ก่อน deploy production
- [ ] Staging deploy passed + smoke test passed. / staging deploy ผ่าน + smoke test ผ่าน
- [ ] Is the database migration backward compatible? (if any) / migration backward compatible ไหม?
- [ ] Are all environment variables present? (see your secrets SOP) / env vars ครบ?
- [ ] What is the rollback plan? / rollback plan คืออะไร?
- [ ] Monitoring alerts set up (your error tracker + uptime monitor, e.g. Sentry + UptimeRobot/Pingdom)? / ตั้ง alert แล้ว?
- [ ] Deploy during a quiet window (if a critical service). / deploy ช่วงเวลาเงียบ ถ้า critical

## Post-deploy
- [ ] No new error surge in your error tracker. / error tracker ไม่มี surge ใหม่
- [ ] Uptime monitor still green. / uptime monitor ยัง green
- [ ] On error → roll back immediately, do not patch in production. / ถ้า error rollback ทันที อย่า patch-in-prod

## ADR for pipeline changes / ADR สำหรับเปลี่ยน pipeline
A change to CI/CD architecture → needs an ADR before commit. / เปลี่ยน CI/CD architecture ต้องมี ADR ก่อน commit
Template: `{{VAULT}}/templates/adr.md`

## Example stack (yours may differ) / สแต็กตัวอย่าง
- A CI runner (e.g. GitHub Actions). / CI runner
- Your app stack (e.g. a web framework + frontend + mobile). / app stack
- Cloud: see your secrets/infra SOP. / Cloud ดู SOP secrets/infra
