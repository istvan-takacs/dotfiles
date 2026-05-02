#!/bin/bash

# Persist zen state across sketchybar restarts.
# The state file is written on every toggle so the rc can restore it at startup.
ZEN_STATE_FILE="$HOME/.config/sketchybar/.zen_state"

zen_on() {
  echo "on" > "$ZEN_STATE_FILE"
  sketchybar --set wifi          drawing=off \
             --set apple.logo    drawing=off \
             --set '/cpu.*/'     drawing=off \
             --set calendar      icon.drawing=off \
             --set separator     drawing=off \
             --set front_app     drawing=off \
             --set volume_icon   drawing=off \
             --set spotify.anchor drawing=off \
             --set spotify.play  updates=off \
             --set brew          drawing=off \
             --set brew_status   drawing=off \
             --set volume        drawing=off \
             --set github.bell   drawing=off
}

zen_off() {
  echo "off" > "$ZEN_STATE_FILE"
  sketchybar --set wifi          drawing=on \
             --set apple.logo    drawing=on \
             --set '/cpu.*/'     drawing=on \
             --set calendar      icon.drawing=on \
             --set separator     drawing=on \
             --set front_app     drawing=on \
             --set volume_icon   drawing=on \
             --set spotify.play  updates=on \
             --set brew          drawing=on \
             --set brew_status   drawing=on \
             --set volume        drawing=on \
             --set github.bell   drawing=on
}

case "$1" in
  on)  zen_on  ;;
  off) zen_off ;;
  *)
    # Auto-toggle: read from state file, fall back to "off"
    STATE=$(cat "$ZEN_STATE_FILE" 2>/dev/null || echo "off")
    if [ "$STATE" = "on" ]; then
      zen_off
    else
      zen_on
    fi
    ;;
esac
