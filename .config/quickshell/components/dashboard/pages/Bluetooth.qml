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

    ColumnLayout {
        Layout.topMargin: 15
        Layout.bottomMargin: 15

        RowLayout {
            id: header

            spacing: 10

            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            Common.Button {
                background: "transparent"

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
                text: "Bluetooth"
                font.pixelSize: Appearance.font.pixelSize.large
                font.weight: 600
                font.family: Appearance.font.family.display
                color: Appearance.material_colors.on_surface
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            Common.StyledSwitch {
                checked: Bluetooth.enabled

                onToggled: {
                    if (Bluetooth.enabled)
                        Bluetooth.disable();
                    else
                        Bluetooth.enable();
                }
            }
        }

        ColumnLayout {
            id: content
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            visible: Bluetooth.enabled && deviceList.count > 0

            ListView {
                id: deviceList

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: Math.max(10, Math.min(contentHeight, 500))
                Layout.topMargin: 10

                spacing: 10

                model: ListModel {
                    id: deviceModel

                    Component.onCompleted: {
                        Bluetooth.onEnabledChanged.connect(() => {
                            if (!Bluetooth.enabled) {
                                // Clear the model if Bluetooth is disabled
                                deviceModel.clear();
                            }
                        });

                        Bluetooth.onAvailableDevicesChanged.connect(() => {
                            // Update the model with available devices
                            // If a device is already in the model, update its signal strength

                            if (!Bluetooth.enabled) {
                                return;
                            }

                            Bluetooth.availableDevices.forEach(device => {
                                // Find the index of the device in the model using a for loop.
                                let index = -1;
                                for (let i = 0; i < deviceModel.count; i++) {
                                    if (deviceModel.get(i).name === device.name) {
                                        index = i;
                                        break;
                                    }
                                }

                                // If the device is already in the model, update it; otherwise, append it.
                                if (index !== -1) {
                                    deviceModel.set(index, {
                                        name: device.name,
                                        strength: device.strength,
                                        connected: device.connected
                                    });
                                } else {
                                    deviceModel.append({
                                        name: device.name,
                                        strength: device.strength,
                                        connected: device.connected
                                    });
                                }
                            });
                        });
                    }
                }

                delegate: Item {
                    id: deviceItem

                    required property string name
                    required property int strength
                    required property bool connected

                    property bool collapsed: true

                    height: button.implicitHeight
                    Behavior on height {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }

                    width: deviceList.width

                    Common.Button {
                        id: button
                        anchors.fill: parent

                        implicitHeight: layout.implicitHeight

                        onClick: {
                            collapsed = !collapsed;
                        }

                        ColumnLayout {
                            id: layout
                            anchors.left: parent.left
                            anchors.right: parent.right

                            ColumnLayout {
                                id: contentColumn

                                Layout.fillWidth: true
                                Layout.leftMargin: 15
                                Layout.rightMargin: 15
                                Layout.topMargin: 10
                                Layout.bottomMargin: 10

                                spacing: 0

                                RowLayout {
                                    id: rowLayout

                                    //anchors.verticalCenter: parent.verticalCenter

                                    spacing: 10

                                    Common.TintedIcon {
                                        iconName: "bluetooth-on"
                                        tint: Appearance.material_colors.on_surface
                                        implicitSize: 20
                                    }

                                    Common.StyledText {
                                        text: name
                                        font.pixelSize: Appearance.font.pixelSize.large
                                        font.family: Appearance.font.family.main
                                        font.weight: 500
                                        color: Appearance.material_colors.on_surface
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Common.TintedIcon {
                                        id: connectionIcon
                                        iconName: "check"
                                        tint: Appearance.material_colors.on_surface
                                        implicitSize: 20

                                        visible: connected
                                    }
                                }

                                Common.Revealer {
                                    id: revealer
                                    visible: false

                                    reveal: !collapsed

                                    Layout.fillWidth: true

                                    Item {
                                        height: passwordRow.implicitHeight + 10

                                        RowLayout {
                                            id: passwordRow
                                            anchors.bottom: parent.bottom
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
}
