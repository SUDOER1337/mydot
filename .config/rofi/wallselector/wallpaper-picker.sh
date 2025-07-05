#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
THUMB_DIR="$HOME/.cache/wallpaper-thumbs"
ROFI_THEME="$HOME/.config/rofi/wallselector/wallselector.rasi"

mkdir -p "$THUMB_DIR"

# Generate thumbnails using ImageMagick (magick from ImageMagick 7+)
for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
    [[ -f "$img" ]] || continue
    thumb="$THUMB_DIR/$(basename "$img").png"
    if [[ ! -f "$thumb" ]]; then
        magick "$img" -resize 256x144^ -gravity center -extent 256x144 "$thumb"
    fi
done

# Rofi selection with custom theme and icons
CHOICE=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    | while read -r img; do
        fname=$(basename "$img")
        echo -en "$fname\x00icon\x1f$THUMB_DIR/$fname.png\n"
    done | rofi -dmenu -i -p " Choose Wallpaper" -show-icons -theme "$ROFI_THEME")

# Set wallpaper with swww if a choice was made
[[ -n "$CHOICE" ]] && swww img "$WALLPAPER_DIR/$CHOICE" --transition-type any --transition-fps 60 --transition-duration 1
