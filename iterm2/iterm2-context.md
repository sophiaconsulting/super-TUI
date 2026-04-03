# iterm2
> iTerm2 configuration files: hotkey window profile, keybindings, and a saved window arrangement for a local agents workspace.
`3 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `iTerm2-profile-Hotkey Window.json` | Full iTerm2 profile for the hotkey dropdown window — includes color scheme, font (MesloLGS-NF-Regular 14), status bar with CPU/network components, background image path, and all ANSI colors |
| `iterm2-keybindings.itermkeymap` | Custom keybindings export (currently empty — placeholder for future bindings) |
| `LOCAL-AGENTS-BRAIN.iterm2arrangement` | Binary plist saved window arrangement capturing a tmux session layout used for Claude agents work; encodes session state, terminal contents, and profile settings |
| **ssh-themes/** | Empty directory — reserved for per-host SSH color themes (iTerm2 dynamic profiles or trigger-based themes) |

<!-- peek -->

## Conventions

- Files are imported manually into iTerm2 via Preferences — they are NOT auto-loaded by `setup.sh` or symlinked anywhere. Import steps: profile JSON via Profiles > Other Actions > Import JSON Profiles; keybindings via Preferences > Keys > Key Bindings > Presets > Import; arrangement via Window > Restore Arrangement.
- The hotkey profile uses `\t` (Tab key) as the HotKey character — pressing Tab triggers the dropdown window. This is non-standard and may conflict with shell Tab completion if focus is ambiguous.
- Background image is hardcoded to an absolute path: `/Users/vmasrani/Pictures/iterm2-backgrounds/space/space__milky_way_night_sky__006.jpg`. On a new machine this image must exist at that exact path or the profile will fall back to a plain background.
- Font `MesloLGS-NF-Regular 14` (Nerd Font) must be installed before importing the profile, otherwise glyphs and Powerline separators render as boxes.

## Gotchas

- `LOCAL-AGENTS-BRAIN.iterm2arrangement` is a binary plist, not human-readable text. Do not edit it directly; restore it in iTerm2, modify the layout, then re-export via Window > Save Window Arrangement.
- The arrangement captures a live tmux session path (`/Users/vmasrani/dev/ttys002`) and the command `tmux attach-session -t default`. Restoring it on a different machine will fail to attach unless a tmux session named `default` already exists.
- `iterm2-keybindings.itermkeymap` is 0 bytes — importing it will silently clear all custom keybindings. Do not import until it contains actual content.
