#!/bin/bash

# ─── Reload Script for Hyprland Environment ─

# Kill waybar and dunst (suppress errors if already dead)
pkill waybar
pkill dunst
pkill mako
pkill swaync

# Reload Hyprland
hyprctl reload

# Restart waybar and dunst
waybar &
swaync &

# Send notification via dunstify
sleep 1 # give dunst a sec to start before we notify
notify-send "Done | 󰔓" "Reloaded config" -r 91190 -u low


