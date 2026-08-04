#!/bin/bash
set -euo pipefail

LABEL="com.local.menubar-stopwatch"
PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
BIN_PATH="$HOME/bin/stopwatch"

launchctl bootout "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || true
rm -f "$PLIST_PATH"
rm -f "$BIN_PATH"

echo "Uninstalled."
