#!/bin/bash

# Store workspace names in a simple config file
NAMES_FILE="$HOME/.config/sketchybar/workspace_names.conf"

# Initialize names file if it doesn't exist
if [ ! -f "$NAMES_FILE" ]; then
    cat > "$NAMES_FILE" << 'EOF'
# Workspace names configuration
# Format: SPACE_NUMBER=NAME
1=Main
2=Code
3=Web
4=Chat
5=Media
6=Misc
EOF
fi

# Get name for a space
get_name() {
    local space_num=$1
    local name=$(grep "^${space_num}=" "$NAMES_FILE" | cut -d'=' -f2)
    echo "${name:-$space_num}"
}

# Set name for a space
set_name() {
    local space_num=$1
    local new_name=$2
    
    # Remove old entry if exists
    sed -i '' "/^${space_num}=/d" "$NAMES_FILE"
    
    # Add new entry
    echo "${space_num}=${new_name}" >> "$NAMES_FILE"
}

# Export functions for use in other scripts
case "$1" in
    "get")
        get_name "$2"
        ;;
    "set")
        set_name "$2" "$3"
        ;;
esac
