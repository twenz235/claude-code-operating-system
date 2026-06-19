---
name: backup-dr
description: Daily backups, monthly git mirror, quarterly DR drill against RTO/RPO targets. Backup รายวัน, git mirror รายเดือน, DR drill รายไตรมาส. Trigger monthly (mirror) and quarterly (drill).
---

# Backup and Disaster Recovery

Reference / อ้างอิง: your team's job-description / responsibilities doc + your engineering playbook (operations cadence) + charter principle "no single irreplaceable person" (bus factor).

## Backup Strategy / กลยุทธ์ backup

### Database (daily — automated) / ฐานข้อมูล รายวัน อัตโนมัติ
- Daily automated backup (e.g. a logical DB dump). / Daily automated backup
- Retention: ≥7 days. / Retention ≥7 วัน
- Verify: monthly restore test. / Verify ด้วย restore test รายเดือน

### Git Mirror (monthly — manual) / Git mirror รายเดือน
On the 1st of the month / วันที่ 1 ของเดือน:
```bash
git clone --mirror <repo-url> <backup-path>
# push to a private {{OBJECT_STORE}} bucket (e.g. S3 / GCS / B2)
```
- Every repo in scope (the product, supporting services, the handbook). / ทุก repo ที่อยู่ในขอบเขต
- The {{OWNER_ROLE}} (manager / decision-maker / ops lead) holds root access to backup storage (bus-factor principle). / {{OWNER_ROLE}} มี root access ไป backup storage

## DR Drill (quarterly) / DR drill รายไตรมาส
- Rehearse restoring the database from a real backup. / ฝึกซ้อม restore database จาก backup จริง
- Measure RTO (Recovery Time Objective) and RPO (Recovery Point Objective). / วัด RTO และ RPO
- Record results in: `{{VAULT}}/work/quarterly/` using the `quarterly.md` template. / บันทึกผลใน quarterly
- If RTO exceeds the target → update the runbook + fix the process. / ถ้า RTO เกินเป้า update runbook + แก้ process

## Runbook Requirements (bus-factor principle) / runbook ต้องทำตามได้โดยคนแทน
A runbook must be followable by a "stand-in", not just the [tech lead]. / runbook อ่านแล้วทำตามได้โดยคนแทน
- Document the restore procedure step by step. / Document restore ทีละ step
- List dependencies (tools, access, credentials needed). / ระบุ dependency tool/access/credential
- Test that "someone who does not know" can follow it (quarterly drill). / test ว่าคนไม่รู้ทำตามได้จริงไหม

## What the {{OWNER_ROLE}} must always be able to access (bus-factor principle)
สิ่งที่ {{OWNER_ROLE}} ต้อง access ได้เสมอ:
- Root/admin access to every cloud service. / root/admin ทุก cloud service
- Backup storage access. / backup storage access
- Emergency contacts for each vendor. / emergency contact ของ vendor
