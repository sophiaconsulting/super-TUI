# tts
> Three interchangeable TTS backends (offline, OpenAI, ElevenLabs) callable as standalone scripts via `uv run`.
`3 files | 2026-04-03`

| Entry | Purpose |
|-------|---------|
| `pyttsx3_tts.py` | Offline TTS — no API key needed; picks a random completion message when called with no args |
| `openai_tts.py` | Streaming TTS via `gpt-4o-mini-tts` + `LocalAudioPlayer`; requires `OPENAI_API_KEY` |
| `elevenlabs_tts.py` | ElevenLabs Turbo v2.5 TTS; requires `ELEVENLABS_API_KEY`; hardcodes a specific `voice_id` |

<!-- peek -->

## Conventions

All three scripts share the same CLI contract: called with no args they use a built-in default string; called with args they join all argv into the spoken text. This makes them drop-in replaceable from hooks.

Each script self-installs its own dependencies via the uv inline script header (`# /// script ... ///`) — no venv setup required. Run any of them directly: `./openai_tts.py "text here"`.

API keys are loaded from `.env` via `python-dotenv` for the cloud backends; the hook caller must ensure `.env` is present or the env var is already exported.

## Gotchas

`elevenlabs_tts.py` has a hardcoded `voice_id` (`cgSgspJ2msm6clMCkdW9`) — swapping voices requires editing the file directly, not a flag.

`openai_tts.py` is async and uses `asyncio.run(main())`; the other two are synchronous. This matters if a hook ever tries to call them from an async context.

The commented-out `osascript` volume lines in `elevenlabs_tts.py` are macOS-only — if re-enabled they would break on Linux.
