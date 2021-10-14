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
- **Distro:** [Manjaro](https://www.manjaro.org/)
- **WM:** [i3-gaps](https://github.com/Airblader/i3)
- **Compositor:** [ibhagwan's picom](https://github.com/ibhagwan/picom)
- **Notification:** [dunst](https://github.com/dunst-project/dunst)
- **Bar:** [polybar](https://github.com/jaagr/polybar)
- **Launcher:** [rofi](https://github.com/DaveDavenport/rofi)
- **Wallpaper:** [feh](https://github.com/derf/feh)
- **Terminal:** [alacritty](https://st.suckless.org/)
- **Shell:** [zsh](https://www.zsh.org/)
  - [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
  - [zsh-autocomplete](https://github.com/zsh-users/zsh-autosuggestions)
  - [dotbare](https://github.com/kazhala/dotbare)
- **Login:** [lightdm](https://github.com/canonical/lightdm)
  - [lightdm-webkit2-greeter](https://github.com/sbalneav/lightdm-webkit2-greeter)
  - [Glorious Theme](https://github.com/manilarome/lightdm-webkit2-theme-glorious)
- **Color Scheme:** [pywal](https://github.com/dylanaraps/pywal)

- **Web Browser:** [Firefox](https://firefox.com)
- **Code Editor:** [Visual Studio Code (Transparent)](https://aur.archlinux.org/packages/code-transparent)
- **Music Player:** [Spotify](https://www.spotify.com/)

<a id="keybinds"></a>
## Keybinds ⌨️

These are the keybinds. Look through [`.config/i3/config`](https://github.com/gspalato/dotfiles/blob/master/.config/i3/config) for more details about the functionality.

|        Keybind         |                 Function                 |
| ---------------------- | ---------------------------------------- |
| `Win + Enter`          | Launch terminal (Alacritty)              |
| `Win + Shift + C`      | Close window                             |
| `Win + R`              | Open rofi menu                           |
| `Win + Shift + Q`      | Close window                             |
| `Win + Arrow`          | Change focus                             |
| `Win + Shift + Arrow`  | Move window                              |
| `Win + H`              | Split horizontally                       |
| `Win + V`              | Split vertically                         |
| `Win + F`              | Toggle fullscreen                        |
| `Win + S`              | Stacking mode                            |
| `Win + W`              | Tabbed mode                              |
| `Win + E`              | Toggle split                             |
| `Win + Shift + Space`  | Toggle floating                          |
| `Win + Space`          | Toggle focus between tiled and floating  |
| `Win + A`              | Focus parent                             |
| `Win + 1-9`            | Change workspace                         |
| `Win + Shift + 1-9`    | Move window to workspace                 |
| `Win + Tab`            | Next workspace                           |
| `Win + Shift + X`      | Move to scratchpad (hide/"minimize")     |
| `Win + Shift + S`      | Show scratchpad                          |
| `Win + Shift + C`      | Reload i3 configuration                  |
| `Win + Shift + R`      | Restart i3 in-place                      |
| `Win + Shift + E`      | Logout from i3                           |
| `Win + Shift + R`      | Toggle resize mode (arrows)              |
| `Win + PrtScr`         | Print screen with selection              |
| `Win + Shift + G`      | Open color grabber                       |

(Note: `Win` means `Super`)

<a id="install"></a>

## Installation ⬇️
~(WIP)~

- Install the [dependencies](#using).
- Clone the repo to `~/`.
- Put your wallpapers at `/usr/share/backgrounds`.
- That's it... I think.

#### LightDM
Follow the instructions from [the theme](https://github.com/manilarome/lightdm-webkit2-theme-glorious#Installation).

<a id="trouble"></a>


## Troubleshooting 🔧
### No audio or pulseaudio not working
This is usually due to `dbus` not launching.

#### Preface
LightDM doesn't launch `dbus`, unlike SDDM.
Therefore I had to append `export $(dbus-launch --auto-syntax)` to `~/.xprofile`, which's then loaded by LightDM.
Check out if `.xprofile` is being loaded by LightDM, or if it was altered.

### WiFi doesn't connect automatically
Yeah, I don't know how to fix this either.
To connect you can run `nmcli con up id <wifi name> --ask` on the terminal.
