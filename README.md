# Voice-Command

**Talk to Claude. Hear it work.**

Voice-Command lets you voice-control Claude Desktop end-to-end. You say what you want done — Claude does it, using whatever tools, connectors, and MCPs it has access to — and narrates what it's doing as it goes. The "Command" isn't a euphemism. **Anything the AI can do, you can ask for out loud:** search the web, check your calendar, send email through your connectors, write or fix code, edit files on your computer, run shell commands, kick off automations. If Claude can do it typed, you can do it spoken.

Under the hood it uses [faster-whisper](https://github.com/SYSTRAN/faster-whisper) to understand what you say (running fully on your own computer — your voice doesn't go to the cloud) and [edge-tts](https://github.com/rany2/edge-tts) to speak responses back. It also reads the *feel* of how you say things — excited, hesitant, frustrated — and passes that along so Claude can respond more naturally.

> **Heads up:** This is the active development copy of [`AIWander/voice`](https://github.com/AIWander/voice). If you just want a stable, tested setup, install from there. This repo is where new features get tried before they ship.

---

## How a turn works

1. **You hear a series of beeps.** That's Claude's "I'm listening, your turn" cue.
2. **You talk.** Say what you want done. Anything Claude has the tools to handle counts.
3. **Claude works — and tells you out loud what it's doing as it goes.** ("Checking your calendar… found three events tomorrow… drafting the reply…")
4. **You hear the beeps again.** Claude's done with that turn. Your move.

**One thing to know up front:** the audio flow is one-way at a time. You can't cut Claude off mid-sentence with your voice — once Claude is talking or working, the only way to interrupt is to click or tap directly in the AI's UI. The beeps are the only voice handoff signal.

---

## The easy way to install: ask your AI to do it

This is the whole point. You shouldn't need a CS degree to get this running.

If you have **Claude Desktop with [`ops`](https://github.com/AIWander/ops) installed**, **Claude Code**, **Codex CLI**, or **Gemini CLI** open right now, copy this and paste it to your AI:

> `https://github.com/AIWander/Voice-Command` — Can you install this MCP for us to use here and the voice listening server, and make me a new `.bat` to call it and direct me to do what I need to do to get both sides running, then we can have a talk.

Your AI will:

1. Grab the right `voice-mcp.exe` for your computer (ARM64 or x64) from the [latest release](https://github.com/AIWander/Voice-Command/releases/latest)
2. Drop it somewhere sensible (usually `C:\CPC\servers\`)
3. Wire it into Claude Desktop's config file — your existing setup is preserved, and a timestamped backup is made first, so nothing breaks
4. Clone this repo and install the Python pieces
5. Write you a `START_VOICE_SERVER.bat` you can double-click whenever you want to talk
6. Walk you through restarting Claude Desktop and starting the listener

Then you're talking. Literally.

> **Don't have an operator MCP yet?** [`ops`](https://github.com/AIWander/ops) is the recommended one — public, lightweight, does file/shell work for any AI you want to give hands to. Install ops first, then come back and paste the prompt above. If you have `local`, `programmer`, or another operator MCP already, those work too.

If your AI doesn't have access to your filesystem and shell, scroll down to **Manual installation** below.

---

## What you can actually ask for

Anything Claude has the tools to do. A few examples to give you the shape of it:

- *"Check my calendar for tomorrow and read me what's on it."* → uses your Google Calendar connector
- *"Search the web for the latest on [topic] and summarize."* → uses web search
- *"Open my downloads folder and tell me what's in there."* → uses local filesystem access
- *"Find the file we were editing yesterday and fix the bug we talked about."* → uses filesystem + memory of past chats
- *"Send an email to Sarah saying I'll be ten minutes late."* → uses your Gmail connector
- *"Run the deploy script and tell me when it's done."* → uses shell access

The voice layer doesn't add capabilities — it just changes how you reach them. Whatever connectors, MCPs, and tools you've already hooked up to Claude all work the same. You're just using your mouth instead of your keyboard.

---

## What's it actually doing under the hood?

A few useful things, in plain English:

- **It listens to you.** Speech-to-text via faster-whisper, running on your machine. Your voice stays local — it doesn't get sent anywhere.
- **It cleans up your audio.** A simple filter trims out hum and hiss so it understands you better, even with a cheap mic.
- **It picks up on tone.** Excited? Tired? Hesitant? It guesses from things like volume, pitch shifts, and pacing, and passes that along to Claude.
- **It runs your commands.** Voice triggers anything Claude can normally do — tools, connectors, MCPs, file access, the works.
- **It narrates as it works.** Claude tells you what it's doing while it's doing it, not just at the end. You hear the work happen.
- **The beeps are your turn-token.** Series of beeps means Claude's listening — your move. You'll hear them again when Claude's done with a turn and ready for the next.
- **It knows when you're done talking.** Stops recording after a beat of silence (configurable, default 4 seconds).
- **It cleans up trailing words.** "Send this," "okay done," "stop" — these get stripped automatically so you can talk like a human.

---

## What you'll need on your computer

- **Python 3.11 or newer** — [download here](https://www.python.org/downloads/)
- **A microphone** — built-in or USB, doesn't need to be fancy
- **PortAudio** — a library that lets Python use your mic; usually installs automatically
- **ffmpeg** — for playing back Claude's voice; free, [grab it here](https://ffmpeg.org/download.html)

If any of those words look scary, don't worry — your AI can handle all of this for you using the prompt at the top.

---

## Manual installation (if you'd rather drive yourself)

Clone the repo, then:

```bash
pip install -r requirements.txt
```

### Getting PortAudio working

- **Windows:** `pip install pyaudio` usually just works. If it complains, grab a wheel from [here](https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio).
- **macOS:** `brew install portaudio && pip install pyaudio`
- **Linux:** `sudo apt install portaudio19-dev && pip install pyaudio`

### Getting ffmpeg working

- **Windows:** `winget install Gyan.FFmpeg`, or download from [ffmpeg.org](https://ffmpeg.org/download.html). Make sure it's on your PATH, or set the `VOICE_FFMPEG_PATH` environment variable to point at it.
- **macOS:** `brew install ffmpeg`
- **Linux:** `sudo apt install ffmpeg`

---

## Running it

Start the voice server:

```bash
python voice_server.py
```

It runs at `http://localhost:5123`. On Windows you can also just double-click `START_VOICE_SERVER.bat`.

You mostly won't touch the endpoints directly — Claude calls them for you — but here they are:

| Endpoint | What it does |
|---|---|
| `GET /status` | Health check |
| `POST /listen?timeout=30` | Records, transcribes, reads emotion |

Optional knobs you can pass to `/listen`:

- `skip_emotion=true` — don't bother with emotion detection
- `skip_filter=true` — turn off noise filtering
- `silence_timeout=4.0` — how long of a pause before it stops listening
- `min_speech_duration=3.0` — how long you need to talk before it'll consider stopping
- `rms_threshold=100` — how loud counts as "talking" (20–500)

---

## Tweaking the defaults

Drop a file called `voice.config.toml` next to the script (or set `VOICE_CONFIG_PATH` to point at it):

```toml
[listen]
silence_timeout_secs = 4.0
min_speech_duration_secs = 3.0
rms_threshold = 100
noise_filter_enabled = true
pre_record_enabled = true
```

It looks for config in this order:

1. `VOICE_CONFIG_PATH` environment variable
2. `./voice.config.toml` (current directory)
3. `~/.config/voice/voice.config.toml`

---

## How Claude Desktop talks to it (the MCP piece)

`server.py` is a thin wrapper that gives Claude Desktop three tools:

- `speak` — say something out loud
- `listen_for_speech` — listen for what the user says
- `start_voice_mode` — kick off a back-and-forth conversation

For everyday use, there's a Rust version of that wrapper (`voice-mcp.exe`) that's faster and more stable. It comes as release downloads (ARM64 + x64). Add this to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "voice": {
      "command": "path/to/voice-mcp.exe"
    }
  }
}
```

The Python `server.py` works as a fallback if you'd rather not use the binary.

---

## What's in the box

- `voice_server.py` — the standalone HTTP server that does the actual listening, transcribing, and tone-reading
- `server.py` — the MCP wrapper Claude Desktop talks to; calls `voice_server.py` for input and edge-tts for output
- `response_analyzer.py` — separate analyzer that reads emotion from text Claude says back
- `emotion_config.json` — knobs for the response analyzer (which words count as excited, hedging, etc.)
- `play_audio.ps1` — Windows audio playback helper
- `START_VOICE_SERVER.bat` — Windows launcher

---

## Environment variables

| Variable | What it's for | Default |
|---|---|---|
| `VOICE_CONFIG_PATH` | Where your `voice.config.toml` lives | Auto-discovered |
| `VOICE_FFMPEG_PATH` | Where ffmpeg lives | Found via PATH |
| `VOICE_EMOTION_LOG_DIR` | Where emotion logs get written | `~/.voice/logs/` |

---

## License

Apache 2.0 — see [LICENSE](LICENSE).
