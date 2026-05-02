#!/usr/bin/env bash

sketchybar -m --set "$NAME" label="$(df -H / | awk 'NR==2 { print $5 }')"