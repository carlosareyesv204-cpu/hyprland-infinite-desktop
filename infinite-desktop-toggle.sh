#!/usr/bin/env bash
STATE_FILE="/tmp/infinite-desktop-state"
current=$(cat "$STATE_FILE" 2>/dev/null || echo "normal")
if [ "$current" = "normal" ]; then
    echo "inverse" > "$STATE_FILE"
else
    echo "normal" > "$STATE_FILE"
fi
