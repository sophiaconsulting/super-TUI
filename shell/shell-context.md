# shell
> Zsh configuration chain: `.zshrc`, aliases, PATH, helper functions, and gum-based terminal UI wrappers.
`15 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `.zshrc` | Entry point — sources all other files in order; sets editor (hx), vi mode, and prezto init |
| `.aliases-and-envs.zsh` | All aliases and env vars; overrides common tools (fd, rg, bat, less, mv, cp) with non-default flags |
| `.paths.zsh` | PATH construction with dedup via awk; order matters (earlier = higher precedence) |
| `helper_functions.sh` | `command_exists`, `move_and_symlink`, tmux copy-last-output hooks (`_clo_preexec`/`_clo_precmd`), `uwu` AI shell helper |
| `gum_utils.sh` | Gum UI wrappers (`gum_success`, `gum_error`, `gum_info`, etc.) with TTY/non-TTY fallback; use these in all shell scripts |
| `update_startup.sh` | Sourced during startup to run background update checks; rate-limited by `$STARTUP_CHECK_INTERVAL` |
| `lscolors.sh` | LS color definitions — sourced by `.zshrc` for consistent directory/file coloring |
| **themes/** | iTerm2 terminal color palette switchers using OSC escape sequences, primarily for visual SSH session distinction. |

<!-- peek -->

## Conventions

- Files are symlinked to `$HOME` (not `~/dotfiles/shell/`) — `.zshrc` sources `~/helper_functions.sh`, not a relative path.
- `.zshrc` sources files from `$HOME` (e.g., `~/helper_functions.sh`), not from `~/dotfiles/shell/`. Edits must go in the repo, but runtime paths are `~/*.sh`.
- Theme switching is automatic: SSH sessions load `gruvbox-dark.zsh`, local sessions set `DOTFILES_THEME=palenight`.
- `fd` and `rg` aliases add `-HI` and `--no-ignore` respectively — they search hidden/ignored files by default, unlike standard behavior.
- `less` alias is defined twice in `.aliases-and-envs.zsh`; the second definition wins.

## Gotchas

- `gum_utils.sh` lazily initializes gum availability on first call via `_gum_init` (cached in `_GUM_AVAILABLE`). If gum is installed after sourcing, re-source the file or the cached value stays 0.
- `update_startup.sh` sources `~/dotfiles/update_checks/update_functions.sh` with a hardcoded path — breaks if dotfiles are not at `~/dotfiles/`.
- PATH dedup in `.paths.zsh` uses `awk + sed`; runs on every shell start. NVM path is conditionally added only if `nvm current` returns a non-system version.
- `_clo_preexec`/`_clo_precmd` hooks in `helper_functions.sh` only register inside tmux (`$TMUX` check) — tmux copy-last-output feature silently does nothing outside tmux.
- `NO_GUM=1` or `DOTFILES_NO_GUM=1` disables gum globally; useful in CI/cron but must be set before any gum function is first called (due to lazy init caching).
