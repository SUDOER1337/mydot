#!/bin/bash

HYPR_CONF="$HOME/.config/hypr/config/keybinds.conf"

mapfile -t BINDINGS < <(
    grep '^bind' "$HYPR_CONF" | \
    sed -E 's/[ \t]*#[ \t]*/#/' | \
    awk -F'#' '{
        split($1, parts, ",");
        mod=parts[1]; key=parts[2]; cmd="";
        for(i=4;i<=length(parts);i++) cmd = cmd parts[i] ",";
        sub(/,$/, "", cmd);
        desc=$2;
        gsub(/^[ \t]+|[ \t]+$/, "", desc);
        print "<b>"mod" + "key"</b>  <i>"desc"</i>"
    }'
)

CHOICE=$(printf '%s\n' "${BINDINGS[@]}" | rofi -dmenu -i -markup-rows -p "Hyprland Keybinds:")


CMD=$(echo "$CHOICE" | sed -n "s/.*<span color='gray'>\(.*\)<\/span>.*/\1/p")

if [[ $CMD == exec* ]]; then
    eval "$CMD"
else
    hyprctl dispatch "$CMD"
fi
