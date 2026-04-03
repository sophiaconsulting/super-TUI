# editors
> Helix editor config (theme, keybindings, LSP) and a legacy fzf file-picker script symlinked into $HOME.
`5 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `hx_config.toml` | Helix main config — symlinked to `~/.config/helix/config.toml`; sets custom theme, keybindings for VS Code-style shortcuts, and fzf integration via `C-t` |
| `hx_languages.toml` | Helix language overrides — symlinked to `~/.config/helix/languages.toml`; extends bash scope to cover `.tmux.conf`, `.zshrc`, and many shell variants |
| `find_files.sh` | fzf-based file picker used as a Helix extension (sources `shared.sh` from `$EXTENSION_PATH`); not standalone |
| `.vimrc` | Legacy vim config kept for fallback use; not actively maintained |
| **hx_themes/** | Custom Helix themes; `material_palenight_transparent.toml` is the active theme referenced in `hx_config.toml` |

<!-- peek -->

## Conventions

- `C-t` in Helix triggers `fzf-helix` (a binary on PATH), not `find_files.sh` directly. `find_files.sh` is an extension script for a separate fzf plugin, requiring `$EXTENSION_PATH/shared.sh` to be present.
- The active theme is `material_palenight_transparent` — defined in `hx_themes/`. Changing the theme name in `hx_config.toml` requires a matching `.toml` file in that subdirectory.
- `C-d` in normal mode implements a multi-cursor "select next occurrence" pattern (select word under cursor → search selection → switch to select mode); in select mode `C-d` extends to the next match instead.

## Gotchas

- `find_files.sh` uses `set -uo pipefail` (no `-e`) intentionally so it can write to `$CANARY_FILE` after a cancelled fzf session. Changing this to `set -e` breaks cancellation signalling.
- `C-t` in normal mode applies `:theme default` then `:theme material_palenight` as part of the fzf sequence — this is a workaround to force Helix to redraw after inserting fzf output. Removing either theme step causes display artifacts.
- Changes to editor config must be made here, never in `~/.config/helix/` directly, as `setup.sh` symlinks will overwrite them.
