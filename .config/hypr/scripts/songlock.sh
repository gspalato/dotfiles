#!/bin/bash

# Try to get metadata from any player
metadata=$(playerctl metadata --format '{{playerName}}|{{status}}|{{artist}}|{{title}}' 2>/dev/null)

# If there's no player or it's not playing, exit silently
if [[ -z "$metadata" ]]; then
    exit 0
fi

IFS='|' read -r player status artist title <<< "$metadata"

# Only continue if status is Playing
if [[ "$status" != "Playing" ]]; then
    exit 0
fi

# Define icons
spotify_icon=" "   # Nerd Font icon for Spotify
default_icon="🎵"  # Emoji for other players

# Choose icon and format output
if [[ "$player" == "spotify" ]]; then
    echo "$spotify_icon $artist - $title"
else
    echo "$default_icon $artist - $title"
fi

