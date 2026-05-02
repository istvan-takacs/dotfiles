#!/bin/bash

# Cache Roman numerals for performance
declare -A ROMAN_CACHE=(
  [1]="I" [2]="II" [3]="III" [4]="IV" [5]="V" [6]="VI"
  [7]="VII" [8]="VIII" [9]="IX" [10]="X" [11]="XI" [12]="XII"
)

if [ "$SENDER" = "space_windows_change" ]; then
  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

  # Build app icons strip (with spacing between icons)
  icon_strip=""
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
    done <<< "${apps}"
    # Remove leading space
    icon_strip="${icon_strip:1}"
  else
    icon_strip="—"
  fi

  # Get workspace name and prepend Roman numeral (from cache)
  WORKSPACE_NAME=$("$CONFIG_DIR/plugins/workspace_names.sh" get "$space")
  ROMAN_NUM="${ROMAN_CACHE[$space]:-$space}"
  
  # Only update the label content, don't touch label.drawing
  # Let space_with_name.sh handle visibility
  sketchybar --set space.$space \
             icon="$ROMAN_NUM » $WORKSPACE_NAME" \
             label="$icon_strip"
fi
