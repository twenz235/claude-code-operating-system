# coord mem · worker-2
> Durable working memory. Update after every meaningful step (don't wait for shutdown —
> a session can die mid-task).
> Fresh session: read this file → ./coord/BOARD.md → /coord → continue from NOW.
> This is instance 2 of the parameterized `worker` role (`/coord-worker 2`).
> updated: <MM-DD HH:MM> {{TIMEZONE}}

## NOW
<!-- The single thing you are doing right now + the immediate next action.
     e.g. "Implementing <CARD-ID> on branch <slug>; next = run tests then open PR." -->

## IN-FLIGHT
<!-- Branches / PRs you own and their CI state.
     e.g. "<CARD-ID> → PR <PR#> · CI green · awaiting qa verify on {{STAGING_URL}}." -->

## DECISIONS
<!-- Settled calls scoped to your lane.
     e.g. "Security-touching PR = no self-merge; hand to security + {{HOST}}." -->

## GOTCHAS
<!-- Traps you already hit once. e.g. "Shared file <path> is edited by worker-1 too —
     serialize merges; check the other lane's STATUS before touching it." -->

## POINTERS
<!-- One line: where the deeper context lives. e.g. board ./coord/BOARD.md · your worktree -->
