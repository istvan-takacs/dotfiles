#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
MOVE_WINDOW="${2:-false}"

if [[ -z "$TARGET" || ! "$TARGET" =~ ^[0-9]+$ ]]; then
  echo "Usage: $0 <space-number> [move_window]"
  exit 1
fi

YABAI=$(command -v yabai)
JQ=$(command -v jq)

# Get total number of existing spaces
TOTAL=$($YABAI -m query --spaces | $JQ 'length')

# If target space doesn't exist, create until it does
while [ "$TOTAL" -lt "$TARGET" ]; do
  $YABAI -m space --create
  sleep 0.1
  TOTAL=$($YABAI -m query --spaces | $JQ 'length')
done

# Move the focused window to target space if flag is true
if [ "$MOVE_WINDOW" = "true" ]; then
  FOCUSED_WINDOW=$($YABAI -m query --windows --window | $JQ '.id')
  if [ "$FOCUSED_WINDOW" != "null" ]; then
    $YABAI -m window "$FOCUSED_WINDOW" --space "$TARGET"
  fi
fi

# Focus the target space
$YABAI -m space --focus "$TARGET"