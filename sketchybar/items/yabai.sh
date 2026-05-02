#!/bin/bash

yabai=(
  script="$PLUGIN_DIR/yabai.sh"
  icon.font="$FONT:Bold:16.0"
  icon.width=24
  label.width=0
  display=active
  padding_left=4
  padding_right=4
)

sketchybar --add event window_focus            \
           --add item yabai left               \
           --set yabai "${yabai[@]}"           \
           --subscribe yabai window_focus      \
                             mouse.clicked
