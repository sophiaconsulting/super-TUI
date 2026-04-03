# assets
> Static media for the project README — screenshots, demo GIFs/MP4s, sample preview files, and a GIF conversion pipeline.
`14 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `mp4-to-gif` | Zsh script converting screen recordings to optimized GIFs via ffmpeg/gifski; use `--all` to batch-process `raw/` |
| `raw/` | Drop raw `.mp4`/`.mov` recordings here before running `mp4-to-gif`; files are gitignored, only converted GIFs are committed |
| `demo-preview/` | Sample files used to demonstrate the file preview feature (csv, json, md, ipynb, db, parquet, pdf, png, and a full sample Rust project) |
| `agents_view.png` | Screenshot of the agents panel used in README |
| `img.png` | General screenshot asset |
| `Stewie_Griffin.webp` | Image asset (likely used in a demo or README illustration) |
| `*.mp4` | Demo recordings committed directly; GitHub renders MP4 inline (unlike GIFs >10 MB) |

<!-- peek -->

## Conventions
- Raw recordings go in `raw/` (gitignored via `raw/.gitignore`). Converted GIFs or committed MP4s go in the root `assets/` directory.
- `mp4-to-gif` is a standalone script — run it from any location; it resolves its own `ASSETS_DIR` and `RAW_DIR` via `dirname`.
- Uses `gifski` when available for smaller output; falls back to ffmpeg palette-based conversion automatically.
- Default output: 15 fps, 800px wide, quality 80. Override with `--fps`, `--width`, `--quality`, `--trim`.

## Gotchas
- GitHub will not render GIFs larger than 10 MB inline. The script warns when output exceeds 10 MB and suggests `--fps 10` or `--width 600`.
- `.claude/logs/` directories exist inside `assets/` — these are Claude hook logs that leaked into the assets tree and are not part of the media pipeline.
- `mp4-to-gif --all` only picks up files from `raw/`; MP4s already in `assets/` root are not re-processed by batch mode.
