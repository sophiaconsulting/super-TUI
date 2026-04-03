# agents
> Claude Code sub-agent definitions powering the `/create-plan` skill's spec-driven development pipeline.
`6 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `spec-interviewer.md` | Interviews the user to extract requirements and declarative `SC-N:` success criteria — runs first in the create-plan pipeline |
| `codebase-researcher.md` | Researches the codebase via progressive disclosure (ctx-index → ctx-peek → Read) to find integration points for a feature |
| `plan-writer.md` | Converts spec + research into a detailed implementation plan with exact file paths and subtasks — uses opus model |
| `test-generator.md` | Generates exhaustive failing test suites from specs/plans/git diffs across 5 categories; creates justfile recipes and verifies red phase |
| `context-researcher.md` | Analyzes a single directory and writes a `*-context.md` file — invoked by the `/research` skill, uses haiku model |
| `structural-completeness-reviewer.md` | Post-change hygiene reviewer: finds dead code, orphaned imports, missing config updates — explicitly does NOT review functional correctness |

<!-- peek -->

## Conventions

Each agent file uses YAML frontmatter with `name`, `description`, and `model` fields. The `description` field doubles as the trigger heuristic Claude uses to decide when to invoke the agent — it must be self-contained and example-rich.

Model selection is deliberate: `haiku` for cheap/repetitive tasks (context-researcher), `sonnet` for reasoning tasks, `opus` for high-stakes planning (plan-writer). Do not change models without considering cost implications.

## Gotchas

The `spec-interviewer` → `codebase-researcher` → `plan-writer` → `test-generator` sequence is the create-plan pipeline order. Agents are designed to hand off artifacts (spec files in `.claude/specs/`, plan files in `.claude/plans/`) — breaking the naming convention breaks the handoff.

`structural-completeness-reviewer` is invoked automatically after complex changes, not just on demand. Its scope is intentionally narrow (no functional review) — adding functional checks would create duplicate review work with the test suite.

`context-researcher` is the agent backing `/research` — it writes context files but explicitly checks for a `> SKIP` marker on line 2 before overwriting. Manually maintained context files must have this marker to survive regeneration.
