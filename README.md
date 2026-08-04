# stopwatch

A tiny menu bar stopwatch for macOS. Click to start/stop, option-click (or right-click) to clear or quit.

Most menu bar timer apps on GitHub are countdown timers. This is a stopwatch — it counts up, and that's all it does.

## Features

- Lives entirely in the menu bar, showing elapsed time as `MM:SS` (minutes roll past 60, e.g. `125:33`)
- Click to start/stop
- Option-click or right-click for a menu: **Clear** (reset to `00:00`) and **Quit**
- No dock icon, no windows, no settings
- Single ~85-line Swift file, AppKit only — no dependencies, no Xcode project, no app bundle
- Elapsed time is computed from wall-clock timestamps, not a tick counter, so it stays accurate across sleep/wake
- Optionally runs as a login item via a `launchd` LaunchAgent, and auto-restarts itself if it ever crashes

## Requirements

macOS with the Swift toolchain (Xcode or the Xcode Command Line Tools — `xcode-select --install`).

## Install

```bash
git clone https://github.com/yssagul/stopwatch.git
cd stopwatch
./install.sh
```

This builds the binary, copies it to `~/Library/Application Support/stopwatch/stopwatch`, and registers a `launchd` LaunchAgent so it starts at login and stays running.

## Uninstall

```bash
./uninstall.sh
```

## Usage

| Action | Result |
|---|---|
| Click | Start / stop the stopwatch |
| Option-click or right-click | Open menu: Clear, Quit |

If you quit it and want it back without logging out again:

```bash
launchctl kickstart -k gui/$(id -u)/com.local.stopwatch
```

## Building manually

```bash
swiftc -O Stopwatch.swift -o stopwatch
./stopwatch
```

## License

MIT — see [LICENSE](LICENSE).
