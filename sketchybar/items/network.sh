#!/usr/bin/env bash

network_down=(
	y_offset=-7
	label.font="$FONT:Heavy:10"
	label.color=$LABEL_COLOR
	icon="$NETWORK_DOWN"
	icon.font="SF Mono:Bold:16.0"
	icon.color=$GREEN
	icon.highlight_color=$BLUE
	update_freq=1
)

network_up=(
	background.padding_right=-70
	y_offset=7
	label.font="$FONT:Heavy:10"
	label.color=$LABEL_COLOR
	icon="$NETWORK_UP"
	icon.font="SF Mono:Bold:16.0"
	icon.color=$GREEN
	icon.highlight_color=$BLUE
	update_freq=1
	script="$PLUGIN_DIR/network.sh"
)

sketchybar 	--add item network.down right 						\
						--set network.down "${network_down[@]}" 	\
						--add item network.up right 							\
						--set network.up "${network_up[@]}"
