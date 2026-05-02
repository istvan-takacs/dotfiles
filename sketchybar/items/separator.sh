#!/bin/bash

# Separator between front_app and system stats
sketchybar --add item separator.system right \
           --set separator.system icon="􀆊" \
                          icon.color=$GREY \
                          icon.font="$FONT:Bold:16.0" \
                          icon.padding_left=8 \
                          icon.padding_right=8 \
                          background.drawing=off \
                          label.drawing=off

# Separator between system stats and network/battery section
sketchybar --add item separator.info right \
           --set separator.info icon="􀆊" \
                          icon.color=$GREY \
                          icon.font="$FONT:Bold:16.0" \
                          icon.padding_left=8 \
                          icon.padding_right=8 \
                          background.drawing=off \
                          label.drawing=off
