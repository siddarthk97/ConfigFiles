#!/bin/bash
set -euxo pipefail

f1="/sys/class/backlight/amdgpu_bl1/brightness"
f2="/sys/class/backlight/amdgpu_bl1/max_brightness"

MAX_BRIGHTNESS=$(cat $f2)
CURR_BRIGHTNESS=$(cat $f1)
NEW_BRIGHTNESS=$(expr $CURR_BRIGHTNESS + $1)

if [ $NEW_BRIGHTNESS -lt $MAX_BRIGHTNESS ] && [ $NEW_BRIGHTNESS -gt 0 ]; then
    echo $NEW_BRIGHTNESS > $f1
fi
