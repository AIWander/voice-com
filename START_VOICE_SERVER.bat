@echo off
setlocal
cd /d "%~dp0"

REM Optional: pin a config file alongside the script
if exist "%~dp0voice.config.toml" set "VOICE_CONFIG_PATH=%~dp0voice.config.toml"

REM Use local .venv if present, otherwise fall back to the system Python launcher.
REM On Windows ARM64 you'll want a .venv built from x64 Python 3.11 because
REM ctranslate2 (a faster-whisper dependency) doesn't ship ARM64 wheels.
if exist "%~dp0.venv\Scripts\python.exe" (
    set "PYTHON_CMD=%~dp0.venv\Scripts\python.exe"
) else (
    set "PYTHON_CMD=py -3"
)

echo ========================================================
echo   Voice-Command Listening Server
echo   faster-whisper + noise filtering + emotion detection
echo ========================================================
echo Starting server on http://localhost:5123
echo Leave this window open while using voice mode.
echo Press Ctrl+C to stop.
echo.
%PYTHON_CMD% "%~dp0voice_server.py"
pause
