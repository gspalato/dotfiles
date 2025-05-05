#!/bin/bash

icon_name="$1"
icon_type="$2"  # Can be 'program' or 'symbolic'
size="${3:-64}"

# Categories for program icons (e.g., apps)
program_categories=("apps" "categories")

# Categories for symbolic icons (e.g., status or actions)
symbolic_categories=("status" "actions" "devices" "emblems" "mimetypes")

# Common icon directories
icon_dirs=(
    "$HOME/.icons"
    "$HOME/.local/share/icons"
    "/usr/share/icons"
    "/usr/local/share/icons"
    "/usr/share/pixmaps"
)

# Common extensions
extensions=("png" "svg" "xpm")

# Function to resolve icons for a given category and type
resolve_icons() {
    local categories=("$@")
    for base in "${icon_dirs[@]}"; do
        [[ -d "$base" ]] || continue

        while IFS= read -r -d '' theme_dir; do
            for cat in "${categories[@]}"; do
                for ext in "${extensions[@]}"; do
                    matches=$(find "$theme_dir" -type f -path "*/$size*/$cat/$icon_name.$ext" 2>/dev/null)
                    [[ -n "$matches" ]] && echo "$matches" && exit 0
                done
            done
        done < <(find "$base" -maxdepth 1 -mindepth 1 -type d -print0)
    done
}

# Check the type and resolve accordingly
if [[ "$icon_type" == "program" ]]; then
    resolve_icons "${program_categories[@]}"
elif [[ "$icon_type" == "symbolic" ]]; then
    resolve_icons "${symbolic_categories[@]}"
else
    echo "Invalid icon type. Use 'program' or 'symbolic'." >&2
    exit 1
fi

# Fallback: Try directly in base dirs if no match found
for dir in "${icon_dirs[@]}"; do
    for ext in "${extensions[@]}"; do
        [[ -f "$dir/$icon_name.$ext" ]] && echo "$dir/$icon_name.$ext" && exit 0
    done
done

echo "Icon '$icon_name' not found." >&2
exit 1
