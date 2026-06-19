---
name: backend-api-contract
description: Contract-first OpenAPI for new APIs or contract changes — write the spec before code, always; tie it to test coverage (e.g. ≥80% backend). OpenAPI contract-first ทำ spec ก่อน code ตลอด. Trigger when starting a new API or changing an existing endpoint.
---

# Backend & API Contract-First

Reference / อ้างอิง: your team's job-description / responsibilities doc + your engineering playbook (backend SOP).

## When to use / เมื่อไหร่ใช้
- Building a new API endpoint. / เริ่มสร้าง API endpoint ใหม่
- Changing an existing request/response schema. / แก้ request/response schema ที่มีอยู่
- Adding/removing a field that a client consumes. / เพิ่ม/ลบ field ที่ client consume

## Contract-First steps / ขั้นตอน Contract-First

### 1. Write the OpenAPI spec first (do NOT write code first)
เขียน OpenAPI spec ก่อน ห้ามเขียน code ก่อน:
- Update `openapi.yaml` / `openapi.json`.
- Specify: path, method, request body schema, response schemas (including errors). / ระบุ path, method, request/response รวม error
- Specify the auth requirement (e.g. JWT scope / RBAC role). / ระบุ auth requirement

### 2. Review the spec with the team (before implementing)
Review spec กับทีม ก่อน implement:
- The frontend dev confirms they can consume the response. / Frontend dev confirm รับ response ได้
- If there is a breaking change → version the API or deprecate properly. / ถ้ามี breaking change version API หรือ deprecate อย่างถูกต้อง

### 3. Implement to the spec / Implement ตาม spec
- Validate the request at the first layer, always (serializer / schema validation). / Validate request ที่ layer แรกเสมอ
- Return errors in the format the spec defines (do not improvise). / Return error format ตาม spec ไม่ improvise
- Never return an undocumented field. / ห้าม return undocumented field

### 4. Test coverage (e.g. ≥80% backend) / Test coverage ตามเกณฑ์ทีม
- Unit test: serializer/schema validation, business logic.
- Integration test: the real API endpoint (not just units). / Integration test endpoint จริง
- Cases to cover: happy path + validation error + auth error + edge case. / รวม happy path + validation + auth + edge case

### 5. Pre-merge checks / ตรวจก่อน merge
- [ ] OpenAPI spec updated. / OpenAPI spec อัปเดตแล้ว
- [ ] Spec matches the implementation (no drift). / Spec ตรงกับ implementation ไม่ drift
- [ ] Coverage meets the team threshold. / Coverage ถึงเกณฑ์
- [ ] Breaking change called out clearly in the PR description. / Breaking change ระบุชัดใน PR description

## Example stack (yours may differ) / สแต็กตัวอย่าง
- A web framework with an OpenAPI generator (e.g. Django REST Framework + drf-spectacular, FastAPI, NestJS). / web framework + OpenAPI generator
- A relational DB + cache + task queue (e.g. PostgreSQL + Redis + a worker queue). / DB + cache + queue
- Auth: JWT + RBAC.

## Charter ties / ธรรมนูญ
- Changes go through PRs (written and auditable). / spec เปลี่ยน ผ่าน PR เท่านั้น
- Do not cut tests to hit a deadline (quality > speed). / ห้ามตัด test เพื่อกำหนดเวลา
