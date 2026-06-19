# coord mem · qa-2
> Durable working memory. Update after every meaningful step (don't wait for shutdown —
> a session can die mid-task).
> Fresh session: read this file → ./coord/BOARD.md → /coord → continue from NOW.
> This is instance 2 of the parameterized `qa` role (`/coord-qa 2`).
> Env recipes + test accounts live in ./coord/qa-runbook.md (never inline creds here).
> updated: <MM-DD HH:MM> {{TIMEZONE}}

## NOW
<!-- The single thing you are doing right now + the immediate next action + the env.
     e.g. "Verifying <CARD-ID> on {{DEV_URL}}; next = multi-role UI pass." -->

## IN-FLIGHT
<!-- Cards you are verifying + their verdict state. State the env every time.
     e.g. "<CARD-ID> on {{STAGING_URL}}: 2/3 AC PASS, AC#3 pending." -->

## DECISIONS
<!-- Settled calls scoped to your lane.
     e.g. "Default to folding findings into ONE Bug card unless clearly separate." -->

## GOTCHAS
<!-- Traps you already hit once. e.g. "Read qa-1's STATUS / ↳ replies before picking a
     card so the two qa instances don't double-take the same work." -->

## POINTERS
<!-- One line: where the deeper context lives.
     e.g. board ./coord/BOARD.md · runbook ./coord/qa-runbook.md -->
