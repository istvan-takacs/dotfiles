#!/bin/bash

source "$CONFIG_DIR/colors.sh"

BREW_PATH="/opt/homebrew/bin/brew"
[ ! -x "$BREW_PATH" ] && BREW_PATH="/usr/local/bin/brew"

# Always clean up stale popup items before rebuilding
sketchybar --remove '/brew\.header/' 2>/dev/null
sketchybar --remove '/brew\.package\..*/' 2>/dev/null

# Get outdated packages (quiet: name + version only, no headers)
OUTDATED=$("$BREW_PATH" outdated 2>/dev/null)
COUNT=$(echo "$OUTDATED" | grep -c '^' 2>/dev/null)
[ -z "$OUTDATED" ] && COUNT=0

# Set label + icon colour
if [ "$COUNT" -eq 0 ]; then
  sketchybar --set brew label="􀆅" icon.color=$GREEN
  exit 0
elif [ "$COUNT" -lt 10 ]; then
  COLOR=$WHITE
elif [ "$COUNT" -lt 30 ]; then
  COLOR=$YELLOW
else
  COLOR=$ORANGE
fi

sketchybar --set brew label="$COUNT" icon.color="$COLOR"

# Build popup — header row
sketchybar --add item brew.header popup.brew \
           --set brew.header \
                 label="Outdated Packages ($COUNT)" \
                 label.font="$FONT:Bold:12.0" \
                 label.color=$GREY \
                 label.padding_left=10 \
                 label.padding_right=10 \
                 icon.drawing=off \
                 background.color=0x00000000

# One row per package
COUNTER=0
while IFS= read -r package; do
  [ -z "$package" ] && continue

  # Split "name (old) < new" → name and new version
  NAME=$(echo "$package" | awk '{print $1}')
  NEW=$(echo "$package" | awk '{print $NF}')

  sketchybar --add item "brew.package.$COUNTER" popup.brew \
             --set "brew.package.$COUNTER" \
                   icon="􀐛" \
                   icon.color=$BLUE \
                   icon.font="$FONT:Regular:11.0" \
                   icon.padding_left=10 \
                   icon.padding_right=4 \
                   label="$NAME  →  $NEW" \
                   label.font="$FONT:Semibold:12.0" \
                   label.color=$WHITE \
                   label.padding_right=16 \
                   background.color=0x00000000
  COUNTER=$((COUNTER + 1))
done <<< "$OUTDATED"
