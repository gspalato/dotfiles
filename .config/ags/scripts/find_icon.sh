#!/bin/bash

# Accept class name from argument
APP="$1"

if [[ -z "$APP" ]]; then
    echo "Usage: $0 <window-class-name>"
    exit 1
fi

# Try to find a matching .desktop file by StartupWMClass
DESKTOP=$(grep -ril "StartupWMClass=$APP" /usr/share/applications ~/.local/share/applications 2>/dev/null)

# Fallback: if no match by StartupWMClass, try filename match
if [[ -z "$DESKTOP" ]]; then
    for dir in /usr/share/applications ~/.local/share/applications; do
        if [[ -f "$dir/$APP.desktop" ]]; then
            DESKTOP="$dir/$APP.desktop"
            break
        fi
    done
fi

# If found, extract the Icon field
if [[ -n "$DESKTOP" ]]; then
    ICON=$(grep -i "^Icon=" "$DESKTOP" | head -n1 | cut -d'=' -f2)
    echo "$ICON"
else
    echo "No matching .desktop file found for '$APP'"
    exit 1
fi
