# tools
> CLI utilities symlinked to `~/tools/` — AI wrappers, context navigation commands, data viewers, and shell helpers.
`17 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `oai` | OpenAI LLM CLI using DSPy; reads stdin as context, supports `-s` for system prompt file and `--max-context-chars` to truncate piped input |
| `gpt` | Identical to `oai` — separate entry point, same DSPy/gpt-4.1-nano implementation |
| `ctx-index` | Builds project map from `*-context.md` files; extracts line 2 blockquote as one-line summary per dir |
| `ctx-peek` | Shows first N lines of context files under a dir; primary tool for quick orientation without full reads |
| `ctx-stale` | Finds dirs with missing or outdated context files (stale = sibling file newer than context file) |
| `ctx-skip` | Writes a stub context file with `> SKIP` on line 2 to prevent regeneration |
| `ctx-tree` | Wraps `eza --tree` with `--git-ignore`, excludes `__pycache__`, `node_modules`, etc.; shows dirs then files separately |
| `rfz` | Interactive ripgrep+fzf hybrid; CTRL-T toggles between rg and fzf filtering; Enter opens match in helix at exact line |
| `fzf-helix` | Fzf file picker that opens selection in helix editor via tmux popup |
| `print_csv` | Renders CSV/parquet files as rich tables in terminal; samples large files (2MB / 5000 rows); reads from stdin or file arg |
| `colorize-columns` | Awk pipe filter that colorizes each whitespace-delimited column a different ANSI color, then runs `column -t` |
| `check_limits.py` | Checks OpenAI API rate limits by making a minimal real API call and inspecting response headers |
| `update-packages` | Delegates to `update_functions.sh` in `update_checks/`; checks/shows/refreshes cached package update state |
| `system_info` | Reports GPU count (nvidia-smi) and active/total CPU cores; used by tmux status bar scripts |
| `copy` | Cross-platform stdin-to-clipboard: WSL → `clip.exe`, Linux → `xclip`, macOS → `pbcopy` |
| `sshget` | Downloads files from multiple SSH hosts in parallel via named FIFOs |
| `find_files` | fzf file finder sourcing `$EXTENSION_PATH/shared.sh`; designed as an iTerm2/tmux extension integration |
| **urls/** | (empty directory — placeholder for URL-related utilities) |

<!-- peek -->

## Conventions

- Python tools use `#!/usr/bin/env -S uv run --script` shebang with inline `# /// script` dependency blocks — no virtualenv needed, uv handles deps on first run.
- All Python tools use `dspy.LM("openai/gpt-4.1-nano", ...)` as the default model, loaded via `python-dotenv` from `.env`; `OPENAI_API_KEY` must be in the environment or a `.env` file.
- Shell ctx-tools (`ctx-index`, `ctx-peek`, `ctx-stale`, `ctx-skip`) all source `~/dotfiles/shell/gum_utils.sh` with a `|| true` fallback so they work without gum installed.
- `ctx-index` and `ctx-peek` use `fd` (not `find`) with `--no-ignore` to locate `*-context.md` files, so they traverse `.gitignore`d dirs.

## Gotchas

- `oai` and `gpt` are duplicate scripts with identical logic — modifying one does not update the other.
- `ctx-index` depth flag works by passing `depth + 1` to `fd --max-depth`, because context files live inside dirs rather than at the depth level itself.
- `find_files` depends on `$EXTENSION_PATH` being set (iTerm2 shell integration env var) and will fail outside that context.
- `rfz` writes temp files to `/tmp/rg-fzf-{r,f}` and removes them on start — running two instances simultaneously will corrupt each other's state.
- `system_info` uses `nproc` (Linux) for CPU info — on macOS `nproc` may not be available; script will silently fail that subcommand.
