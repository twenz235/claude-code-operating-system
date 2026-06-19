---
name: review-proposals
description: Open the pending proposals in the proposals dir → review them one at a time with the user → apply only the approved ones. This is the ONLY place {{ASSISTANT}} is allowed to edit its own skills / CLAUDE.md / settings. รีวิวข้อเสนออัพเกรดทีละข้อแล้ว apply เฉพาะที่อนุมัติ. Trigger when proposals are pending, or when the user wants to inspect {{ASSISTANT}}'s upgrade proposals.
---

# /review-proposals — Decide on {{ASSISTANT}}'s self-upgrade proposals (the approval gate)

**Purpose (EN):** This is the single chokepoint where a change to {{ASSISTANT}}'s skill / CLAUDE.md / settings / agents can be applied — and only after the user approves it, one item at a time.
**สรุปไทย:** นี่คือ **จุดเดียว** ที่การแก้ skill / CLAUDE.md / settings / agent ของ {{ASSISTANT}} จะถูก apply ได้ และต้องผ่านการกดอนุมัติของผู้ใช้ทีละข้อ

Reference: the "self-upgrade rules" section of your `~/.claude/CLAUDE.md` + your team charter principle that *everything is written down and auditable* (see `docs/CHARTER.template.md`).

## Steps

1. **List the pending proposals** — `{{VAULT}}/agent/proposals/*.md` (excluding `README.md` and the `applied/` folder). If there are none → tell the user there's nothing pending, and stop.

2. **Review one at a time** — open each proposal and show the user, in plain language (Thai or the user's language):
   > **Problem** / **Evidence** / **Proposal** / **Diff to apply** (which file, what changes)

3. **Ask the user per item:** approve / reject / edit-first (use AskUserQuestion or just ask directly). Do not batch them, and do not apply anything before you have an answer.

4. **Apply only what was approved:**
   - Edit the target file per the diff (a skill / `~/.claude/CLAUDE.md` / `~/.claude/settings.json` / an agent, etc.).
   - **Approved `## Proposed memory additions`** (these come from unattended curate) → write the fact into the project's memory dir + update `MEMORY.md` (this is a writable fact). **Always verify the fact is correct before writing** — unattended mode has proposed a wrong fact before.
   - If you touch `settings.json` → always validate the JSON afterward with `jq -e .`
   - If you touch a skill whose source lives elsewhere (e.g. a mirrored `<source-skill-repo>`) → edit it at the source, not the mirror, per your vault's read-only-mirror convention.

5. **Close out each proposal file:**
   - Update each item's `Status:` to `approved` / `rejected` / `edited` with a short reason.
   - Move the file to `{{VAULT}}/agent/proposals/applied/<YYYY-MM-DD>.md`.
   - Append a line to `{{VAULT}}/.sync/{{ASSISTANT}}.log`: `<datetime> review-proposals — applied N / rejected M (proposal <date>)`.
   - **Retention sweep (interactive):** after closing the proposals → `mkdir -p "{{VAULT}}/inbox/fleeting/.curated"` then `mv` every `*-{{ASSISTANT}}-*.md` in `{{VAULT}}/inbox/fleeting/` that is **not the current session** into `.curated/` (archive, don't delete). This keeps the fleeting inbox from bloating even when nobody runs `/curate` (its auto-run is sandboxed away from the inbox).

## Iron rules (กติกาเหล็ก)
- **Interactive only** — never run this under `claude -p` / headless (a human must press approve).
- **Not approved = not touched** — leave the original exactly as it was.
- One proposal = one decision; don't lump several into a single yes/no.
- Every apply must trace back to a proposal the user approved (auditable).
