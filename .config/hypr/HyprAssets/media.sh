#!/bin/bash

title=$(playerctl metadata title 2>/dev/null)

if [ -z "$title" ]; then
    echo -e "No Media\nPlaying"
else
    echo -e "󰎄 $title"
fi

