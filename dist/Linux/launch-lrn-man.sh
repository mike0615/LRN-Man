#!/usr/bin/env bash
# LRN Man - Defender of the Network
# Portable launcher — run directly from the extracted folder

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INDEX="$SCRIPT_DIR/../issues/index.html"

if [ ! -f "$INDEX" ]; then
    echo "Error: Cannot find comic files. Keep all files together."
    exit 1
fi

if command -v xdg-open &>/dev/null; then
    xdg-open "$INDEX"
elif command -v firefox &>/dev/null; then
    firefox "$INDEX"
elif command -v google-chrome &>/dev/null; then
    google-chrome "$INDEX"
elif command -v chromium-browser &>/dev/null; then
    chromium-browser "$INDEX"
else
    echo "Open this file in your browser:"
    echo "$INDEX"
fi
