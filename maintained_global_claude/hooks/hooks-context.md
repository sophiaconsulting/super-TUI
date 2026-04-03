# hooks
> Claude Code lifecycle hooks: safety guards, TTS notifications, session logging, and background context-file refresh.
`9 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `pre_tool_use.py` | Blocks dangerous `rm -rf` and `.env` file access before any tool runs; also logs all tool calls to `.claude/logs/pre_tool_use.json` |
| `post_tool_use.py` | Logs all tool results to `.claude/logs/post_tool_use.json` — no blocking logic |
| `stop.py` | On session end: logs to `.claude/logs/stop.json`, optionally copies JSONL transcript to `chat.json` (`--chat`), announces completion via TTS |
| `subagent_stop.py` | Same as `stop.py` but for subagents; says "Subagent Complete" instead of LLM-generated message |
| `notification.py` | On Claude waiting for input: logs event, optionally speaks "Your agent needs your input" via TTS (`--notify` flag required to activate speech) |
| `session_start.py` | On session start: scans project for stale/missing context files and fires `refresh_context.py` as a background process |
| `refresh_context.py` | Calls `claude-haiku-4-20250414` via Anthropic API to regenerate `*-context.md` files for given directories |
| `pre_compact.py` | Before context compaction: appends a timestamped snapshot to `.claude/logs/compact_summary.md` (keeps last 5) |
| **utils/** | TTS backends (ElevenLabs/OpenAI/pyttsx3) and LLM wrappers (oai.py, anth.py) used by stop/notification hooks |

<!-- peek -->

## Conventions

All hooks read JSON from stdin and exit 0 on success. Exit code 2 in `pre_tool_use.py` is the only blocking exit — it cancels the tool call and shows the stderr message to Claude. All other hooks exit 0 even on error (silent failure is deliberate).

TTS selection is runtime: hooks check env vars at call time in priority order `ELEVENLABS_API_KEY` → `OPENAI_API_KEY` → pyttsx3 (no key needed). Missing keys cause graceful skip, not failure.

`notification.py` only speaks when invoked with `--notify` flag AND the message is not the generic "Claude is waiting for your input" string. The flag must be set in `settings.json` hook config, not here.

`stop.py` generates LLM completion messages (OpenAI first, then Anthropic) to announce completion — not a static string. `subagent_stop.py` always says "Subagent Complete" (no LLM call).

## Gotchas

`session_start.py` only runs in git repos — it exits immediately if `.git` is absent. Context refresh is fire-and-forget via `subprocess.Popen(..., start_new_session=True)` so it never blocks session startup.

`refresh_context.py` uses a simple LLM prompt (not this agent) and writes a simpler context format without the `<!-- peek -->` zone — stale files it regenerates will lack peek-zone structure.

All log files append by loading the full JSON array, appending, and rewriting — not streaming append. Large log files will cause increasing I/O per hook call.

`.env` blocking in `pre_tool_use.py` checks `.env` substring in file paths, so `.env.local`, `.env.production`, etc. are also blocked (only `.env.sample` is exempted).
