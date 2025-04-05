#!/usr/bin/env python3

import os
import subprocess
import glob
from pathlib import Path

def find_wallpapers(directory):
    """Find image files in the given directory"""
    # Common image extensions
    extensions = ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.tiff", "*.bmp"]
    
    wallpapers = []
    for ext in extensions:
        pattern = os.path.join(directory, "**", ext)
        wallpapers.extend(glob.glob(pattern, recursive=True))
    
    return wallpapers

def select_wallpaper_with_fzf(wallpapers):
    """Use fzf to select a wallpaper with preview"""
    # Ghostty supports Kitty's image protocol
    # Adjust dimensions as needed for your terminal
    preview_cmd = "'kitten icat --clear --stdin no --transfer-mode file --place \"$(({2}*0.9))x$(({1}*0.5))+$(({2}*0.05))+$(({1}*0.2))\" {}'"
    
    # Try this alternative if the above doesn't work
    # preview_cmd = "'kitten icat {}'"
    
    # Or these fallbacks if image previews don't work
    # preview_cmd = "'chafa -s 80x40 \"{}\"'"
    # preview_cmd = "'file -b \"{}\"'"
    
    fzf_cmd = [
        "fzf",
        "--preview", preview_cmd,
        "--layout=reverse",
        "--border",
        "--height=80%",
        "--prompt=Select wallpaper: "
    ]
    
    # Join all wallpapers with newlines to pass to fzf
    all_wallpapers = "\n".join(wallpapers)
    
    # Execute fzf and get the selected wallpaper
    process = subprocess.Popen(
        fzf_cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    
    stdout, _ = process.communicate(input=all_wallpapers)
    
    # Return the selected wallpaper (removing trailing newline)
    return stdout.strip()

def apply_wallpaper(wallpaper_path):
    """Apply the selected wallpaper using matugen"""
    if not wallpaper_path:
        print("No wallpaper selected.")
        return False
    
    try:
        subprocess.run(["matugen", "image", wallpaper_path], check=True)
        print(f"Applied wallpaper: {wallpaper_path}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error applying wallpaper: {e}")
        return False

def main():
    # Get the wallpaper directory, using ~ expansion
    wallpaper_dir = os.path.expanduser("~/Pictures/Wallpapers")
    
    # Check if directory exists
    if not os.path.isdir(wallpaper_dir):
        print(f"Wallpaper directory not found: {wallpaper_dir}")
        return
    
    # Find all wallpapers
    wallpapers = find_wallpapers(wallpaper_dir)
    
    if not wallpapers:
        print(f"No wallpapers found in {wallpaper_dir}")
        return
    
    # Select a wallpaper
    selected = select_wallpaper_with_fzf(wallpapers)
    
    # Apply the selected wallpaper
    apply_wallpaper(selected)

if __name__ == "__main__":
    main()
