#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12")

# Cache Roman numerals for performance
declare -A ROMAN_CACHE=(
  [1]="I" [2]="II" [3]="III" [4]="IV" [5]="V" [6]="VI"
  [7]="VII" [8]="VIII" [9]="IX" [10]="X" [11]="XI" [12]="XII"
)

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))
  
  # Get initial workspace name and prepend Roman numeral (from cache)
  WORKSPACE_NAME=$("$CONFIG_DIR/plugins/workspace_names.sh" get "$sid")
  ROMAN_NUM="${ROMAN_CACHE[$sid]:-$sid}"

  space=(
    space=$sid
    
    # Workspace name (icon) - left side with Roman numeral and separator
    # Always visible
    icon="$ROMAN_NUM » $WORKSPACE_NAME"
    icon.font="$FONT:Bold:12.0"
    icon.color=$WHITE
    icon.highlight_color=$GREEN
    icon.padding_left=8
    icon.padding_right=8
    
    # App icons (label) - right side
    # Initially hidden, will show when selected
    label=""
    label.font="sketchybar-app-font:Regular:16.0"
    label.color=$GREY
    label.highlight_color=$GREEN
    label.padding_left=8
    label.padding_right=8
    label.drawing=off
    
    background.color=$BACKGROUND_1
    background.border_color=$BACKGROUND_2
    background.height=30
    background.corner_radius=9
    background.drawing=on
    
    script="$PLUGIN_DIR/space_with_name.sh"
  )

  sketchybar --add space space.$sid left \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid mouse.clicked space_change
done

space_creator=(
  icon=􀆊
  icon.font="$FONT:Heavy:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  display=active
  click_script='yabai -m space --create'
  script="$PLUGIN_DIR/space_windows.sh"
  icon.color=$WHITE
)

sketchybar --add item space_creator left \
           --set space_creator "${space_creator[@]}" \
           --subscribe space_creator space_windows_change
