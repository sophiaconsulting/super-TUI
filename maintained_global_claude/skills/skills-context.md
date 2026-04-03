# skills
> Claude Code skill definitions — reusable agent workflows invoked via the Skill tool, each living in its own subdirectory with a SKILL.md.
`0 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| **create-plan/** | Six-phase spec-driven dev skill: interviews user, writes spec, generates tests, researches codebase, plans, then executes via subagents. |
| **design-principles/** | UI/UX principles for calm, high-signal analytical dashboards — calm layouts, cognitive load reduction. |
| **data-visualization-techniques/** | Chart type selection, D3.js/Recharts patterns, and dashboard design for analytics/finance agents. |
| **polish/** | Transform functional prototypes into production-grade apps with keyboard-first nav, command palettes, and polished UX. |
| **request/** | Quick-add movies/TV shows to Sonarr/Radarr media stack via `/request` slash command. |
| **log-to-daily/** | (Empty — no SKILL.md yet; stub directory for daily log processing skill.) |
| **media-manager/** | (Empty — no SKILL.md yet; stub directory for media management skill.) |

<!-- peek -->

## Conventions

- Each skill lives in its own subdirectory. The entry point is always `SKILL.md` (or `skill.md` — casing varies: `request/` uses lowercase `skill.md`).
- Skill frontmatter uses `name`, `description`, and optionally `user_invocable: true`. The `description` field is what surfaces in the Skill tool's trigger logic.
- Skills with multi-phase workflows (e.g., `create-plan`) require user confirmation between phases — do NOT auto-advance.
- `log-to-daily/` and `media-manager/` are empty stub directories with no SKILL.md — they are registered in the system but not yet implemented.

## Gotchas

- File casing inconsistency: most skills use `SKILL.md` (uppercase) but `request/` uses `skill.md` (lowercase). Code that scans for skill files must handle both.
- `create-plan` references a `spec-template.md` sibling file used during the spec-writing phase — it is not self-contained in SKILL.md alone.
