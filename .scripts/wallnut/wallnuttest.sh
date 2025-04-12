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

# Get just the filenames (not the full paths)
get_wallpaper_filenames() {
    find "$WALLPAPER_DIR" -type f \( \
        -name "*.jpg" -o \
        -name "*.jpeg" -o \
        -name "*.png" -o \
        -name "*.webp" -o \
        -name "*.tiff" -o \
        -name "*.bmp" \
    \) -printf "%f\n" | sort
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

# Use fzf with ueberzugpp for preview - now using only filenames
selected_filename=$(get_wallpaper_filenames | fzf --reverse \
    --preview="fullpath=\"$WALLPAPER_DIR/{}\"; \
               echo -e \"File: {}\nSize: \$(du -h \"\$fullpath\" | cut -f1)\nResolution: \$(identify -format \"%wx%h\" \"\$fullpath\" 2>/dev/null || echo \"Unknown\")\n\"; \
               ueberzugpp cmd -s $SOCKET -i fzfpreview -a add \
               -x \$FZF_PREVIEW_LEFT -y \$((FZF_PREVIEW_TOP + 4)) \
               --max-width \$FZF_PREVIEW_COLUMNS --max-height \$((FZF_PREVIEW_LINES - 4)) \
               -f \"\$fullpath\"" \
    --bind "resize:reload(echo)")

# Clean up ueberzugpp
ueberzugpp cmd -s "$SOCKET" -a exit

# Exit if no wallpaper was selected
if [ -z "$selected_filename" ]; then
    wallnut_print "No wallpaper selected."
    exit 0
fi

# Simply construct the full path when needed
selected_wallpaper="$WALLPAPER_DIR/$selected_filename"

# Apply the selected wallpaper
wallnut_print "Applying wallpaper: $selected_filename"
matugen image "$selected_wallpaper"
wallust run "$selected_wallpaper"
# Copy it for hyprlock
cp "$selected_wallpaper" ~/.config/hypr/.current_wallpaper
# Alert!
wallnut_print "Wallpaper applied successfully!"
notify-send -a "Wallnut" "Changed wallpaper!" "$selected_filename" -i ~/.config/hypr/.current_wallpaper
