#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
## Edited by SUDOER1337 for Hyprland, AwesomeWM, and DWM Support
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Current Theme
dir="$HOME/.config/rofi/powermenu/"
theme='powermenu'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`

# Options
shutdown='⏻ Shutdown'
reboot=' Reboot'
lock=' Lock'
suspend='󰒲 Suspend'
logout='󰗽 Logout'
yes=' Yes'
no='󰜺 No'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "$host" \
        -mesg "Uptime: $uptime" \
        -theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# dwm logout logic
dwm_logout() {
    if pgrep -x "dwm" > /dev/null; then
        # Send SIGTERM to dwm to log out
        pkill -x dwm
        notify-send "dwm" "Logged out successfully."
    else
        notify-send "dwm" "dwm not running. Cannot logout."
    fi
}

# Execute Command
run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
            mpc -q pause
            amixer set Master mute
            systemctl suspend
        elif [[ "$1" == '--logout' ]]; then
            notify-send "Rofi Logout" "Attempting logout... Detected DESKTOP_SESSION=$DESKTOP_SESSION, XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP"

            if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
                openbox --exit
            elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
                bspc quit
            elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
                i3-msg exit
            elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
                qdbus org.kde.ksmserver /KSMServer logout 0 0 0
            elif [[ "$DESKTOP_SESSION" == 'awesome' || "$XDG_CURRENT_DESKTOP" == "awesome" || "$(pgrep -x awesome)" ]]; then
                if command -v awesome-client &> /dev/null; then
                    if awesome-client 'awesome.quit()'; then
                        notify-send "AwesomeWM" "Logout successful."
                    else
                        notify-send "AwesomeWM" "Logout failed. awesome-client returned error."
                    fi
                else
                    notify-send "AwesomeWM" "awesome-client not found in PATH."
                fi
            elif [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" || "$DESKTOP_SESSION" == "hyprland" ]]; then
                if command -v hyprctl &> /dev/null; then
                    if hyprctl dispatch exit; then
                        notify-send "Hyprland" "Logout successful via hyprctl."
                    else
                        notify-send "Hyprland" "Logout failed. hyprctl dispatch exit returned error."
                    fi
                else
                    notify-send "Hyprland" "hyprctl not found. Cannot logout safely."
                fi
            elif [[ "$DESKTOP_SESSION" == 'dwm' || "$XDG_CURRENT_DESKTOP" == "dwm" || "$(pgrep -x dwm)" ]]; then
                dwm_logout
            else
                notify-send "Logout" "No known WM detected. Please check your config."
            fi
        fi
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        run_cmd --shutdown
        ;;
    $reboot)
        run_cmd --reboot
        ;;
    $lock)
        if [[ -x '/usr/bin/hyprlock' ]]; then
            hyprlock
        elif [[ -x '/usr/bin/betterlockscreen' ]]; then
            /usr/bin/betterlockscreen -l
        else
            notify-send "No lockscreen found!" "Please install hyprlock, betterlockscreen, or i3lock."
        fi
        ;;
    $suspend)
        run_cmd --suspend
        ;;
   $logout)
        run_cmd --logout
        ;;
esac

