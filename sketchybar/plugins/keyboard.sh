#!/bin/bash

# Get current keyboard layout
LAYOUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | sed -E 's/.*"KeyboardLayout Name" = "?([^"]*)"?;/\1/')

# If empty, try getting input source
if [ -z "$LAYOUT" ]; then
  LAYOUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID | awk -F. '{print $NF}')
fi

# Show only first 2-3 characters for compact display
LAYOUT_SHORT=$(echo "$LAYOUT" | cut -c1-3 | tr '[:lower:]' '[:upper:]')

sketchybar --set $NAME label="$LAYOUT_SHORT"
