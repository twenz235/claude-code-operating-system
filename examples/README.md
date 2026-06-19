# examples/ — optional samples (adapt or delete)

> **Everything under `examples/` is an OPTIONAL SAMPLE.** Nothing here is wired
> into the operating system by default. Each file is a heavily genericized worked
> example from one real engineering team's setup, with every personal and
> organizational detail replaced by a placeholder. Treat these as starting points
> to **adapt to your org — or delete** if they don't fit.

These examples exist to show *shape*, not to prescribe process. They are
deliberately bilingual (English-primary with a Thai gloss where it adds nuance);
that bilingual character is a feature of the original toolkit, not noise — keep,
translate, or drop the Thai as suits your team.

## Placeholders you will see

Replace these with your own values before using anything here:

| Placeholder | Means |
|---|---|
| `{{ASSISTANT}}` | the AI assistant persona name |
| `{{USER}}` | the human owner / operator |
| `{{PROJECT}}` | the main software product |
| `{{ORG}}` | the GitHub org / company handle |
| `{{DOMAIN}}` | an internal service domain |
| `{{REPO}}` | a repository name |
| `{{VAULT}}` | your notes / second-brain vault root |
| `{{TRACKER}}` | your issue tracker (Linear / Jira / GitHub Issues / …) |
| `{{DEPLOY_PLATFORM}}` | your PaaS / deploy platform |
| `{{REGISTRY}}` | your container registry |
| `{{OBJECT_STORE}}` | your offsite object store (S3 / GCS / B2 / …) |
| `{{OWNER_ROLE}}` | the manager / decision-maker / ops lead who approves and owns final calls |

## What's in here

### `skills/` — sample team-process skills
Worked examples of skills that are org-process-shaped (hiring, cadence,
scope boundaries) rather than generic engineering discipline. The generic-
discipline skills live at the top level of the operating system; these are the
ones most coupled to a specific team, so they ship as samples.

- `hiring-interview/` — a hiring funnel from screening to a paid trial week.
- `refuse-list/` — how a tech lead declines out-of-scope work and points to the right owner.
- `weekly-review/` — a Friday weekly-review checklist + KPI snapshot + bus-factor check.
- `workload-balance/` — tracking time per project and escalating overload early.

### `agents/` — sample deploy agents
Two deploy sub-agents wired to one specific PaaS + CI shape. They are the most
infrastructure-specific artifacts in the toolkit, so they ship as samples to
re-point at your own platform.

- `deploy-conductor.md` — stands up a new environment end-to-end (provision → wire GitHub → first deploy through CI).
- `deploy-runner.md` — runs a redeploy / rollback of an already-set-up env through CI, with a SHA smoke test.

> Both assume deploys run **through GitHub Actions** (auditable, gated) while a
> PaaS API is used only for *provisioning*. If your deploy story differs, treat
> these as inspiration and rewrite freely.

### `charter/` — a worked-example team charter
- `CHARTER.sample.md` — a fuller charter with neutral principles, showing how the
  `charter-check` and `grill-with-docs` skills consume it. Pair it with the
  top-level `docs/CHARTER.template.md` (the shorter scaffold).

## How the charter samples connect to the skills

Several skills reference "your team charter." Point them at a real file:

1. Copy `docs/CHARTER.template.md` (the shorter scaffold) to where your team keeps
   it, e.g. `{{VAULT}}/reference/charter.md` or `<project-root>/docs/CHARTER.md`.
2. Fill in your own principles. Use `charter/CHARTER.sample.md` here as a model
   for tone and structure.
3. Skills like `charter-check` (gate a big decision against your principles)
   and `grill-with-docs` (interview yourself against domain + charter before
   starting a feature) read that file. Update their path references to match
   where you put it.

## Note on optional preferences

The original setup carried a few opinionated, org-specific conventions — for
example a "no AI-attribution in commits/PRs" rule and a "merge-commit, never
squash" delivery flow. In this template those are treated as **optional,
documented preferences**, not hardcoded law. Adopt them in your own charter if
you like them; otherwise ignore them. Nothing in the operating system enforces
them for you.
