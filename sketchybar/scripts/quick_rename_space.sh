#!/bin/bash

SPACE_NUM=$1

# Cache Roman numerals for performance
declare -A ROMAN_CACHE=(
  [1]="I" [2]="II" [3]="III" [4]="IV" [5]="V" [6]="VI"
  [7]="VII" [8]="VIII" [9]="IX" [10]="X" [11]="XI" [12]="XII"
)

# Get current name
CURRENT_NAME=$(~/.config/sketchybar/plugins/workspace_names.sh get "$SPACE_NUM")
ROMAN_NUM="${ROMAN_CACHE[$SPACE_NUM]:-$SPACE_NUM}"

# Prompt for new name
NEW_NAME=$(osascript -e "return (text returned of (display dialog \"Rename workspace $ROMAN_NUM:\" default answer \"$CURRENT_NAME\" with icon note buttons {\"Cancel\", \"Rename\"} default button \"Rename\"))" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$NEW_NAME" ]; then
    # Save new name
    ~/.config/sketchybar/plugins/workspace_names.sh set "$SPACE_NUM" "$NEW_NAME"
    
    # Update yabai
    yabai -m space "$SPACE_NUM" --label "$NEW_NAME"
    
    # Update sketchybar with Roman numeral and separator
    sketchybar --set space.$SPACE_NUM icon="$ROMAN_NUM » $NEW_NAME"
fi
