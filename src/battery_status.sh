#!/usr/bin/env bash
STATUS=$(cat /sys/class/power_supply/BAT1/status)

OUTPUT=${STATUS}
COLOUR="#00FF00"
if [[ ${STATUS} == "Discharging" ]]; then
  PERCENT=$(cat /sys/class/power_supply/BAT1/capacity)
  OUTPUT="${OUTPUT}: ${PERCENT}%"
  if [[ ${PERCENT} -le 40 ]]; then
    COLOUR="#FF0000"
  elif [[ ${PERCENT} -le 70 ]]; then
    COLOUR="#FFF600"
  fi
fi

echo $OUTPUT
echo $OUTPUT
echo $COLOUR
