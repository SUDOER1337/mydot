#!/bin/bash

# Check if Waybar is running
if pgrep -x "waybar" > /dev/null; then
    # Kill Waybar
    pkill waybar
else
    # Launch Waybar
    waybar &
fi

