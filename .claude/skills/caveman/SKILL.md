---
name: caveman
description: Token-compressed mode for cheap loops — cut verbosity ~75%, use keywords + bullets, no prose. โหมดบีบ token สำหรับ loop ราคาถูก. Trigger when running a long loop, context is near full, or you want to save tokens.
---

# Caveman Mode

Reference / อ้างอิง: Matt Pocock's `caveman` pattern (optional public methodology credit) — maximize signal, cut noise. / เน้น signal ตัด noise

## When to use / เมื่อไหร่ใช้

- Running long loops (e.g. auto-fixing tests, a vendor migration) where verbosity is expensive. / loop ยาว ๆ ที่ verbosity ทำให้แพง
- Context window near full — compact the prose before continuing. / context ใกล้เต็ม ต้อง compact ก่อน continue
- Mechanical work that does not need a reason every time. / งาน mechanical ที่ไม่ต้องอธิบายทุกครั้ง
- The user says "quick" / "short" / "no explanation". / User บอก "เร็ว ๆ" / "สั้น ๆ" / "ไม่ต้องอธิบาย"

## Caveman rules / กฎ Caveman

1. **No prose** — drop long sentences; use bullets/keywords. / เลิกประโยคยาว
2. **No greetings** — no "Sure", "I'll", "Let me". / ไม่มีคำทักทาย
3. **No summaries** — don't recap what you just did (the user sees the diff). / ไม่สรุปท้าย
4. **No hedging** — no "I think", "perhaps", "might be". / ไม่มีคำกั๊ก
5. **Verbs first** — "Edit file X line 10. Run test Y. Output: pass."
6. **Numbers > words** — "3 errors", not "several errors". / ตัวเลข ไม่ใช่คำ
7. **Code over English** — show the diff/command instead of explaining. / โชว์ diff/command แทนอธิบาย

## Output example / Output ตัวอย่าง

Normal / ปกติ:
> I've taken a look at the file and I noticed that there's an issue with the import statement. Let me fix it for you.

Caveman:
> `models.py:3` — import wrong path. Fixed.

## Exit conditions / ออกจากโหมด

Leave caveman mode when / ออกจาก caveman mode เมื่อ:
- The user asks a design / trade-off question (needs prose). / User ถามคำถาม design / tradeoff
- You hit an error the user must decide on. / เจอ error ที่ต้องให้ user ตัดสินใจ
- The loop is done → return to moderate prose. / loop เสร็จ กลับ prose พอประมาณ

## Toggle / คำสั่ง toggle

- Enter / เริ่ม: "go caveman" / "/caveman" / "short".
- Exit / ออก: "normal mode" / "explain".
