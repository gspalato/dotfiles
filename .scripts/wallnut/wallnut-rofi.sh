#!/bin/bash

image_dir="$HOME/Pictures/Wallpapers"
images=("$image_dir"/*)

image_list=""
for img in "${images[@]}"; do
    image_list+=$(basename "$img" | cut -d. -f1)"\x00icon\x1f${img}\n"
done

selected_image=$(printf '%b' "$image_list" | rofi -dmenu -theme ~/.config/rofi/style2.rasi -p "")

for img in "${images[@]}"; do
    if [[ "$(basename "$img" | cut -d. -f1)" = "$selected_image" ]]; then
        selected_image_path="$img"
        break
    fi
done

if [ -n "$selected_image_path" ]; then
  ln -sf "$selected_image_path" ~/wallpaper/wallpaper.png

  if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
    . ~/.config/hypr/scripts/set_wallpaper.sh
  else
    i3-msg restart
  fi

  # Apply the selected wallpaper
  wallnut_print "Applying wallpaper: $selected_wallpaper"

  matugen image "$selected_image_path"
  wallust run "$selected_image_path"

  # Copy it for hyprlock
  cp "$selected_image_path" ~/.config/hypr/.current_wallpaper

  # Alert!
  wallnut_print "Wallpaper applied successfully!"
  notify-send -a "Wallnut" "Changed wallpaper!" "$selected_image_path" -i ~/.config/hypr/.current_wallpaper
fi
