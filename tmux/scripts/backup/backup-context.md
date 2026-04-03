# backup
> Archived tmux status bar theme entry-point scripts (Dracula and Catppuccin) kept as reference, not active.
`2 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `dracula.sh` | Full Dracula-theme status bar renderer — reads `@dracula-*` tmux options and wires all plugin scripts into `status-right` |
| `catppuccin.sh` | Catppuccin Macchiato variant of the same entry-point — identical plugin dispatch logic but substitutes the Catppuccin palette and adds semantic color aliases |

<!-- peek -->

## Conventions

Both scripts share an identical structure: read `@dracula-*` tmux options → define a color palette → build `status-left` and iterate plugins to append to `status-right` via `tmux set-option -ga`. Color names used in plugin color option pairs (e.g., `"cyan dark_gray"`) are variable names resolved with `${!colors[0]}` (bash indirect expansion), not literal hex values — the color variables must be defined in the palette block above.

Both scripts `source $current_dir/utils.sh` for the `get_tmux_option` helper. These scripts reference sibling plugin scripts (e.g., `battery.sh`, `network.sh`) relative to their own directory via `$current_dir`, so they cannot be called from a different working directory.

## Gotchas

These scripts are **not invoked by the active tmux config** — they are backups/references. The live theme scripts live in `tmux/scripts/` (parent directory). Editing these files has no effect on the running status bar.

`catppuccin.sh` uses Catppuccin-native color names (`maroon`, `flamingo`, `sapphire`, `peach`, `teal`, `mauve`, `lavender`) as plugin default colors, while `dracula.sh` uses Dracula names (`pink`, `cyan`, `orange`, `light_purple`). Both expose the same `@dracula-*` tmux option API, so the scripts are drop-in replacements for each other — but swapping them changes default plugin colors even if `@dracula-*` color overrides are not set.
