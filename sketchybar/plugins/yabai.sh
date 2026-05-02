#!/bin/bash

window_state() {
  source "$CONFIG_DIR/colors.sh"
  source "$CONFIG_DIR/icons.sh"

  WINDOW=$(yabai -m query --windows --window 2>/dev/null)

  # No focused window (e.g. desktop is focused)
  if [ -z "$WINDOW" ]; then
    sketchybar -m --animate sin 10 \
      --bar border_color=$BAR_BORDER_COLOR \
      --set $NAME icon=$YABAI_GRID icon.color=$GREY icon.width=24 label.width=0
    return
  fi

  STACK_INDEX=$(echo "$WINDOW" | jq '.["stack-index"]')
  COLOR=$BAR_BORDER_COLOR
  ICON=$YABAI_GRID
  LABEL=""

  if [ "$(echo "$WINDOW" | jq '.["is-floating"]')" = "true" ]; then
    ICON=$YABAI_FLOAT
    COLOR=$RED
  elif [ "$(echo "$WINDOW" | jq '.["has-fullscreen-zoom"]')" = "true" ]; then
    ICON=$YABAI_FULLSCREEN_ZOOM
    COLOR=$GREEN
  elif [ "$(echo "$WINDOW" | jq '.["has-parent-zoom"]')" = "true" ]; then
    ICON=$YABAI_PARENT_ZOOM
    COLOR=$BLUE
  elif [[ $STACK_INDEX -gt 0 ]]; then
    LAST_STACK_INDEX=$(yabai -m query --windows --window stack.last 2>/dev/null | jq '.["stack-index"]')
    ICON=$YABAI_STACK
    LABEL="$(printf "%s/%s" "$STACK_INDEX" "$LAST_STACK_INDEX")"
    COLOR=$MAGENTA
  else
    # Normal tiled: grey grid icon, bar border returns to default colour
    COLOR=$BAR_BORDER_COLOR
  fi

  args=(
    --bar border_color=$COLOR
    --animate sin 10
    --set $NAME
      icon=$ICON
      icon.color=$COLOR
      icon.width=24
  )

  # Show stack position label only when stacked
  if [ -n "$LABEL" ]; then
    args+=(label="$LABEL" label.width=36)
  else
    args+=(label.width=0)
  fi

  sketchybar -m "${args[@]}"
}

mouse_clicked() {
  yabai -m window --toggle float
  window_state
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked ;;
  "window_focus")  window_state  ;;
esac
