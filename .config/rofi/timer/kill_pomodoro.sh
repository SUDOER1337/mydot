#!/bin/bash

# Set the paths to match your main timer script
TIMER_PID_FILE="/tmp/pomodoro_timer_pids"
TIMER_FILE="/tmp/pomodoro_timer.json"

# Kill any background countdowns
if [[ -f "$TIMER_PID_FILE" ]]; then
  while read -r pid; do
    kill "$pid" 2>/dev/null
  done < "$TIMER_PID_FILE"
  rm "$TIMER_PID_FILE"
  echo "Pomodoro timers killed."
else
  echo "No active timers found."
fi

# Reset Waybar display
echo "" > "$TIMER_FILE"

# Send notification
notify-send "󱎫 Pomodoro Stopped" "All timers were killed."

