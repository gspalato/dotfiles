import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import "root:/config"
import "root:/services"

Scope {
    id: scope

    Loader {
        id: wallpaperSelectLoader
        active: true

        sourceComponent: PanelWindow {
            id: root

            WlrLayershell.namespace: "nox:wallpaper-select"
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Ignore

            property var focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)
            Connections {
                target: root
                function onFocusedScreenChanged() {
                    root.screen = root.focusedScreen;
                }
            }

            color: "transparent"

            height: 140

            anchors {
                left: true
                right: true
                bottom: true
                top: true
            }

            WallpaperSelect {
                id: content

                shown: false
            }

            mask: Region {
                item: Rectangle {
                    height: content.shown && content.height
                    width: content.shown && content.width
                    x: content.shown && content.x
                    y: content.shown && content.y
                    visible: false
                }
            }
        }
    }
}
