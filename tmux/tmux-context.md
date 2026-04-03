# tmux
> Tmux configuration with Catppuccin theming, powerkit status bar, and Claude AI usage monitoring widgets.
`14 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `.tmux.conf` | Main config — keybindings, session hooks, powerkit layout, TPM plugins, and SSH/local conditional widget sets |
| `catppuccin-mocha-vibrant.sh` | Local theme (Mocha) loaded via `@powerkit_custom_theme_path` for non-SSH sessions |
| `catppuccin-macchiato-vibrant.sh` | Remote theme (Macchiato) loaded for SSH sessions — auto-switched by `$SSH_CLIENT` check in `.tmux.conf` |
| `scripts/pk_claude_metric.sh` | Powerkit-compatible Claude API usage widget; reads cached JSON, takes metric arg (`five_hour`, `seven_day`, `opus`, `sonnet`, `credits`, `reset`) |
| `scripts/agents_cache_refresh.sh` | Fetches Claude usage from `api.anthropic.com/api/oauth/usage` using macOS Keychain token; writes `/tmp/claude_usage_cache.json` with 60s TTL; uses `mkdir` as atomic lock |
| `scripts/update_session_status.sh` | Hook script run on `client-session-changed`; replaces powerkit center with `agents_status_bar.sh` and turns session pill orange+crab when in the `agents` session |
| `scripts/agents_count.sh` | Counts active agent panes in the `agents` session by scanning `pane_current_command` for claude/node processes |
| `scripts/agents_status_bar.sh` | Custom center status bar content shown only in the `agents` session |
| `scripts/cpu_percent.sh` | CPU usage for powerkit widget |
| `scripts/mem_usage.sh` | Memory usage for powerkit widget |
| `scripts/gpu_status.sh` | GPU status (SSH sessions only) |
| `scripts/ssh_status.sh` | SSH connection info (SSH sessions only) |
| `scripts/battery_status.sh` | Battery status (local sessions only) |
| **scripts/backup/** | Old Dracula/Catppuccin theme backups — not active |

<!-- peek -->

## Conventions

- **SSH vs local branching**: `.tmux.conf` uses `if-shell '[ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]'` in multiple places to switch themes, plugins, and widget sets. SSH sessions get gpu/ssh widgets; local sessions get battery widget.
- **Powerkit plugins use raw hex colors**: Widget colors are specified as hex strings (e.g., `"#fab387"`) so powerkit's contrast function picks foreground text automatically — do not use color names.
- **Status bar scripts hardcode `$HOME/dotfiles/tmux/scripts/`**: All `@powerkit_plugins` external() calls reference `$HOME/dotfiles/tmux/scripts/` directly, not the repo path. This is the symlink target — scripts must be accessible there.
- **Post-TPM transparency block**: After `run '~/.tmux/plugins/tpm/tpm'`, four `set -g *-style bg=default` lines override plugin backgrounds for iTerm2 transparency. This block must stay after TPM init.
- **Powerkit requires bash 5+**: The `run-shell` PATH fix at the bottom of `.tmux.conf` prepends `/opt/homebrew/bin` so powerkit gets Homebrew's bash, not macOS system bash.

## Gotchas

- **Claude cache token source is macOS Keychain**: `agents_cache_refresh.sh` reads the OAuth token via `security find-generic-password -s "Claude Code-credentials"`. On Linux or if keychain entry is missing, usage metrics silently return zeros.
- **`update_session_status.sh` uses fragile sed on powerkit's rendered format string**: It regex-replaces color ternaries in the live `status-format[0]` string. If powerkit changes its format output, the agents session override will silently fail or corrupt the status bar.
- **Pane border status is session-scoped, not global**: `pane-border-status` is `off` globally but flipped to `top` only in the `agents` session via `update_session_status.sh`. The hook fires on `client-session-changed`, so switching sessions triggers the script.
- **`pk_claude_metric.sh` does a synchronous fetch on first run**: If the cache file doesn't exist, it blocks until `agents_cache_refresh.sh` completes (up to 5s curl timeout). Subsequent runs are async background refreshes.
- **F12 disables all prefix keys**: F12 toggles a "nested session" mode that sets `key-table off` and `prefix None`. Pressing F12 again restores. If tmux seems unresponsive to prefix keys, check if F12 was accidentally pressed.
