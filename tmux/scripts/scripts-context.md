# scripts
> tmux status bar scripts — system metrics, Claude AI usage pills, and per-session status-format overrides.
`20 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `agents_status_bar.sh` | Renders Claude usage metrics as powerline-style pills for the `agents` session center — calls `pk_claude_metric.sh` for each metric and outputs raw tmux `#[fg=...]` format strings |
| `agents_cache_refresh.sh` | Fetches Claude API usage data (`/api/oauth/usage`) and writes to `/tmp/claude_usage_cache.json`; uses `mkdir` as atomic lock, 60s TTL — all other Claude scripts read from this cache |
| `pk_claude_metric.sh` | Reads shared cache and formats a single metric (`five_hour`, `seven_day`, `opus`, `sonnet`, `credits`, `reset`) as plain text; triggers background refresh on every call |
| `update_session_status.sh` | Patches `status-format[0]` for the `agents` session — swaps powerkit-render center → `agents_status_bar.sh`, turns session pill orange, swaps session icon to 🦀; unsets overrides for all other sessions |
| `agents_count.sh` | Counts active panes in the `agents` tmux session matching `claude`, `node`, or `N.N` process names |
| `claude_code_status.sh` | Counts running `claude` processes via `pgrep`; returns empty string (not zero) when none, which hides the Dracula widget |
| `cpu_status.sh` | Cross-platform CPU usage — `top -l 1` on macOS, `/proc/stat` on Linux |
| `ram_status.sh` | RAM usage for status bar |
| `gpu_status.sh` | GPU usage for status bar |
| `battery_status.sh` | Battery status for status bar |
| `network_status.sh` | Network status for status bar |
| `ssh_status.sh` | SSH indicator for status bar |
| `load_status.sh` | System load average for status bar |
| `mem_usage.sh` | Memory usage (likely duplicate/alternate of `ram_status.sh`) |
| `cpu_percent.sh` | CPU percentage (likely alternate of `cpu_status.sh`) |
| `pm2_status.sh` | PM2 process manager status for status bar |
| `pm2_status_wrapper.sh` | Wrapper around `pm2_status.sh` |
| **backup/** | Old Dracula/Catppuccin theme status bar scripts, kept for reference |

<!-- peek -->

## Conventions

- All Claude metrics share a single JSON cache at `/tmp/claude_usage_cache.json` — never call the Anthropic API directly from a status bar script; go through `agents_cache_refresh.sh`.
- `pk_claude_metric.sh` spawns a background refresh on every invocation (fire-and-forget `&>/dev/null &`) so the status bar never blocks waiting for network.
- `agents_status_bar.sh` emits raw tmux format strings (with `#[fg=...]` escapes) — it must be embedded inside `status-format[0]` via `#(...)`, not called as a standalone display command.
- The `agents` session detection in `update_session_status.sh` uses string-replacement on the live `status-format[0]` value, not a static template — if powerkit changes its center command string, the sed pattern breaks silently.
- SSH vs local detection (`$SSH_CLIENT` / `$SSH_TTY`) in `agents_status_bar.sh` selects between Catppuccin Macchiato (`#24273a`) and Mocha (`#1e1e2e`) palettes.

## Gotchas

- OAuth token is pulled from macOS Keychain (`security find-generic-password -s "Claude Code-credentials"`). On Linux or if the keychain entry is missing, the cache writes zeros silently and all metrics show `0%`.
- `pk_claude_metric.sh` uses `gdate` (GNU date, from `coreutils`) for ISO timestamp parsing on macOS — if `coreutils` is not installed, the `reset` metric falls back to `date -j -f ...` BSD syntax. If both fail, the reset pill is simply hidden (exit 0).
- `agents_count.sh` looks only at the session named exactly `agents` — renaming the session causes the count to always return 0.
- `claude_code_status.sh` returns an empty string (not "0") when no processes are found — this is intentional to hide the Dracula widget; changing it to print "0" will show a persistent widget.
- The lock in `agents_cache_refresh.sh` uses `mkdir "$LOCK_DIR"` — if a process is killed mid-run, the lock directory may not be cleaned up. Run `rmdir /tmp/claude_usage_cache.lock` to unblock.
