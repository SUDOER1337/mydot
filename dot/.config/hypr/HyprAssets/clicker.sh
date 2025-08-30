#!/bin/bash

# Toggle script for clicker 0.5.0

# Your clicker options
CLICKER_CMD="bash -e /usr/bin/clicker --button Left --click-time 10 --delay 1 --random-delay 10 --key LShift"

# Check if clicker is running
if pgrep -x "clicker" > /dev/null; then
    pkill -x clicker
    notify-send "Clicker" "Auto clicker stopped "
  else
    $CLICKER_CMD &
    notify-send "Clicker" "Auto clicker running "
fi

