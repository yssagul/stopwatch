#!/bin/bash
set -euo pipefail

LABEL="com.local.stopwatch"
PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
BIN_DIR="$HOME/Library/Application Support/stopwatch"

launchctl bootout "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || true
rm -f "$PLIST_PATH"
rm -rf "$BIN_DIR"

echo "Uninstalled."
