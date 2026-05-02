#!/bin/bash

# Cache Roman numerals for performance
declare -A ROMAN_CACHE=(
  [1]="I" [2]="II" [3]="III" [4]="IV" [5]="V" [6]="VI"
  [7]="VII" [8]="VIII" [9]="IX" [10]="X" [11]="XI" [12]="XII"
)

update() {
  source "$CONFIG_DIR/colors.sh"
  
  # Get workspace name from storage and prepend Roman numeral (from cache)
  WORKSPACE_NAME=$("$CONFIG_DIR/plugins/workspace_names.sh" get "${SID}")
  ROMAN_NUM="${ROMAN_CACHE[$SID]:-$SID}"
  
  # Update colors based on selection
  BORDER_COLOR=$BACKGROUND_2
  BG_COLOR=$BACKGROUND_1
  NAME_COLOR=$WHITE
  LABEL_COLOR=$GREY
  
  # Always show workspace name
  ICON_TEXT="$ROMAN_NUM » $WORKSPACE_NAME"
  
  # Only show app icons (label) when selected
  LABEL_DRAWING="off"
  
  if [ "$SELECTED" = "true" ]; then
    BORDER_COLOR=$GREEN
    BG_COLOR=$BG1
    NAME_COLOR=$GREEN
    LABEL_COLOR=$GREEN
    LABEL_DRAWING="on"
  fi
  
  # Set the workspace name (always visible) and app icons (only when selected)
  sketchybar --set $NAME \
    icon="$ICON_TEXT" \
    icon.color=$NAME_COLOR \
    icon.highlight=$SELECTED \
    label.color=$LABEL_COLOR \
    label.highlight=$SELECTED \
    label.drawing=$LABEL_DRAWING \
    background.border_color=$BORDER_COLOR \
    background.color=$BG_COLOR
}

rename_workspace() {
  # Dialog for renaming
  SPACE_NUM="${NAME:6}"  # Extract number from "space.X"
  CURRENT_NAME=$("$CONFIG_DIR/plugins/workspace_names.sh" get "$SPACE_NUM")
  ROMAN_NUM="${ROMAN_CACHE[$SPACE_NUM]:-$SPACE_NUM}"
  
  NEW_NAME=$(osascript -e "return (text returned of (display dialog \"Rename workspace $ROMAN_NUM:\" default answer \"$CURRENT_NAME\" with icon note buttons {\"Cancel\", \"Rename\"} default button \"Rename\"))" 2>/dev/null)
  
  if [ $? -eq 0 ] && [ -n "$NEW_NAME" ]; then
    # Save new name
    "$CONFIG_DIR/plugins/workspace_names.sh" set "$SPACE_NUM" "$NEW_NAME"
    
    # Update display with Roman numeral and separator
    sketchybar --set $NAME icon="$ROMAN_NUM » $NEW_NAME"
    
    # Also update yabai label
    yabai -m space "$SPACE_NUM" --label "$NEW_NAME"
  fi
}

focus_space() {
  # Immediately update highlighting for instant feedback
  source "$CONFIG_DIR/colors.sh"
  WORKSPACE_NAME=$("$CONFIG_DIR/plugins/workspace_names.sh" get "${SID}")
  ROMAN_NUM="${ROMAN_CACHE[$SID]:-$SID}"
  
  # Update this space to selected state immediately (show label/app icons)
  sketchybar --set $NAME \
    icon="$ROMAN_NUM » $WORKSPACE_NAME" \
    icon.color=$GREEN \
    icon.highlight=on \
    label.color=$GREEN \
    label.highlight=on \
    label.drawing=on \
    background.border_color=$GREEN \
    background.color=$BG1
  
  # Reset ALL other spaces to unselected (hide label/app icons)
  for i in {1..12}; do
    if [ $i -ne $SID ]; then
      WORKSPACE_NAME_OTHER=$("$CONFIG_DIR/plugins/workspace_names.sh" get "$i")
      ROMAN_NUM_OTHER="${ROMAN_CACHE[$i]:-$i}"
      sketchybar --set space.$i \
        icon="$ROMAN_NUM_OTHER » $WORKSPACE_NAME_OTHER" \
        icon.color=$WHITE \
        icon.highlight=off \
        label.color=$GREY \
        label.highlight=off \
        label.drawing=off \
        background.border_color=$BACKGROUND_2 \
        background.color=$BACKGROUND_1 2>/dev/null
    fi
  done
  
  # Then focus the space (happens in background)
  yabai -m space --focus $SID 2>/dev/null
}

destroy_space() {
  yabai -m space --destroy $SID
}

case "$SENDER" in
  "mouse.clicked")
    if [ "$BUTTON" = "right" ]; then
      destroy_space
    elif [ "$MODIFIER" = "shift" ]; then
      rename_workspace
    else
      focus_space
    fi
    ;;
  *)
    update
    ;;
esac
