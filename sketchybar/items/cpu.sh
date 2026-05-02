#!/usr/bin/env bash

cpu_percent=(
	background.padding_left=0
	background.padding_right=0
	label.font="$FONT:Heavy:12"
	label=CPU%
	label.color=$LABEL_COLOR
	icon="$CPU"
	icon.color=$BLUE
	update_freq=2
	mach_helper="$HELPER"
)

sketchybar --add item cpu.percent right \
	--set cpu.percent "${cpu_percent[@]}"
