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

import Quickshell.Services.Greetd

import "root:/components/notifications" as Notifs
import "root:/components/shared" as Shared

import "root:/config"
import "root:/data"
import "root:/utils/colorUtils.js" as ColorUtils

Rectangle {
    id: dashboard
    property bool shown: false

    property var notificationList: notifList

    implicitHeight: layout.implicitHeight
    implicitWidth: parent.width
    transformOrigin: Item.TopRight

    color: ColorUtils.alpha(Matugen.surface_container, .8)

    antialiasing: true
    border.width: 1
    border.color: Qt.lighter(Matugen.background, 1.75)
    border.pixelAligned: true
    radius: 25

    layer.enabled: true
    layer.smooth: true

    scale: shown ? 1 : 0
    Behavior on scale {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    visible: true

    ColumnLayout {
        id: layout

        anchors.left: parent.left
        anchors.right: parent.right

        opacity: dashboard.scale

        ColumnLayout {
            Layout.topMargin: 15
            Layout.bottomMargin: 15

            spacing: 10

            RowLayout {
                id: header

                spacing: 10

                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 15
                Layout.rightMargin: 15

                Item {
                    height: 40
                    width: 40

                    Shared.Avatar {}
                }

                // Greeting text
                ColumnLayout {
                    id: greetingContainer
                    Layout.alignment: Qt.AlignVCenter

                    spacing: -2

                    Text {
                        id: greeting

                        property string username: ""
                        text: "Welcome back,"

                        font.family: Theme.fontFamily
                        font.pixelSize: 15
                        font.weight: 500
                        renderType: Text.NativeRendering

                        color: Theme.foreground
                    }

                    Text {
                        id: usernameLabel

                        property string username: ""
                        text: username

                        font.family: "Unbounded"
                        font.pixelSize: 17
                        font.weight: 500
                        renderType: Text.NativeRendering

                        color: Theme.foreground

                        // Get current username
                        Process {
                            id: proc
                            command: ["sh", "-c", "echo $USER"]
                            running: true

                            stdout: SplitParser {
                                onRead: data => usernameLabel.username = data
                            }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                RowLayout {
                    id: buttons

                    spacing: 5
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight

                    HeaderButton {
                        id: shutdownButton

                        IconImage {
                            anchors.centerIn: parent
                            implicitSize: 18
                            source: "root:/assets/icons/power.svg"
                        }
                    }
                }
            }

            // Sliders
            Rectangle {
                id: slidersBg

                implicitHeight: slidersContainer.implicitHeight
                implicitWidth: parent.width

                color: "#11ffffff"
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.fillWidth: true

                radius: 15

                GridLayout {
                    id: slidersContainer
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    ColumnLayout {
                        id: slidersContent
                        Layout.topMargin: 10
                        Layout.bottomMargin: 10
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        Layout.fillWidth: true

                        spacing: 15

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Shared.VolumeIcon {}

                            Shared.CustomSlider {
                                id: volumeSlider
                                Layout.fillWidth: true

                                fillColor: Matugen.primary

                                value: Audio.sink?.audio.volume
                                onValueChanged: {
                                    if (Audio.sink?.audio)
                                        Audio.sink.audio.volume = value;
                                }
                            }
                        }
                    }
                }
            }

            // Notifications
            Rectangle {
                id: notifsBg

                implicitHeight: notifsContainer.implicitHeight
                implicitWidth: parent.width

                color: "#11ffffff"
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.fillWidth: true

                radius: 15

                GridLayout {
                    id: notifsContainer
                    anchors.left: parent.left
                    anchors.right: parent.right

                    ColumnLayout {
                        id: notifsContent
                        Layout.fillWidth: true
                        Layout.topMargin: 10
                        Layout.bottomMargin: 10
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10

                        spacing: 10

                        // Notifications header
                        RowLayout {
                            spacing: 4

                            IconImage {
                                implicitSize: 16
                                source: "root:/assets/icons/notification.svg"
                            }

                            Text {
                                text: "Notifications"
                                font.family: Theme.fontFamily
                                font.pixelSize: 15
                                font.weight: 500
                                color: Theme.foreground
                                renderType: Text.NativeRendering
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            HeaderButton {
                                id: clearButton

                                height: 20
                                width: 20

                                background: "transparent"
                                border.width: 0

                                IconImage {
                                    anchors.centerIn: parent
                                    implicitSize: 16
                                    source: "root:/assets/icons/close.svg"
                                }

                                onClick: {
                                    notifList.clearAllNotifications();
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            clip: true

                            Layout.minimumHeight: emptyNotifText.height
                            Layout.preferredHeight: notifList.height

                            color: "transparent"
                            radius: 10

                            // Empty notifications message
                            Text {
                                id: emptyNotifText

                                anchors.centerIn: parent

                                text: "No notifications"
                                font.family: Theme.fontFamily
                                font.pixelSize: 14
                                font.weight: 300
                                color: Theme.foreground
                                verticalAlignment: Text.AlignVCenter
                                renderType: Text.NativeRendering

                                opacity: notifList.notifications.count === 0 ? 0.5 : 0
                                visible: opacity > 0

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 200
                                        easing.type: Easing.OutQuad
                                    }
                                }

                                height: 50
                            }

                            // Notifications list
                            Notifs.NotificationListView {
                                id: notifList

                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                            }
                        }
                    }
                }
            }

            // Tray
            Rectangle {
                id: trayBg

                implicitHeight: trayContainer.implicitHeight
                implicitWidth: parent.width

                color: "#11ffffff"
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.fillWidth: true

                radius: 15

                GridLayout {
                    id: trayContainer
                    anchors.left: parent.left
                    anchors.right: parent.right

                    ColumnLayout {
                        id: trayContent
                        Layout.fillWidth: true
                        Layout.topMargin: 10
                        Layout.bottomMargin: 10
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10

                        spacing: 10

                        // Notifications header
                        RowLayout {
                            spacing: 4

                            IconImage {
                                implicitSize: 16
                                source: "root:/assets/icons/ellipsis.svg"
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            ListView {
                                id: trayListView
                                Layout.fillHeight: true
                                Layout.preferredWidth: contentWidth

                                orientation: ListView.Horizontal
                                model: SystemTray.items.values

                                delegate: IconImage {
                                    id: trayIcon
                                    required property Notification modelData

                                    implicitSize: 16
                                    source: modelData.icon

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true

                                        onClicked: {}
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
