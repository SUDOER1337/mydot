#!/usr/bin/env bash

temp_raw=$(sensors k10temp-pci-00c3 | awk '/Tctl/ {gsub(/\+|°C/,""); print int($2)}')
icon=""  # Default icon

# Optional: Classy dynamic icon
if [ "$temp_raw" -gt 95 ]; then icon=""
elif [ "$temp_raw" -gt 85 ]; then icon=""
elif [ "$temp_raw" -gt 70 ]; then icon=""
elif [ "$temp_raw" -gt 50 ]; then icon=""
fi

echo "{\"text\": \"${temp_raw}$icon\"}"
