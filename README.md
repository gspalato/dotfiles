<img src='https://i.ibb.co/GM08DRR/2021-10-10-14-53.png'>

<h1 align="center">ｄｏｔｆｉｌｅｓ</h1>

## Table of Contents

- [About ❓](#about)
- [Keybinds ⌨️](#keybinds)
- [Installation ⬇️](#installation)
- [Troubleshooting 🔧](#trouble)

<a id="about"></a>

## About ❓

Hey there, thanks for taking a look.
These are the dotfiles I use on my Linux setup.
There's still some useless stuff that was pushed (such as spicetify themes), but this is a WIP so expect there to be ~~many~~ some bugs.

<a id="using"></a>

### Using:
- **Distro:** [Arco Linux](https://arcolinux.com/)
- **WM:** [Hyprland](https://hyprland.org/)
- **Notification:** [dunst](https://github.com/dunst-project/dunst)
- **Launcher:** [rofi](https://github.com/DaveDavenport/rofi)
- **Wallpaper:** [swww](https://github.com/Horus645/swww)
- **Terminal:** [kitty](https://github.com/kovidgoyal/kitty)
- **Shell:** [zsh](https://www.zsh.org/)
  - [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
  - [zsh-autocomplete](https://github.com/zsh-users/zsh-autosuggestions)
  - [dotbare](https://github.com/kazhala/dotbare)
- **Login:** [sddm](https://github.com/canonical/lightdm)
- **Color Scheme:** [pywal](https://github.com/dylanaraps/pywal)
- **GTK Theme:** [wpgtk](https://github.com/dylanaraps/wpgtk)

- **Web Browser:** [Firefox Nightly](https://firefox.com)
- **Code Editor:** [Visual Studio Code (Transparent)](https://aur.archlinux.org/packages/code-transparent)
- **Music Player:** [Spotify](https://www.spotify.com/)

<a id="keybinds"></a>
## Keybinds ⌨️

These are the keybinds. Look through [`.config/hypr/hyprland.conf`](https://github.com/gspalato/dotfiles/blob/master/.config/hypr/hyprland.conf) for more details about the functionality.

|          Keybind          |                 Function                 |
| ------------------------- | ---------------------------------------- |
| `Super + Enter`           | Launch terminal (Kitty)                  |
| `Super + Q`               | Close window                             |
| `Super + R`               | Open Rofi                                | 
| `Super + Arrow` or `Super + RMB` | Resize window                     |
| `Super + Ctrl + H/L/K/J` or `Super + LMB`  | Move window             |
| `Super + F`               | Toggle fullscreen                        |
| `Super + Shift + Space`   | Toggle floating                          |
| `Super + Space`           | Toggle focus between tiled and floating  |
| `Super + 1-9`             | Change workspace                         |
| `Super + Shift + 1-9`     | Move window to workspace                 |
| `Super + Tab`             | Next workspace                           |
| `Super + U`               | Move to scratchpad (hide/minimize)       |
| `Super + Shift + U`       | Show scratchpad                          |
| `Super + Shift + Arrow`   | Resize active window                     |

<a id="install"></a>

## Installation ⬇️
~(WIP)~

- Install the [dependencies](#using).
- Clone the repo to `~/`.
- Put your wallpapers at `/usr/share/backgrounds`.
- That's it... I think.

<!--
#### LightDM
Follow the instructions from [the theme](https://github.com/manilarome/lightdm-webkit2-theme-glorious#Installation).
-->


<a id="trouble"></a>

## Troubleshooting 🔧

<!--
### No audio or pulseaudio not working
This is usually due to `dbus` not launching.

#### Preface
LightDM doesn't launch `dbus`, unlike SDDM.
Therefore I had to append `export $(dbus-launch --auto-syntax)` to `~/.xprofile`, which's then loaded by LightDM.
Check out if `.xprofile` is being loaded by LightDM, or if it was altered.

### WiFi doesn't connect automatically
Yeah, I don't know how to fix this either.
To connect you can run `nmcli con up id <wifi name> --ask` on the terminal.
-->