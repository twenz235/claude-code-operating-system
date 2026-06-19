# coord mem · design
> Durable working memory. Update after every meaningful step (don't wait for shutdown —
> a session can die mid-task).
> Fresh session: read this file → ./coord/BOARD.md → /coord → continue from NOW.
> updated: <MM-DD HH:MM> {{TIMEZONE}}

## NOW
<!-- The single thing you are doing right now + the immediate next action.
     e.g. "Drafting Feature card for <slug>; awaiting {{HOST}} sign-off." -->

## IN-FLIGHT
<!-- Designs / ADRs in progress and what each is waiting on.
     e.g. "ADR-<n> drafted, pending {{STAKEHOLDER}} opinion before card opens." -->

## DECISIONS
<!-- Settled design calls. e.g. "Open Feature cards only — Bug/Improvement is qa's lane." -->

## GOTCHAS
<!-- Traps you already hit once. e.g. "Feature shipped before legal/compliance opinion =
     wrong order; gate the card until {{STAKEHOLDER}} responds." -->

## POINTERS
<!-- One line: where the deeper context lives. e.g. board ./coord/BOARD.md · ADRs {{DOCS_REPO}} -->
