#!/bin/bash

# Toggle popup on click
CURRENT=$(sketchybar --query brew | jq -r .popup.drawing)

if [ "$CURRENT" = "on" ]; then
  sketchybar --set brew popup.drawing=off
else
  sketchybar --set brew popup.drawing=on
fi
