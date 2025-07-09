#!/bin/bash

battery_path=$(find /sys/class/power_supply/ -name "BAT*" | head -n 1)

# No battery = silent
if [ -z "$battery_path" ]; then
    exit 0
fi

capacity=$(cat "$battery_path/capacity")
status=$(cat "$battery_path/status")

# Battery icons (Nerd Fonts)
if [ "$capacity" -ge 95 ]; then
    icon=""  # Full
elif [ "$capacity" -ge 75 ]; then
    icon=""  # 75%
elif [ "$capacity" -ge 50 ]; then
    icon=""  # 50%
elif [ "$capacity" -ge 25 ]; then
    icon=""  # 25%
else
    icon=""  # Low
fi

if [ "$status" = "Charging" ]; then
    echo -e "$icon\n$capacity% 󱐋"
else
    echo -e "$icon\n$capacity%"
fi

