# Contributing

Thanks for improving the **claude-code-operating-system** template. This is a public, generic, reusable repo derived from a real Tech Lead's setup — so the bar for contributions is twofold: it must be **useful** and it must be **free of personal/organizational detail**.

ขอบคุณที่ช่วยปรับปรุง template นี้ — เกณฑ์มีสองข้อ: ต้องมีประโยชน์จริง และต้องไม่มีข้อมูลส่วนตัว/องค์กรหลุดเข้ามา

---

## Adding or modifying a skill

1. **Use the scaffolder.** The `write-skill` skill ([`.claude/skills/write-skill/SKILL.md`](.claude/skills/write-skill/SKILL.md)) generates a new skill in the toolkit's pattern — correct frontmatter, trigger line, discipline section, and body structure. Start from it rather than copying another skill by hand.
   - ใช้ `write-skill` scaffold โครงใหม่เสมอ อย่าก็อปมือจาก skill อื่น

2. **Keep the shape.** Every skill is a folder `.claude/skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`). The `description` is what triggers the skill, so write it **English-primary** with a short Thai gloss, and lead with a concrete trigger ("Trigger when …" / "Trigger เมื่อ …").

3. **Core vs. examples.** If a skill encodes cadence/policy that is too org-specific to run as-is (compensation bands, KPI schemes, role splits, market specifics), put it under [`examples/skills/`](examples/skills/) — not the core set. The skills index ([`.claude/skills/README.md`](.claude/skills/README.md)) documents the core/examples split; update it when you add a skill.

4. **Cross-references stay generic.** Skills cite "your SOPs", "your charter", "your tracker" — never a specific company's SOP catalog, charter principles, or tooling. Use the placeholders (below).

5. **Agents.** A skill that spawns a subagent must reference an agent that exists in [`.claude/agents/`](.claude/agents/) with a neutral (non-persona) filename. Read-only agents must declare only read tools (`Read, Grep, Glob`).

---

## Placeholder rules (mandatory)

This repo uses canonical placeholders so anyone can fill in their own setup. The full dictionary is in [`docs/PLACEHOLDERS.md`](docs/PLACEHOLDERS.md). Use these — do **not** invent new ones without adding them to the dictionary:

| Placeholder | Means |
|-------------|-------|
| `{{ASSISTANT}}` | the assistant persona name (prose only) |
| `{{USER}}` | the human owner (prose only) |
| `{{PROJECT}}` | the software product/project |
| `{{ORG}}` | the org / GitHub org handle |
| `{{REPO}}` | a repository name |
| `{{DOMAIN}}` | a service domain |
| `{{VAULT}}` | the notes vault / second-brain root |
| `{{TRACKER}}` | the issue tracker (Linear / Jira / GitHub Issues …) |
| `{{DEPLOY_PLATFORM}}` | the deploy/PaaS platform |
| `{{REGISTRY}}` | the container registry |
| `{{OBJECT_STORE}}` | offsite object store (S3 / GCS / B2 …) |
| `{{OWNER_ROLE}}` | the manager / decision-maker / ops lead role |
| `<project-root>`, `<TICKET-KEY>`, `<source-skill-repo>` | neutral inline placeholders |

**Two hard rules on placeholders:**
- **Prose** uses `{{...}}` tokens (e.g. "{{ASSISTANT}} reads the vault").
- **File and directory names must be neutral** — never put literal `{{...}}` in a path. (e.g. the curate skill folder is `curate/`, not `{{ASSISTANT}}-curate/`.)

---

## No-PII contribution checklist

Before you open a PR, confirm **every** box. A single leaked detail can taint the public repo.

- [ ] **No real names** — people, nicknames, team handles, or assistant persona names from a private setup.
- [ ] **No emails, no usernames** — including GitHub handles and account ids.
- [ ] **No secrets** — API keys, tokens, hex keys, bucket names, private-key blocks. (The pre-commit guard will block obvious ones, but don't rely on it.)
- [ ] **No machine paths** — nothing under a real `/Users/<name>/…` or `/home/<name>/…`; use `~`, `$HOME`, or a placeholder.
- [ ] **No org-specific identifiers** — company/product names, internal domains, specific tracker projects/ticket prefixes, SOP catalog codes, charter principle numbers. Use the generic equivalents.
- [ ] **No dated personal directives/incidents** — keep the lesson, drop the date and the personal provenance.
- [ ] **Specific vendors are framed as examples** — "your tracker (e.g. Linear)", not a hardcoded vendor as the only option. Genuinely external public references (a CLI tool, a public methodology credit) are fine.
- [ ] **Settings/sandbox files** use `~` / `${HOME}`, never an absolute home path.

> Tip: grep your diff for a real home path, an `@`-email, and obvious key prefixes (`sk-`, `ghp_`, `AKIA`) before committing. The repo's `.githooks/pre-commit` catches the obvious secret patterns; PII is on you.

---

## Bilingual-gloss requirement

This repo is **English-primary with a Thai gloss**, and that bilingual character is a feature.

- **Headings, structure, and the first statement of each instruction must be in English** — an English-first reader must be able to follow without the Thai.
- **Keep the Thai gloss where it adds nuance.** Don't strip all Thai; don't leave a load-bearing instruction Thai-only either.
- Write natural bilingual prose, not machine-translated filler. If you don't read Thai, contribute the English and leave the gloss to a reviewer rather than running it through a translator.

---

## Submitting

1. Branch from the default branch.
2. Run any tests/lints the repo defines.
3. Make sure new skills appear in [`.claude/skills/README.md`](.claude/skills/README.md) and any new placeholder is in [`docs/PLACEHOLDERS.md`](docs/PLACEHOLDERS.md).
4. Open a PR describing the change and confirming the no-PII checklist passed.

By contributing you agree your contribution is licensed under the repo's [MIT License](LICENSE).
