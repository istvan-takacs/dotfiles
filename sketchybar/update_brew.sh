#!/bin/bash
# Fully self-contained — no sketchybar env vars needed.
# Called directly by launchd (hourly) and by sketchybarrc at startup.

BREW="/opt/homebrew/bin/brew"
[ ! -x "$BREW" ] && BREW="/usr/local/bin/brew"

SB="/opt/homebrew/bin/sketchybar"
[ ! -x "$SB" ] && SB="/usr/local/bin/sketchybar"
command -v sketchybar &>/dev/null && SB="sketchybar"

# ── Catppuccin Macchiato hex values (no sourcing needed) ─────────────────────
GREEN="0xffa6da95"   # up to date
WHITE="0xffcad3f5"   # < 10 outdated
YELLOW="0xffeed49f"  # < 30 outdated
ORANGE="0xfff5a97f"  # >= 30 outdated
GREY="0xff939ab7"
BLUE="0xff8aadf4"
FONT="SF Pro"

# ── Get outdated packages ─────────────────────────────────────────────────────
OUTDATED=$("$BREW" outdated --verbose 2>/dev/null)
COUNT=0
[ -n "$OUTDATED" ] && COUNT=$(echo "$OUTDATED" | grep -c '^')

# ── Update label + icon colour ────────────────────────────────────────────────
if [ "$COUNT" -eq 0 ]; then
  "$SB" --set brew label="􀆅" icon.color="$GREEN"
  # Remove stale popup items if any
  "$SB" --remove '/brew\.header/' 2>/dev/null
  "$SB" --remove '/brew\.package\..*/' 2>/dev/null
  exit 0
elif [ "$COUNT" -ge 30 ]; then
  COLOR="$ORANGE"
elif [ "$COUNT" -ge 10 ]; then
  COLOR="$YELLOW"
else
  COLOR="$WHITE"
fi

"$SB" --set brew label="$COUNT" icon.color="$COLOR"

# ── Rebuild popup ─────────────────────────────────────────────────────────────
# Always remove old items first so stale entries don't accumulate
"$SB" --remove '/brew\.header/' 2>/dev/null
"$SB" --remove '/brew\.package\..*/' 2>/dev/null

# Header row
"$SB" --add item brew.header popup.brew \
      --set brew.header \
            label="$COUNT packages outdated" \
            label.font="$FONT:Bold:11.0" \
            label.color="$GREY" \
            label.padding_left=10 \
            label.padding_right=10 \
            label.y_offset=0 \
            icon.drawing=off \
            background.color=0x00000000 \
            background.height=22

# One row per package — "name  →  target_version"
COUNTER=0
while IFS= read -r line; do
  [ -z "$line" ] && continue
  PKG_NAME=$(echo "$line" | awk '{print $1}')
  PKG_NEW=$(echo "$line"  | awk '{print $NF}')

  "$SB" --add item "brew.package.$COUNTER" popup.brew \
        --set "brew.package.$COUNTER" \
              icon="􀐛" \
              icon.color="$BLUE" \
              icon.font="$FONT:Regular:11.0" \
              icon.padding_left=10 \
              icon.padding_right=4 \
              label="${PKG_NAME}  →  ${PKG_NEW}" \
              label.font="$FONT:Semibold:12.0" \
              label.color="$WHITE" \
              label.padding_right=16 \
              background.color=0x00000000 \
              background.height=22

  COUNTER=$((COUNTER + 1))
done <<< "$OUTDATED"
