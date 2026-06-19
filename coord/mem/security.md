# coord mem · security
> Durable working memory. Update after every meaningful step (don't wait for shutdown —
> a session can die mid-task).
> Fresh session: read this file → ./coord/BOARD.md → /coord → continue from NOW.
> updated: <MM-DD HH:MM> {{TIMEZONE}}

## NOW
<!-- The single thing you are doing right now + the immediate next action.
     e.g. "Auditing PR <PR#> (touches permissions); next = run dup-method AST scan." -->

## IN-FLIGHT
<!-- Audits in progress + verdict state (SHIP / SHIP-WITH-NOTES / BLOCK).
     e.g. "<CARD-ID> audit: IDOR + enumeration dims clean, RBAC dim pending." -->

## DECISIONS
<!-- Settled calls scoped to your lane.
     e.g. "Read-only role: never edit code or merge; verdict only, {{HOST}} authorizes." -->

## GOTCHAS
<!-- Traps you already hit once. e.g. "Run the duplicate-method AST scan EVERY pass —
     it is easy to skip and catches real footguns." -->

## POINTERS
<!-- One line: where the audit dimensions / deeper context live.
     Dimensions: IDOR · object enumeration (non-member → 404-not-403 invariant) ·
     RBAC bypass · privilege escalation · duplicate-method AST scan. -->
