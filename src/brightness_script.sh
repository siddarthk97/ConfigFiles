#!/bin/bash

f1="/sys/class/backlight/intel_backlight/brightness"
f2="/sys/class/backlight/intel_backlight/max_brightness"

MAX_BRIGHTNESS=$(cat $f2)
CURR_BRIGHTNESS=$(cat $f1)
NEW_BRIGHTNESS=$(expr $CURR_BRIGHTNESS + $1)

if [ $NEW_BRIGHTNESS -lt $MAX_BRIGHTNESS ] && [ $NEW_BRIGHTNESS -gt 0 ]; then
    echo $NEW_BRIGHTNESS > $f1
fi
