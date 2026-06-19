# LLM translation: the "strip reasoning" trap

> **Sample learned-lesson note.** This is an example of the capture format used in this operating system: a short, durable note distilled from a real debugging session — _Problem → Solution → Key takeaway_ — so future-you (or the assistant) can reuse the lesson without re-deriving it. Genericize provenance; keep the lesson. _ตัวอย่างโน้ต learned-lesson: Problem → Solution → Key takeaway, จดบทเรียนให้ reuse ได้._

**Learned from:** an LLM translation pipeline (provenance genericized).

## Problem
Some LLMs ignore "output only X" prompts and leak their reasoning into the translation response. _โมเดลบางตัวไม่ฟัง "output only X" แล้วปนเหตุผลเข้ามาในคำแปล._

## Solution: 3-layer defense

### 1. System prompt (strict role)
```python
SYSTEM_PROMPT = (
    "You are a pure translation engine. Your ONLY job is to output "
    "the translated text. Do NOT explain, analyze, compare options, "
    "add notes, or write anything except the exact translation."
)
```

### 2. Post-processing `_strip_reasoning()`
- Strip `<think>.*?</think>` / `<reasoning>.*?</reasoning>` (regex, DOTALL).
- **Unclosed tags:** `if '<think>' in text and '</think>' not in text: text = text.split('<think>')[0]`.
- Filter lines containing reasoning markers: `"I'll go with"`, `"Let me"`, `"Here are"`, `"option"`, `"formal"`, `"natural"`, `"common"`, `"literally"`, `"meaning"`.
- For non-English targets: find the last line containing target-script characters (by Unicode range) and extract only the script portion.

### 3. Token limit
- `max_tokens=1024`; join with `\n`, not `' '` (preserve paragraphs).

## Key takeaway
**Never trust "only output X" prompts alone — always add post-processing.** _อย่าเชื่อแค่ prompt "only output X" — ใส่ post-processing เสมอ._

---
_Note: the markers and Unicode-range logic above are tuned to one language pair; treat them as a starting template, not a drop-in. The structural lesson (prompt + deterministic post-process + token cap) is the reusable part._
