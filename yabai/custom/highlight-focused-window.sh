# #!/usr/bin/env bash
# # highlight-focused-window.sh

# # Get the ID of the focused window
# WINDOW_ID=$(yabai -m query --windows --window | jq '.id')

# # Optional: reset all windows to default border
# yabai -m query --windows | jq -r '.[] | .id' | xargs -I{} yabai -m window {} --border_color 0xff000000

# # Highlight the focused window
# yabai -m window $WINDOW_ID --border_color 0xffff0000  # red border