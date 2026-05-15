# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- README "Running headless on Windows" section covering `pythonw.exe` + `Start-Process -WindowStyle Hidden` pattern, persistence via `shell:startup` or Scheduled Task at logon, stop instructions, and resource footprint
- `voice.config.example.toml` at repo root — documented defaults users can copy to `voice.config.toml`
- CI workflow with smoke tests
- Test suite scaffold (tests/test_imports.py)
- README status badges
- `voice-mcp/` Rust source subdirectory (the MCP wrapper that voice-mcp.exe is built from)
- `voice-mcp/Cargo.lock` so the embedded Rust binary build is reproducible
- Release workflow (`.github/workflows/release.yml`) that builds ARM64 + x64 Windows binaries on `v*` tag push and attaches them to a GitHub release
- Rust check workflow (`.github/workflows/rust-check.yml`) that runs `cargo check` on every push
- README "Building voice-mcp from source" section with cargo build instructions
- README "Troubleshooting" section covering PortAudio ARM64, ffmpeg PATH, Python 3.13 wheel mismatch, microphone permissions, MCP connector toggles, listener connectivity, Whisper model download
- `.pre-commit-config.yaml` with trailing-whitespace, end-of-file-fixer, check-yaml, check-toml, ruff, ruff-format hooks
- `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1 — community contact method placeholder pending)
- Dependabot Cargo tracking for the embedded `voice-mcp/` crate
- Link from upstream [`AIWander/voice`](https://github.com/AIWander/voice) to the standalone [`AIWander/voice-mcp`](https://github.com/AIWander/voice-mcp) Rust wrapper

### Changed

- Documented listen defaults tuned for natural back-and-forth: `silence_timeout_secs` 4.0 → 3.0, `min_speech_duration_secs` 3.0 → 2.0. README still notes that typing-replacement / long-prose dictation benefits from raising `silence_timeout_secs` to 5.0+.

### Removed

- `speak_and_listen` tool from `voice-mcp` (Rust). It was a combined TTS-then-STT helper. The same flow works by calling `speak` then `listen_for_speech` separately — `speak` already blocks until playback finishes (half-duplex safety), so chaining the granular tools is equally safe and avoids parameter duplication. Reduces voice-mcp tool count from 10 to 9.

### Notes

- Sibling repo [`AIWander/voice-mcp`](https://github.com/AIWander/voice-mcp) holds the same Rust source as a standalone crate for users who want only the binary without the Python pieces
