# #!/usr/bin/env bash

bluetooth=(
  icon="$BLUETOOTH_CONNECTED"
  icon.font="$FONT:Regular:16.0"
  icon.color="$BLUE"
  icon.drawing=on
  icon.padding_left=0
  icon.padding_right=0
  label.drawing=off
  script="$PLUGIN_DIR/bluetooth/scripts/bluetooth.sh"
  click_script="$PLUGIN_DIR/bluetooth/scripts/bluetooth_click.sh"
  update_freq=10
)

# actually add / set the item
sketchybar --add item bluetooth right \
           --set bluetooth "${bluetooth[@]}"
# source "$CONFIG_DIR/plugins/bluetooth/item.sh"