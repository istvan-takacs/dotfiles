#!/bin/bash

front_app=(
  label.font="$FONT:Semibold:13.0"
  icon.background.drawing=on
  display=active
  script="$PLUGIN_DIR/front_app.sh"
  click_script="open -a 'Mission Control'"
  padding_right=10
)

sketchybar --add item front_app right        \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched
