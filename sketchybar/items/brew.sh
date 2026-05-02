#!/bin/bash

sketchybar --add event brew_update

brew=(
  icon=􀐛
  icon.color=$WHITE
  label="…"
  padding_right=10
  script="$PLUGIN_DIR/brew.sh"
  click_script="$PLUGIN_DIR/brew_click.sh"
  popup.align=right
  popup.height=22
)

brew_bracket=(
  background.color=$BG1
  background.border_color=$BG2
  background.corner_radius=9
)

sketchybar --add item brew right \
           --set brew "${brew[@]}" \
           --subscribe brew brew_update \
           --add bracket brew_status brew \
           --set brew_status "${brew_bracket[@]}"

# Trigger first check immediately (launchd fires it hourly after that)
bash "$CONFIG_DIR/update_brew.sh" &
