# maintained_global_claude
> Version-controlled source of truth for Claude Code config — symlinked into `~/.claude/` by `setup.sh`; never edit `~/.claude/` directly.
`5 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `settings.json` | Global Claude Code settings: hook registrations, tool permissions, enabled plugins, status line command — authoritative config, not a template |
| `statusline.sh` | Renders the Claude Code status bar showing dir, git branch, time, and context window % — reads JSON from stdin piped by Claude |
| `CLAUDE.md` | Project-level instructions loaded by Claude Code in this directory — contains Python/shell conventions and ctx-file protocol |
| **agents/** | Sub-agent definitions (`.md` files): codebase-researcher, spec-interviewer, plan-writer, structural-completeness-reviewer, etc. |
| **commands/** | Custom slash commands as `.md` files — invoked via `/commandname` in Claude Code (e.g., `/research`, `/generate-tests`) |
| **hooks/** | Event-driven Python scripts fired on PostToolUse, Stop, SubagentStop, PreCompact — entry points are `post_tool_use.py`, `stop.py`, etc. |
| **skills/** | Skill definitions loaded by the Skill tool — subdirs match skill names (e.g., `create-plan/`, `polish/`, `log-to-daily/`) |
| **archive/** | Retired commands, skills, and plugins — kept for reference, not symlinked |

<!-- peek -->

## Conventions
- This directory is the **edit target** — `~/.claude/` is just a symlink destination. Running `setup.sh` re-syncs everything; changes made directly in `~/.claude/` will be overwritten.
- The `force_replace_targets` array in `setup.sh` deletes stale symlink targets before re-symlinking — safe to re-run after adding new files.
- Hook scripts run via `uv run ~/.claude/hooks/<script>.py` — they must be self-contained with inline uv dependencies or importable from `hooks/utils/`.
- Slash commands are plain Markdown files in `commands/` — the filename (without `.md`) becomes the command name.
- Agent definitions in `agents/` are Markdown files; they appear as sub-agents available to skills like `create-plan`.

## Gotchas
- `settings.json` uses `skipDangerousModePermissionPrompt: true` — Claude Code runs in auto-approve mode. Adding new tool permissions here is sufficient; no interactive confirmation needed.
- The `hooks/` `PostToolUse` matcher is an empty string (`""`), meaning it fires on **every** tool use — `post_tool_use.py` must be fast or it will visibly slow down every tool call.
- `statusline.sh` reads JSON from stdin (piped by Claude Code) — it cannot be tested by running it directly without providing the JSON payload.
- `archive/` contains a large `keyword-researcher` skill with Python source, tests, and browser automation — it is not active but adds significant directory weight; ignore it during searches.
