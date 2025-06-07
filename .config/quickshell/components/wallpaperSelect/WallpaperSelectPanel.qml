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
            focusable: true

            property var focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)
            Connections {
                target: root
                function onFocusedScreenChanged() {
                    root.screen = root.focusedScreen;
                }
            }

            color: "transparent"

            height: 200

            anchors {
                left: true
                right: true
                bottom: true
                top: false
            }

            Item {
                id: container

                height: root.height
                width: root.width

                WallpaperSelect {
                    id: content

                    Component.onCompleted: {
                        Panels.wallpaperSelect = content;
                    }
                }

                y: content.shown ? 0 : container.height
                Behavior on y {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            mask: Region {
                item: content.shown ? regionMask : null
            }

            Rectangle {
                id: regionMask
                height: container.height
                width: container.width
                x: container.x
                y: container.y
                visible: false
            }
        }
    }
}
