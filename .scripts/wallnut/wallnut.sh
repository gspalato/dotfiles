#!/bin/bash
# Path to wallpapers directory
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Check if directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

wallnut_print() {
    # ANSI color codes for a nice aesthetic
    local GREEN='\033[0;32m'
    local BLUE='\033[0;94m'
    local RESET='\033[0m'
    
    echo -e "${BLUE}[Wallnut]${RESET} $1"
}

# Find all image files
find_wallpapers() {
    find "$WALLPAPER_DIR" -type f \( \
        -name "*.jpg" -o \
        -name "*.jpeg" -o \
        -name "*.png" -o \
        -name "*.webp" -o \
        -name "*.tiff" -o \
        -name "*.bmp" \
    \) | sort
}

# Set up ueberzugpp
case "$(uname -a)" in
    *Darwin*) UEBERZUG_TMP_DIR="$TMPDIR" ;;
    *) UEBERZUG_TMP_DIR="/tmp" ;;
esac

cleanup() {
    ueberzugpp cmd -s "$SOCKET" -a exit
}

trap cleanup HUP INT QUIT TERM EXIT

UB_PID_FILE="$UEBERZUG_TMP_DIR/.$(uuidgen)"
ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file "$UB_PID_FILE"
UB_PID=$(cat "$UB_PID_FILE")
export SOCKET="$UEBERZUG_TMP_DIR"/ueberzugpp-"$UB_PID".socket

# Use fzf with ueberzugpp for preview
selected_wallpaper=$(find_wallpapers | fzf --reverse \
    --preview="echo -e \"File: \$(basename {})\nSize: \$(du -h {} | cut -f1)\nResolution: \$(identify -format \"%wx%h\" {} 2>/dev/null || echo \"Unknown\")\n\"; \
               ueberzugpp cmd -s $SOCKET -i fzfpreview -a add \
               -x \$FZF_PREVIEW_LEFT -y \$((FZF_PREVIEW_TOP + 4)) \
               --max-width \$FZF_PREVIEW_COLUMNS --max-height \$((FZF_PREVIEW_LINES - 4)) \
               -f {}" \
    --bind "resize:reload(echo)" \
    --preview-window "right:60%" \
    --with-nth -1)

# Clean up ueberzugpp
ueberzugpp cmd -s "$SOCKET" -a exit

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
cp "$selected_wallpaper" ~/.current.wall

# Alert!
wallnut_print "Wallpaper applied successfully!"
notify-send -a "Wallnut" "Changed wallpaper!" "$(basename $selected_wallpaper)" -i ~/.config/hypr/.current_wallpaper
