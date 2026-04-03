# create-plan
> Six-phase spec-driven dev skill: interviews user, writes spec, generates tests, researches codebase, plans, then executes via subagents.
`2 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `SKILL.md` | Orchestration script defining all 6 phases — the skill's executable definition |
| `spec-template.md` | Template written to `.claude/specs/{feature-name}-spec.md` during Phase 2; defines the spec contract |

<!-- peek -->

## Conventions

- Phases must run in order and each requires explicit user confirmation before proceeding to the next.
- Specs are written to `.claude/specs/{feature-name}-spec.md` (relative to the project root), not inside this skill directory.
- Phase 3 (test generation) delegates entirely to the `test-generator` agent at `maintained_global_claude/agents/test-generator.md` — do not inline test logic here.
- Phase 4 launches 2-3 parallel `codebase-researcher` agents via `Task(..., run_in_background=true)` — researchers must read `*-context.md` files first before reading source.
- Phase 6 runs `just test` after every subtask, compares pass/fail delta, and feeds `just test-verbose` output back to subagents on failure before moving on.

## Gotchas

- `SKILL.md` contains a placeholder `[paste spec-interviewer.md instructions]` in Phase 1 — this is intentional; the orchestrating agent must inline the interviewer instructions when constructing the Task prompt.
- The spec template's `## Test File Locations` and `## Implementation Subtasks` sections are intentionally empty — they are filled in by Phases 3 and 5 respectively; don't treat blank sections as incomplete.
- Coverage check (`just test-cov`) and structural review (`structural-completeness-reviewer` agent) only run after all subtasks complete, not per-subtask.
