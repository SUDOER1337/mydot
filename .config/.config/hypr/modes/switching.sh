#!/bin/bash

CURRENT=$(readlink ~/.config/hypr/modes/current.conf)

if [[ "$CURRENT" == *"gappy.conf" ]]; then
    ln -sf ~/.config/hypr/modes/gapless.conf ~/.config/hypr/modes/current.conf
    notify-send -u low -t 600 "Hyprland" "Switched to Gapless mode"
else
    ln -sf ~/.config/hypr/modes/gappy.conf ~/.config/hypr/modes/current.conf
    notify-send -u low -t 600 "Hyprland" "Switched to Gappy mode"
fi

hyprctl reload
