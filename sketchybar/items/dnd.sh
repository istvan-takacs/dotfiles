#!/bin/bash

source "$CONFIG_DIR/icons.sh"

dnd=(
  icon=􀆨
  icon.color=$GREY
  icon.font="$FONT:Bold:16.0"
  label.drawing=off
  update_freq=10
  script="$PLUGIN_DIR/dnd.sh"
  click_script="$PLUGIN_DIR/dnd_click.sh"
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  background.drawing=on
)

sketchybar --add item dnd right \
           --set dnd "${dnd[@]}" \
           --subscribe dnd mouse.entered mouse.exited mouse.clicked forced_update
