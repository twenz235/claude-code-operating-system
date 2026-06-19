# coord mem · manager
> Durable working memory. Update after every meaningful step (don't wait for shutdown —
> a session can die mid-task).
> Fresh session: read this file → ./coord/BOARD.md → /coord → continue from NOW.
> updated: <MM-DD HH:MM> {{TIMEZONE}}

## NOW
<!-- The single thing you are doing right now + the immediate next action.
     e.g. "Awaiting {{HOST}} to relay /coord to worker-1 for <CARD-ID>." -->

## IN-FLIGHT
<!-- Work currently moving through the pipeline: which lane owns what, promote scope,
     who is free. e.g. "worker-1 on <CARD-ID> (PR <PR#>) · worker-2 idle · qa idle." -->

## DECISIONS
<!-- Settled calls that future-you must not relitigate.
     e.g. "Security-touching PR = no self-merge (needs review + {{HOST}} authorize)." -->

## GOTCHAS
<!-- Traps you already hit once. e.g. "Verify card state = MERGED + diff
     {{INTEGRATION_BRANCH}} vs target before promoting — review status can mislead." -->

## POINTERS
<!-- One line: where the deeper context lives. e.g. board ./coord/BOARD.md · {{TRACKER}} -->
