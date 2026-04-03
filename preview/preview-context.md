# preview
> fzf file preview handlers — a dispatch script plus per-format Python/shell scripts, all symlinked into `~/bin/`.
`8 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `fzf-preview.sh` | Central dispatcher: matches file extension and calls the right viewer; falls back to `tldr` then `bat` for unknown types |
| `feather-preview.py` | Renders `.feather` files via pandas; uses uv inline deps |
| `pkl-preview.py` | Loads `.pkl`/`.pickle` with rich formatting; detects pandas, dict, list, and generic types |
| `npy-preview.py` | Renders `.npy` arrays — heatmap via matplotlib+chafa for 2D/3D, raw print for 1D/4D+ |
| `torch-preview.py` | Loads `.pt` PyTorch checkpoints and pretty-prints them; uv inline dep on `torch` |
| `torch-preview.sh` | Legacy wrapper that calls `$HOME/ml3/bin/python` directly — superseded by `torch-preview.py` |

<!-- peek -->

## Conventions
- All `.py` previewer scripts use the `#!/usr/bin/env -S uv run --script` shebang with inline `# /// script` dependency blocks — no separate venv or install step needed.
- Scripts are invoked as bare commands (`pkl-preview`, `feather-preview`, etc.) because `setup.sh` symlinks the entire `preview/` directory into `~/bin/` and strips the extension on copy.
- `fzf-preview.sh` calls previewer commands by their bare name (e.g., `pkl-preview "$1"`), so the symlink in `~/bin/` must exist for them to resolve.

## Gotchas
- `torch-preview.sh` hardcodes `$HOME/ml3/bin/python` — it will silently fail on machines without that venv. Prefer `torch-preview.py` which uses uv.
- `npy-preview.py` uses `open_memmap` (read-only, no full load into RAM) — safe for large arrays, but requires the file to be a proper `.npy` format, not `.npz`.
- For 2D/3D arrays, `npy-preview.py` renders via `chafa` after saving a temp PNG to `/tmp/npy_preview.png`; if `chafa` is missing the image is silently saved but nothing displays.
- `fzf-preview.sh` queries `.db` files using only the first table returned by `.tables` — multi-table databases will only show one table.
