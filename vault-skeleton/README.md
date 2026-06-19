# vault-skeleton/ — minimal notes-vault layout ({{VAULT}})

> A minimal skeleton of the **notes vault** that the memory and notes skills
> assume. Several skills read from and write to a personal "second brain" — a
> plain folder of Markdown notes (Obsidian, Foam, plain files, whatever you
> like). This folder documents the **expected layout** so those skills have a
> place to land.
>
> Copy this skeleton to wherever you keep notes and set that path as `{{VAULT}}`.
> Adapt the structure to taste — the skills care about the *roles* of these
> folders more than their exact names, but if you rename a folder, update the
> skill that references it.
>
> (Glossary (TH): โครงโน้ต vault ขั้นต่ำที่สกิลกลุ่ม memory/notes คาดหวัง — ก๊อปไปไว้ที่เก็บโน้ตจริง
> แล้วตั้ง path นั้นเป็น `{{VAULT}}`)

## Expected layout

```
{{VAULT}}/
├── inbox/
│   └── fleeting/        # quick captures — capture first, organize later
├── daily/               # daily notes (startup / shutdown logs)
├── templates/           # note templates (daily, weekly, adr, meeting, 1on1, …)
├── work/                # (create as needed) weekly / monthly / quarterly notes,
│                        #   areas/ per-domain context, 00-work-moc.md as the map
├── reference/           # (create as needed) charter.md, adrs/, durable references
├── meetings/            # (create as needed) meeting notes
└── agent/               # (create as needed) proposals/ + upgrade-plan.md
                         #   for assistant self-improvement
```

Only the three folders that skills touch most often ship with a `.gitkeep`
marker here (`inbox/fleeting/`, `daily/`, `templates/`). Create the rest when a
skill first needs them.

## What each folder is for

| Folder | Role | Used by (examples) |
|---|---|---|
| `inbox/fleeting/` | Raw captures. Don't judge or sort at capture time — just get it down. | `capture-knowledge`, session capture |
| `daily/` | One note per working day; start-of-day and end-of-day logs. | `daily-startup`, `daily-shutdown` |
| `templates/` | Reusable note shapes so every daily/weekly/ADR note is consistent. | most cadence skills |
| `work/` | Weekly/monthly/quarterly reviews, per-area domain context, a map-of-content. | `weekly-review`, `monthly-review`, etc. |
| `reference/` | Durable references: your charter, an ADR log, architecture notes. | `charter-check`, `adr-draft` |
| `meetings/` | Meeting prep + captured action items. | `meeting-capture` |
| `agent/` | The assistant's self-improvement trail: `proposals/` (pending changes awaiting approval) + `upgrade-plan.md`. | the curate / review skills |

## Conventions the skills assume

- **Capture first, organize later.** New ideas/learnings land in `inbox/fleeting/`
  immediately; sorting happens in a later pass. Don't block a capture on deciding
  where it "belongs."
- **Templates drive consistency.** Cadence skills open a dated note from a
  template in `templates/` rather than starting from a blank page.
- **The assistant proposes, the human approves.** Changes to the assistant's own
  behavior/skills/config are written as proposals under `agent/proposals/` and
  applied only after review — they are not edited silently. (Optional pattern;
  keep it if you want an audit trail on the assistant's self-changes.)
- **Mark read-only areas in your project's `CLAUDE.md`.** If parts of your vault
  are mirrors or references the assistant must not edit, list them there; the
  curate skill respects "do-not-touch" directories declared that way.

## Mapping back to skill paths

Skills in this toolkit reference vault paths like `{{VAULT}}/work/weekly/…` and
`{{VAULT}}/templates/…`. After you copy this skeleton to your real notes
location, set `{{VAULT}}` to that path everywhere (or do a one-time find/replace
across the skills). The leading emoji/Thai folder names from the original setup
have been normalized to plain lowercase here for portability.
