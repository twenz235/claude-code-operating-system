# BOARD — coord multi-agent coordination

> Shared file of all sessions: **manager · design · worker · qa · security**.
> The board is a **file-as-message-bus**: each session reads this file, finds entries
> addressed to it, acts, and writes its reply/status back. No session talks to another
> directly — {{HOST}} (the human courier) relays "check the board" / `/coord` between
> sessions when needed.
> ภาษา: English-primary, Thai gloss ได้ (บอร์ดเป็น 2 ภาษาได้).
> All timestamps = **{{TIMEZONE}}** (declare once here; never repeat per-entry).

## How to use (read once)

1. Trigger `/coord` (or "check the board") = read this file → find entries where
   `to=` you (or `all`) that are still `[ ]` (unticked) → handle them.
2. **Accept work** = tick `[x]` on the entry head.
3. **Reply / report** = add a continuation line directly under the entry:
   `↳ [<me>] <MM-DD HH:MM> · <TYPE> · <text>` (the `↳` reply stays nested under the
   entry it answers — do not start a new top-level entry for a reply).
4. **Send new work** = append a fresh entry at the bottom of LOG (read the latest entry
   first to avoid a write race) + update your own row in STATUS.
5. **Entry-head format:**
   `### [ ] <MM-DD HH:MM> · <from> → <to> · <TYPE> · <ref>`
   - `[ ]` open / `[x]` accepted-or-done
   - `<from>`/`<to>` = a role (`manager`/`design`/`worker-<n>`/`qa-<n>`/`security`/`all`)
   - `<ref>` = a tracker card id `<CARD-ID>` (e.g. `<CARD-ID>`) or a short slug
6. **TYPE vocab:**
   `TRIAGE` · `ASSIGN` · `HANDOFF` · `QUESTION` · `ANSWER` · `DONE` · `BLOCKED` · `FYI`
7. **Who opens which card** (card TYPES = Feature / Bug / Improvement, in {{TRACKER}}):
   - **design → Feature**
   - **qa → Bug / Improvement**
   - **security → Bug**
   - **manager → does not open cards** — prioritizes / assigns / promotes only.
8. **Handoff rule:** when one role finishes and another must continue (e.g. worker → qa
   to verify), the finisher writes a `HANDOFF` entry naming the target lane + the ref +
   what to check, then ticks its own work `[x]`.
9. **Archiving rule:** when an entry is fully closed (`[x]` + a terminal `DONE`/`BLOCKED`
   reply) **and** the LOG has grown long, move that entry's whole block out of LOG into
   `./coord/archive/<YYYY-MM>.md`. Keep LOG lean — only live/recent threads.

---

## STATUS  (overwrite your own row when your work changes · always carry a timestamp)

> One row per role. Format: `<role> · <MM-DD HH:MM> · <one-line state>`.
> Empty board = every role `idle`.

- manager   · — · idle ·
- design    · — · idle ·
- worker-1  · — · idle ·
- worker-2  · — · idle ·
- qa-1      · — · idle ·
- qa-2      · — · idle ·
- security  · — · idle ·

> Running more instances? Add `worker-3` / `qa-3` rows here using the same shape; each
> instance reads its own memory file (`./coord/mem/worker-<n>.md`) and owns its own lane.

---

## LOG  (newest at the bottom)

<!-- No entries yet. Append the first entry below using the entry-head format above. -->
