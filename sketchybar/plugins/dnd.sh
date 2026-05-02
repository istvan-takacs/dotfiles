#!/bin/bash

check_dnd_status() {
  local dnd_status=$(defaults read ~/Library/Preferences/ByHost/com.apple.notificationcenterui.*.plist doNotDisturb 2>/dev/null | head -1)
  if [ "$dnd_status" = "1" ]; then
    echo "on"
    return
  fi
  
  dnd_status=$(plutil -extract dnd_prefs.userPref.enabled raw -expect boolean /Library/Preferences/com.apple.notificationcenterui.plist 2>/dev/null)
  if [ "$dnd_status" = "true" ]; then
    echo "on"
    return
  fi
  
  echo "off"
}

source "$CONFIG_DIR/colors.sh"
DND_STATUS=$(check_dnd_status)

if [ "$DND_STATUS" = "on" ]; then
  ICON="􀆺"
  COLOR=$MAGENTA
else
  ICON="􀆨"
  COLOR=$GREY
fi

case "$SENDER" in
  "mouse.entered")
    sketchybar --set $NAME background.color=$BACKGROUND_2
    ;;
  "mouse.exited")
    sketchybar --set $NAME background.color=$BACKGROUND_1
    ;;
  *)
    sketchybar --set $NAME icon="$ICON" icon.color=$COLOR
    ;;
esac
