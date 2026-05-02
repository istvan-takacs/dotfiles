#!/bin/bash
# Handles only hover events for the brew popup.
# All data updates go through update_brew.sh directly.

case "$SENDER" in
  "mouse.entered")
    sketchybar --set brew popup.drawing=on
    ;;
  "mouse.exited" | "mouse.exited.global")
    sketchybar --set brew popup.drawing=off
    ;;
esac
