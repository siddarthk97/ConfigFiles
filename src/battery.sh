#!/bin/bash

DANGER=25
SLEEP=2

while true; do
    BAT_PERCENT=$(acpi | grep -o "[0-9]*%" | grep -o "[0-9]*")
    if [[ -z $(acpi | grep Charging) ]]; then
        if [[ $BAT_PERCENT -le $DANGER ]]; then
            i3-nagbar -m "Low Battery!!!" & PID=$!
        fi
        sleep $SLEEP"m"

        if [[ -n $(acpi | grep "Discharging") ]]; then
            sleep 0
        else
            kill -9 $PID
        fi
    fi
done
