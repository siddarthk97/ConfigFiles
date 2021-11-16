#!/usr/bin/env bash 

if [ -x "$(command -v xinput)" ]; then
  xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
  xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Natural Scrolling Enabled" 1
elif [ -x "$(command -v synclient)" ]; then
  synclient VertScroll=-79 TapButton1=1 TapButton2=3 TapButton3=2 PalmWidth=4 PalmMinZ=50 PalmDetect=1 VertScrollDelta=-79 HorizScrollDelta=-79
else
  echo "xinput and synclient not found..."
  exit 1
fi
