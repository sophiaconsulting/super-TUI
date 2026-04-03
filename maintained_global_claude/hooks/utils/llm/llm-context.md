# llm
> LLM utility scripts for Claude hooks — thin wrappers around OpenAI (via DSPy) and Anthropic APIs for hook-side prompting.
`6 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `oai.py` | Standalone uv script; CLI entry point for OpenAI calls using DSPy + `gpt-4.1-nano`; accepts piped stdin as context with optional truncation |
| `anth.py` | Standalone uv script; Anthropic wrapper using `claude-3-5-haiku` (max_tokens=100); exposes `generate_completion_message()` for post-task TTS/notification hooks; reads `ENGINEER_NAME` env var for personalised messages |
| `pyproject.toml` | Package-level deps (dspy, typer, dotenv); used only if running as a package — individual scripts carry their own inline deps |
| `main.py` | Placeholder stub (`print("Hello from llm!")`); not wired into anything |

<!-- peek -->

## Conventions

- Both `oai.py` and `anth.py` are self-contained uv inline-dependency scripts (shebang `#!/usr/bin/env -S uv run --script`) — they do NOT import from each other or from `main.py`.
- `oai.py` reads `OAI_MAX_CONTEXT_CHARS` from the environment as a fallback when `--max-context-chars` is not passed; truncation takes the **last** N chars (tail, not head) so recent context is preserved.
- `anth.py` silently returns `None` on any API error (uses bare `except Exception`) — callers must handle `None` gracefully; hooks should not crash on missing API key.
- `anth.py` hard-codes `max_tokens=100` — unsuitable for long-form output; intended only for short completion/notification messages.
- API keys are loaded from `.env` via `python-dotenv`; secrets must exist in `local/.local_env.sh` (git-ignored) or be in the environment at hook execution time.

## Gotchas

- `main.py` is a dead stub — do not treat it as an entry point; only `oai.py` and `anth.py` are callable scripts.
- `oai.py` uses DSPy's `dspy.LM` interface; the response type varies (list, str, or object with `.choices`) and the code handles all three, but adding a new model may need response-type testing.
- `anth.py` uses the older argparse-style `sys.argv` interface (not typer), so CLI flags differ from `oai.py`.
- The `pyproject.toml` requires Python >=3.12 but `anth.py` declares `requires-python = ">=3.8"` in its inline metadata — when run as a standalone script it uses its own declared minimum, not the package's.
