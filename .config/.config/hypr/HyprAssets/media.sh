#!/bin/bash

title=$(playerctl metadata title 2>/dev/null)

if [ -z "$title" ]; then
    echo -e "No Media Playing"
else
    echo -e "󰎄 $title"
fi

