#!/bin/bash

sketchybar --set $NAME icon="$(date '+%a %d %b')" \
                      label="$(date '+%H:%M')" \
                      icon.padding_right=0 \
                      icon.align=left \
                      label.align=left \
                      label.padding_left=5