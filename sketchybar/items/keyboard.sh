#!/bin/bash

keyboard=(
  icon=􀇳
  icon.color=$BLUE
  label.padding_left=5
  script="$PLUGIN_DIR/keyboard.sh"
)

sketchybar --add item keyboard right \
           --set keyboard "${keyboard[@]}" \
           --subscribe keyboard keyboard_layout_changed
