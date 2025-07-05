

#!/bin/bash

MONITOR_ID=1
STEP=5
VCP=10

get_brightness() {
    ddcutil --display "$MONITOR_ID" getvcp "$VCP" 2>/dev/null | grep "current value" | sed -E 's/.*current value = *([0-9]+),.*/\1/'
}

set_brightness() {
    ddcutil --display "$MONITOR_ID" setvcp "$VCP" "$1" >/dev/null
}

change_brightness() {
    current=$(get_brightness)
    case "$1" in
        up)
            new=$(( current + STEP ))
            [ "$new" -gt 100 ] && new=100
            ;;
        down)
            new=$(( current - STEP ))
            [ "$new" -lt 0 ] && new=0
            ;;
        *)
            new=$current
            ;;
    esac
    set_brightness "$new"
    echo "$new"
}

# Output section
case "$1" in
    up|down)
        change_brightness "$1" >/dev/null
        ;;
    *)
        brightness=$(get_brightness)
        echo "$brightness"
        echo "$brightness%"  # This becomes the tooltip content!
        ;;
esac

