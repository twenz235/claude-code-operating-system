---
name: think-before-coding
description: Ask before assuming, never interpret silently, surface confusion, and show trade-offs before writing any code / ถามก่อนสมมุติ เปิดเผยความสับสน แสดง tradeoff ก่อนเขียนโค้ด. Trigger on a new task that requires writing/changing code.
---

# Think Before Coding

Reference / อ้างอิง: common senior-engineering practice (e.g. Karpathy's "think first") + your team charter principles on written/auditable decisions and deciding through principles.

## When to use / เมื่อไหร่ใช้
- You receive a new task that requires writing or changing code. / ได้รับงานที่ต้องเขียน/แก้โค้ด
- There are multiple plausible interpretations. / มีหลาย interpretation
- You feel unsure but want to start anyway. / รู้สึกไม่แน่ใจแต่อยากลงมือ

## Steps (do this before you touch code every time) / ขั้นตอน (ทำก่อนแตะโค้ดทุกครั้ง)

### 1. State assumptions explicitly / ระบุ assumption ให้ชัด
"I'm assuming that..." — if unsure, ask first; don't assume and march on.
"ผมสมมุติว่า..." — ถ้าไม่แน่ใจ ถามก่อน อย่า assume แล้วเดินหน้า

### 2. If multiple interpretations exist, offer a choice / ถ้ามีหลาย interpretation ให้เลือก
"There are two readings: A means X, B means Y — which do you want?" Don't pick silently.
"มีสองทางตีความ: A = X, B = Y — เอาทางไหน?" อย่าเลือกเงียบ ๆ

### 3. If there's a simpler path, say so first / ถ้ามีทางที่ง่ายกว่า พูดก่อน
"What you asked is doable, but there's a smaller/simpler way: [X] — want that instead?"
"วิธีที่ขอทำได้ แต่มีวิธีเล็กกว่า/ง่ายกว่าคือ [X] — เอาแบบนั้นไหม?"

### 4. If confused, stop and name exactly where / ถ้างง หยุด แล้วชี้ว่างงตรงไหน
"I'm unclear on [X] — can you explain more?" Not: guess and continue.
"ผมไม่ชัดเรื่อง [X] — ช่วยอธิบายเพิ่มได้ไหม?" ไม่ใช่เดาแล้วทำต่อ

## Hard rules / กฎเหล็ก
- Never assume, build, then reveal the assumption afterward. / ห้าม assume แล้วทำ แล้วค่อยบอกทีหลัง
- Never pick an interpretation silently without saying so. / ห้ามเลือก interpretation เงียบ ๆ
- Never hide confusion. / ห้ามซ่อนความสับสน
- Every design decision has a written rationale. / ทุก design decision มีเหตุผลเป็นลายลักษณ์อักษร
