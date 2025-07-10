#!/bin/bash
battery_path=$(find /sys/class/power_supply/ -name "BAT*" | head -n 1)
ac_path=$(find /sys/class/power_supply/ -name "AC*" | head -n 1)

# Desktop (no battery detected)
if [ -z "$battery_path" ]; then
    if [ -n "$ac_path" ]; then
        online=$(cat "$ac_path/online")
        if [ "$online" -eq 1 ]; then
            echo "󰚥 AC (No Battery)"
        fi
    fi
    exit 0
fi

# Battery stats
capacity=$(cat "$battery_path/capacity")
status=$(cat "$battery_path/status")

# Nerd Font Battery Icons
if [ "$capacity" -ge 95 ]; then
    icon=""
elif [ "$capacity" -ge 75 ]; then
    icon=""
elif [ "$capacity" -ge 50 ]; then
    icon=""
elif [ "$capacity" -ge 25 ]; then
    icon=""
else
    icon=""
fi

if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
    echo -e "$icon\n$capacity% 󰚥"
else
    echo -e "$icon\n$capacity%"
fi

