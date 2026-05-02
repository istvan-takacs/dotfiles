#!/bin/bash

# Trigger the brew plugin via sketchybar's event system.
# The plugin (plugins/brew.sh) runs inside sketchybar's env where CONFIG_DIR,
# FONT, and color vars are all set — so all the real work happens there.

if command -v sketchybar >/dev/null 2>&1; then
  SKETCHYBAR="sketchybar"
elif [ -x "/opt/homebrew/bin/sketchybar" ]; then
  SKETCHYBAR="/opt/homebrew/bin/sketchybar"
elif [ -x "/usr/local/bin/sketchybar" ]; then
  SKETCHYBAR="/usr/local/bin/sketchybar"
else
  exit 1
fi

"$SKETCHYBAR" --trigger brew_update
