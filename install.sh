#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LABEL="com.local.menubar-stopwatch"
BIN_DIR="$HOME/Library/Application Support/stopwatch"
BIN_PATH="$BIN_DIR/stopwatch"
PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"

echo "Building..."
rm -f "$REPO_DIR/stopwatch"
swiftc -O "$REPO_DIR/Stopwatch.swift" -o "$REPO_DIR/stopwatch"

# Stop any running instance before replacing the binary. Overwriting an
# in-use binary in place (rather than deleting and recreating it) can leave
# a stale kernel code-signature cache on that inode, which makes launchd's
# next spawn get SIGKILLed with "CODE SIGNING: ... tainted" errors.
launchctl bootout "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || true

mkdir -p "$BIN_DIR"
rm -f "$BIN_PATH"
cp "$REPO_DIR/stopwatch" "$BIN_PATH"

mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$BIN_PATH</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key>
        <false/>
    </dict>
    <key>ProcessType</key>
    <string>Interactive</string>
    <key>StandardOutPath</key>
    <string>/tmp/menubar-stopwatch.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/menubar-stopwatch.log</string>
</dict>
</plist>
EOF

launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"

echo "Installed and running — look for 00:00 in your menu bar."
echo "Restart:   launchctl kickstart -k gui/\$(id -u)/$LABEL"
echo "Uninstall: ./uninstall.sh"
