pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import Qt.labs.folderlistmodel

import Quickshell.Services.Greetd

import "root:/components/dashboard" as Dashboard
import "root:/components/notifications" as Notifs
import "root:/components/common" as Common

import "root:/config"
import "root:/services"
import "root:/utils/colorUtils.js" as ColorUtils

ColumnLayout {
    id: root

    opacity: 0
    visible: false

    //anchors.left: parent.left
    //anchors.right: parent.right

    ColumnLayout {
        Layout.topMargin: 15
        Layout.bottomMargin: 0

        clip: true

        RowLayout {
            id: header

            spacing: 10

            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            Common.StyledButton {
                background: "transparent"

                borderColor: "transparent"

                Common.TintedIcon {
                    id: backButtonIcon
                    iconName: "chevron-left"
                    tint: Appearance.material_colors.on_surface
                    implicitSize: 24

                    anchors.centerIn: parent
                }

                onClick: {
                    Panels.dashboard.stack.popAnimated();
                }
            }

            Common.StyledText {
                text: "Wallpaper"
                font.pixelSize: Appearance.font.pixelSize.large
                font.weight: 600
                font.family: Appearance.font.family.display
                color: Appearance.material_colors.on_surface
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }
        }

        ColumnLayout {
            id: content
            Layout.fillWidth: true

            Item {
                id: listContainer

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.topMargin: 10
                Layout.leftMargin: 15
                Layout.bottomMargin: 10
                implicitHeight: Math.max(10, Math.min(wallpaperList.contentHeight, 600))
                //implicitWidth: content.width

                clip: true

                GridView {
                    id: wallpaperList

                    layer.enabled: true

                    anchors.fill: parent
                    width: listContainer.width

                    clip: true

                    cellWidth: (wallpaperList.width - 30) / 2 + 10
                    cellHeight: cellWidth / 16 * 9 + 10

                    model: Wallnut.wallpapersModel
                    reuseItems: true

                    delegate: Image {
                        id: wallpaperOption
                        required property string fileUrl

                        //height: 100
                        //width: height * 16 / 9
                        height: wallpaperList.cellHeight - 10
                        width: wallpaperList.cellWidth - 10
                        clip: false

                        sourceSize.width: width
                        sourceSize.height: height

                        cache: true

                        fillMode: Image.PreserveAspectCrop
                        mipmap: true

                        source: Qt.resolvedUrl(fileUrl)

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                id: wallpaperOptionMask
                                width: wallpaperOption.width
                                height: wallpaperOption.height
                                radius: 10
                                visible: false
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                Wallnut.apply(fileUrl);
                                root.shown = false;
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("wallpaper page loaded")
    }
}
