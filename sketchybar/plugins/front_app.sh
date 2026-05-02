#!/bin/bash

if [ "$SENDER" = "front_app_switched" ]; then
  # Only update if the app actually changed (avoid redundant updates)
  # Cache the last app to prevent unnecessary redraws
  CACHE_FILE="/tmp/sketchybar_front_app.cache"
  
  if [ -f "$CACHE_FILE" ]; then
    LAST_APP=$(cat "$CACHE_FILE")
  else
    LAST_APP=""
  fi
  
  # Only update if app is different
  if [ "$INFO" != "$LAST_APP" ]; then
    echo "$INFO" > "$CACHE_FILE"
    sketchybar --set $NAME label="$INFO" icon.background.image="app.$INFO" &
  fi
fi