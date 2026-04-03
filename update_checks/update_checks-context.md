# update_checks
> Shell library for checking outdated packages across brew, apt, cargo, npm, uv, and pip with filesystem caching.
`2 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `update_config.sh` | Declares all config variables (`UPDATE_CACHE_DIR`, timeouts, intervals) — sourced first by `update_functions.sh` |
| `update_functions.sh` | Implements `check_all_updates`, `show_update_commands`, `refresh_update_cache`; hardcodes `source ~/dotfiles/update_checks/update_config.sh` |

<!-- peek -->

## Conventions
- `update_functions.sh` hardcodes `source ~/dotfiles/update_checks/update_config.sh` on line 6 — the path assumes the repo is cloned to `~/dotfiles`. This will silently fail if the repo is elsewhere.
- Cache files live in `~/.cache/dotfiles_updates/` as hidden files named `.${pm}_updates` (e.g. `.brew_updates`). Cache validity is checked via `stat` with a dual Linux/macOS fallback (`-f %m` vs `-c %Y`).
- All config variables support environment variable overrides (e.g. `UPDATE_CACHE_TIMEOUT=3600 ...`).
- `uv` check counts installed tools but does not actually detect outdated ones — it just reports count and says "check tools with uv tool list". This is a stub, not a real update check.
- `check_all_updates` returns `true`/`false` via `return $updates_found` where `updates_found` is a boolean variable — but `false` in bash is a non-zero string, so callers checking `$?` will see exit code 1 both on error and when no updates are found.

## Gotchas
- `cargo` update check requires the external `cargo-install-update` binary; silently skips if absent.
- `refresh_update_cache` deletes all files in the cache dir with `rm -rf "$UPDATE_CACHE_DIR"/*` — does not delete the dir itself, so it is safe to re-run.
- Scripts use `#!/bin/bash` shebang but are checked with `shellcheck shell=bash`; they do not use zsh features despite the rest of the repo targeting zsh.
