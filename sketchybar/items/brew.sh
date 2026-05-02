#!/bin/bash

brew=(
  icon=􀐛
  icon.color=0xffcad3f5
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
           --subscribe brew mouse.entered mouse.exited mouse.exited.global \
           --add bracket brew_status brew \
           --set brew_status "${brew_bracket[@]}"

# Run updater immediately in background — launchd fires it hourly after that
bash "$CONFIG_DIR/update_brew.sh" &
