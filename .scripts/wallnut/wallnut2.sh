#!/bin/bash

# Wallpaper Selection Script
# Uses rofi to display and select wallpapers from ~/Pictures/Wallpapers

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

wallnut_print() {
    # ANSI color codes for a nice aesthetic
    local GREEN='\033[0;32m'
    local BLUE='\033[0;94m'
    local RESET='\033[0m'

    echo -e "${BLUE}[Wallnut]${RESET} $1"
}

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist."
    exit 1
fi

images=("$WALLPAPER_DIR"/*)

image_list=""
for img in "${images[@]}"; do
    image_list+=$(basename "$img" | cut -d. -f1)"\x00icon\x1f${img}\n"
done

selected=$(printf '%b' "$image_list" | rofi -dmenu -theme ~/.config/rofi/wallpaper-select.rasi -p "Select wallpaper")

# Exit if no selection was made
if [ -z "$selected" ]; then
    echo "No wallpaper selected"
    exit 0
fi

# Find the full path of the selected wallpaper
selected_wallpaper=$(find "$WALLPAPER_DIR" -type f -name "$selected")

# Exit if no wallpaper was selected
if [ -z "$selected_wallpaper" ]; then
    wallnut_print "No wallpaper selected."
    exit 0
fi

# Apply the selected wallpaper
wallnut_print "Applying wallpaper: $selected_wallpaper"
matugen image "$selected_wallpaper"
wallust run "$selected_wallpaper"

# Copy it for hyprlock
cp "$selected_wallpaper" ~/.config/hypr/.current_wallpaper
wallnut_print "Wallpaper applied successfully!"
