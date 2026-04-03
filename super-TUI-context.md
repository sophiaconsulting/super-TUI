# super-TUI
> Dotfiles repo automating a full TUI dev environment (zsh, tmux, Helix, Claude, fzf) across macOS and Linux via symlinks.
`5 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `setup.sh` | Single entry point: idempotent orchestrator that installs ~40 tools and wires symlinks via `install_if_missing` / `install_if_dir_missing` guards |
| `CLAUDE.md` | Project conventions for Claude Code — architecture, symlink table, shell config chain order, gum_utils API |
| **shell/** | zsh config chain: `.zshrc` → zprezto → helper_functions → gum_utils → aliases → local env → paths → fzf → p10k |
| **install/** | Idempotent install helpers and the `install_dotfiles` function defining all ~160 symlink pairs |
| **maintained_global_claude/** | Source of truth for Claude Code config (agents, commands, hooks, skills, settings.json) — symlinked into `~/.claude/` |
| **tmux/** | `.tmux.conf` + status bar scripts (cpu, ram, agents count, pm2, battery, network, ssh) |
| **tools/** | CLI utilities symlinked to `~/tools/` — AI wrappers, context navigation commands, data viewers, and shell helpers |
| **editors/** | Helix editor config (theme, keybindings, LSP) and a legacy fzf file-picker script symlinked into `$HOME` |
| **fzf/** | fzf env and config sourced from `.zshrc` |
| **preview/** | fzf file preview handlers — a dispatch script plus per-format Python/shell scripts, all symlinked into `~/bin/` |
| **update_checks/** | Shell library for checking outdated packages across brew, apt, cargo, npm, uv, and pip with filesystem caching |
| **iterm2/** | iTerm2 configuration files: hotkey window profile, keybindings, and a saved window arrangement for a local agents workspace |
| **assets/** | Static media for the project README — screenshots, demo GIFs/MP4s, sample preview files, and a GIF conversion pipeline |
| **linters/** | Linter configs (shellcheck, etc.) |
| **mutt/** | NeoMutt email client config (accounts, isync, msmtp, notmuch, keys, scripts) |
| **local/** | Git-ignored machine-local overrides: `.local_env.sh` (API keys), `.secrets`, `.mutt_secrets` |
| **demo/** | Demo files or recordings for the README |

<!-- peek -->

## Conventions

- All user-facing shell output must use `gum_utils.sh` functions (`gum_success`, `gum_error`, `gum_warning`, `gum_info`, `gum_dim`) — never raw `echo`. Functions fall back to plain text in non-TTY contexts.
- Every install step uses `install_if_missing <cmd> <fn>` or `install_if_dir_missing <dir> <fn>` — never call install functions directly. This is how idempotency is enforced.
- OS branching uses `$OS_TYPE` (`"mac"` vs Linux) or the helper `install_on_brew_or_mac`. Do not use `uname` ad hoc.
- Claude Code config must be modified in `maintained_global_claude/`, never directly in `~/.claude/`. The `force_replace_targets` array in `install_dotfiles` ensures stale symlinks are replaced on each run.
- Python tools use the uv shebang `#!/usr/bin/env -S uv run --script` and `uv add --script` for inline deps — never a venv or `pip install`.

## Gotchas

- `setup.sh` runs `cd "$(dirname "$0")"` at the top — relative paths in install functions assume CWD is the repo root.
- tmux plugins are installed immediately after the tmux binary install inside `setup.sh` (not via a separate step), so TPM must exist before that block runs.
- `local/` is git-ignored and must be created manually (or via `install_if_dir_missing ~/dotfiles/local install_local_dotfiles`) before `.zshrc` sources `local/.local_env.sh` — missing file causes silent no-op, not an error.
- uv-dependent tools (`rich`, `markitdown`, `visidata`, `ty`) are installed after uv in `setup.sh` — reordering these will break installs.
- The `maintained_global_claude/commands/` subdir maps to `~/.claude/commands/` but is not listed in CLAUDE.md's symlink table — it IS wired in `install_dotfiles`.
