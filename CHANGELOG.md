# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- CI workflow with smoke tests
- Test suite scaffold (tests/test_imports.py)
- README status badges
- `voice-mcp/` Rust source subdirectory (the MCP wrapper that voice-mcp.exe is built from)
- Release workflow (`.github/workflows/release.yml`) that builds ARM64 + x64 Windows binaries on `v*` tag push and attaches them to a GitHub release
- Rust check workflow (`.github/workflows/rust-check.yml`) that runs `cargo check` on every push
- README "Building voice-mcp from source" section with cargo build instructions
- README "Troubleshooting" section covering PortAudio ARM64, ffmpeg PATH, Python 3.13 wheel mismatch, microphone permissions, MCP connector toggles, listener connectivity, Whisper model download
- `.pre-commit-config.yaml` with trailing-whitespace, end-of-file-fixer, check-yaml, check-toml, ruff, ruff-format hooks
- `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1 — community contact method placeholder pending)

### Notes

- Sibling repo [`AIWander/voice-mcp`](https://github.com/AIWander/voice-mcp) holds the same Rust source as a standalone crate for users who want only the binary without the Python pieces
