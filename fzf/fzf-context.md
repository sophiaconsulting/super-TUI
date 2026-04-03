# fzf
> fzf shell integration: env vars, key bindings, completion, and custom widgets sourced by .zshrc.
`4 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `.fzf-env.zsh` | Core env vars (`FZF_DEFAULT_OPTS`, `FZF_CTRL_T_OPTS`, etc.) and toggle logic — sourced first by `.fzf-config.zsh` |
| `.fzf-config.zsh` | Custom zle widgets and completion hooks; sources `.fzf-env.zsh`, then wires everything to key bindings |
| `.fzf.zsh` | Minimal bootstrap: adds fzf to PATH and runs `fzf --zsh` to load default shell integration |
| `.fzf.bash` | Bash equivalent of `.fzf.zsh` (not used in the zsh chain but kept for portability) |

<!-- peek -->

## Conventions

- `.fzf-config.zsh` is the file sourced by `.zshrc` (see shell config chain in CLAUDE.md). It sources `.fzf-env.zsh` itself — do NOT source `.fzf-env.zsh` separately.
- All `FZF_DEFAULT_OPTS` are defined in `.fzf-env.zsh`. The active config uses `--style full --tmux 95%`; there are several large commented-out alternative configs above the active block — these are experiments, not dead code.
- File/dir listing prefers `bfs` over `fd` when available (`bfs` is faster). The fallback to `fd` is automatic via the `if type -p bfs` guard in `.fzf-env.zsh`.
- `FZF_PREVIEW_WINDOW_BINDING` is defined in `.fzf-env.zsh` and reused in `FZF_COMPLETION_OPTS` in `.fzf-config.zsh` — changing the binding in one place updates both.

## Gotchas

- `Ctrl-N` is bound to `fzf-tmux-widget` (fuzzy autocomplete from tmux scrollback), overriding fzf's default `preview-top` binding defined in `FZF_DEFAULT_OPTS`. The `--bind 'ctrl-n:preview-top'` in `.fzf-env.zsh` is shadowed at the widget level.
- `Ctrl-T` inside the fzf file picker toggles between local (`.`) and global (`~`) search scope by inspecting `{fzf:prompt}` — the prompt string acts as state. Changing the prompt labels will break the toggle logic in `FZF_CTRL_T_LOCAL_GLOBAL_TOGGLE`.
- `_fzf_compgen_path` and `_fzf_compgen_dir` override fzf's built-in completion path generators to use `fd` with `--no-ignore`. This means `.gitignore` is not respected in tab completion.
- The `fzf-tab-completion` plugin is loaded from `~/.zprezto/contrib/fzf-tab-completion/` — this path must exist or `source` will fail silently and `^I` completion will revert to default.
