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

# Use fzf with image preview to select a wallpaper
# This uses direct kitty protocol commands which Ghostty supports
selected_wallpaper=$(find_wallpapers | fzf --preview '
    # Get terminal dimensions
    COLUMNS=$FZF_PREVIEW_COLUMNS
    LINES=$FZF_PREVIEW_LINES
    
    # Calculate preview position and size
    WIDTH=$((COLUMNS * 9 / 10))
    HEIGHT=$((LINES * 7 / 10))
    
    # Print the filename first
    echo "$(basename {})"
    echo "Size: $(du -h {} | cut -f1)"
    echo "Resolution: $(identify -format "%wx%h" {} 2>/dev/null || echo "Unknown")"
    echo ""
    
    # Display image 
    # Using direct kitty protocol commands which Ghostty supports
    kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {} > /dev/tty
')

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
