#!/bin/bash

# --------- Config ---------
: "${ROFI_THEME:=~/.config/rofi/timer/timer.rasi}"
ROFI_CMD="rofi -theme ${ROFI_THEME}"
TIMER_FILE="/tmp/pomodoro_timer.json"
TIMER_PID_FILE="/tmp/pomodoro_timer_pids"

# --------- Kill All Timers (Handle early) ---------
if [[ "$1" == "kill" ]]; then
  if [[ -f "$TIMER_PID_FILE" ]]; then
    while read -r pid; do
      kill "$pid" 2>/dev/null
    done < "$TIMER_PID_FILE"
    rm "$TIMER_PID_FILE"
    echo "Pomodoro timers canceled!"
    notify-send "󱎫 Timer Stopped" "All timers terminated"
    echo "Idle" > "$TIMER_FILE"
  else
    echo "No active timers found."
    notify-send "󱎫 Timer" "No active timers found."
  fi
  exit 0
fi

# --------- Preset Menu ---------
PRESETS=(
  "󱎫 Pomodoro - 50m"
  "󰛨 Short Break - 5m"
  " Long Break - 15m"
  "󰒲 Power Nap - 30m"
  " Egg boiling - 9m"
  " Custom Input"
)

CHOICE=$(printf '%s\n' "${PRESETS[@]}" | $ROFI_CMD -dmenu -p " 󰥔 Choose a timer !")
[[ -z "$CHOICE" ]] && exit 1

# --------- Time Parsing ---------
parse_time() {
  INPUT="$1"
  NUMBER=$(echo "$INPUT" | grep -oE '[0-9]+')
  UNIT=$(echo "$INPUT" | grep -oE '[smh]')

  case "$UNIT" in
    h) SECONDS=$((NUMBER * 3600)) ;;
    m) SECONDS=$((NUMBER * 60)) ;;
    s|"") SECONDS=$NUMBER ;;
    *) echo "Invalid unit"; exit 1 ;;
  esac
}

if [[ "$CHOICE" == *"Custom Input"* ]]; then
  TIME_INPUT=$($ROFI_CMD -dmenu -p "Enter time (e.g. 5m, 30s, 1h):")
  [[ -z "$TIME_INPUT" ]] && exit 1
  parse_time "$TIME_INPUT"
  TITLE="Custom ($TIME_INPUT)"
else
  TIME_LABEL=$(echo "$CHOICE" | grep -oE '[0-9]+[smh]')
  parse_time "$TIME_LABEL"
  TITLE="$CHOICE"
fi

# --------- Kill Previous Running Timers ---------
if [[ -f "$TIMER_PID_FILE" ]]; then
  while read -r pid; do
    kill "$pid" 2>/dev/null
  done < "$TIMER_PID_FILE"
  rm "$TIMER_PID_FILE"
  echo '{"text": "--:--"}' > "$TIMER_FILE"
fi

# --------- Countdown with Output ---------
notify-send "󱎫 Timer started" "$TITLE"

  (
  END=$(( $(date +%s) + SECONDS ))
  while [ "$(date +%s)" -lt "$END" ]; do
    LEFT=$(( END - $(date +%s) ))

    HOURS=$(( LEFT / 3600 ))
    MIN=$(( (LEFT % 3600) / 60 ))
    SEC=$(( LEFT % 60 ))

    printf '%02d:%02d' "$MIN" "$SEC" > "$TIMER_FILE"

    sleep 1
  done



  echo "  " > "$TIMER_FILE"
  notify-send "󱎫 Timer Complete!" "$TITLE"
  playerctl -a pause
  paplay /usr/share/sounds/freedesktop/stereo/complete.oga
) &

echo $! >> "$TIMER_PID_FILE"

