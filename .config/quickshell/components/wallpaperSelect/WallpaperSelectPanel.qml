//pragma ComponentBehavior: Bound

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

            //height: 200

            anchors {
                left: true
                right: true
                bottom: true
                top: true
            }

            Item {
                id: background
                anchors.fill: parent

                Rectangle {
                    id: darken
                    anchors.fill: root
                    color: "#33000000"
                    visible: opacity > 0
                    opacity: root.shown ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                            easing.type: Appearance.easings.main
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            root.hide();
                        }
                    }
                }
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
