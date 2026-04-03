# commands
> Custom Claude Code slash commands — markdown files that define reusable workflows invoked via `/commandname` in Claude Code.
`4 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `research.md` | Generates/refreshes `*-context.md` files project-wide using `ctx-stale`, `ctx-tree`, and agent delegation — the entry point for all context file maintenance |
| `generate-tests.md` | Builds an exhaustive failing test suite by discovering context from args, spec files, git diff, or user interview, then delegates to `test-generator` agent |
| `arewedone.md` | Runs structural completeness review via `structural-completeness-reviewer` agent, applies fixes, then commits via `committer` agent |
| `process-parallel.md` | Scaffolds a 3-file parallel pipeline (`worker.py`, `run.py`, `system_prompt.md`) using `pmap` with 50 threads and `uv run` scripts |

<!-- peek -->

## Conventions
- Command files are plain markdown — no YAML frontmatter required, but `generate-tests.md` and `arewedone.md` use `---description:---` frontmatter for discoverability.
- Commands delegate heavy work to named agents (in `../agents/`) via the Task tool rather than implementing logic inline.
- `$ARGUMENTS` is the conventional variable name for user-supplied arguments within command files.
- `process-parallel.md` hardcodes `gpt-5.2` as the model and `n_jobs=50, prefer="threads"` — update these when scaffolding if different behavior is needed.

## Gotchas
- The `.claude/logs/` subdirectory here contains hook log files (`chat.json`, `post_tool_use.json`, `stop.json`, `subagent_stop.json`) — these are runtime artifacts, not command definitions.
- `research.md` instructs that context files must be committed to the repo and NOT added to `.gitignore` — if `*-context.md` appears in `.gitignore`, remove that line before running `/research`.
- Commands are symlinked from this directory into `~/.claude/commands/` during setup — edits must be made here, never in `~/.claude/commands/` directly.
