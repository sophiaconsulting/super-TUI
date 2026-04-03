# themes
> iTerm2 terminal color palette switchers using OSC escape sequences, primarily for visual SSH session distinction.
`2 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `palenight.zsh` | Restores default Palenight palette — used to revert from gruvbox after an SSH session |
| `gruvbox-dark.zsh` | Applies Gruvbox Dark palette — intended to visually distinguish remote SSH sessions from local |

<!-- peek -->

## Conventions
- Scripts are sourced, not executed: `source ~/dotfiles/shell/themes/palenight.zsh`
- Both scripts set `$DOTFILES_THEME` env var to track which theme is active
- OSC sequences are wrapped in tmux passthrough (`\033Ptmux;...\033\\`) when `$TMUX` is set — both themes handle this transparently via `_send_osc`
- Scripts silently no-op (return 0) when not running inside iTerm2 — guard on line 7 checks `$TERM_PROGRAM` and `$ITERM_SESSION_ID`

## Gotchas
- These do NOT affect non-iTerm2 terminals (Alacritty, Terminal.app, etc.) — the early-return guard on line 7 makes this a silent no-op, which can be confusing
- tmux wrapping is required because tmux intercepts raw escape sequences; without `\033Ptmux;...\033\\` the colors silently fail inside a tmux session
- `palenight.zsh` is the "local default" — gruvbox signals you are in an SSH session; source palenight when returning to local work
