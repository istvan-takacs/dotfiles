#!/usr/bin/env bash
set -euo pipefail

YABAI=$(command -v yabai)
JQ=$(command -v jq)

destroy_empty_spaces() {
    # Keep trying until no empty spaces are found
    while true; do
        # Get current spaces
        SPACES=$($YABAI -m query --spaces)
        
        # Find first empty space (excluding space 1)
        EMPTY_SPACE=$( echo "$SPACES" | $JQ -r '
            map(select(.windows == [] and .index != 1))
            | if length > 0 then .[0].index else "none" end
        ')
        
        # Exit if no empty spaces found
        if [ "$EMPTY_SPACE" = "none" ]; then
            break
        fi
        
        # Destroy the empty space
        echo "Destroying empty space $EMPTY_SPACE"
        $YABAI -m space "$EMPTY_SPACE" --destroy
        
        # Small delay to let yabai update
        sleep 0.1
    done
}

destroy_empty_spaces