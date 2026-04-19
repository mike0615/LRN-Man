#!/usr/bin/env bash
# LRN Man - Defender of the Network
# DVD Launcher for Linux/macOS

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INDEX="$SCRIPT_DIR/issues/index.html"

if [ ! -f "$INDEX" ]; then
    echo "Error: Cannot find issues/index.html"
    echo "Please run from the disc root directory."
    exit 1
fi

# Try common openers in order
if command -v xdg-open &>/dev/null; then
    xdg-open "$INDEX"
elif command -v gnome-open &>/dev/null; then
    gnome-open "$INDEX"
elif command -v kde-open &>/dev/null; then
    kde-open "$INDEX"
elif command -v firefox &>/dev/null; then
    firefox "$INDEX"
elif command -v google-chrome &>/dev/null; then
    google-chrome "$INDEX"
elif command -v chromium-browser &>/dev/null; then
    chromium-browser "$INDEX"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    open "$INDEX"
else
    echo "LRN Man Comic Series"
    echo "Open this file in your browser: $INDEX"
fi
