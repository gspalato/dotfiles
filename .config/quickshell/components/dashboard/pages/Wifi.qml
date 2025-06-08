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

    //anchors.left: parent.left
    //anchors.right: parent.right

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
                    Panels.dashboard.stack.pop();
                }
            }

            Common.StyledText {
                text: "Wi-Fi"
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
                checked: Network.enabled

                onToggled: {
                    if (Network.enabled)
                        Network.disableWifi();
                    else
                        Network.enableWifi();
                }
            }
        }

        ColumnLayout {
            id: content
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            visible: Network.enabled && networkModel.count > 0

            ListView {
                id: networkList

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: Math.max(10, Math.min(contentHeight, 500))
                Layout.topMargin: 10

                spacing: 10

                model: ListModel {
                    id: networkModel

                    Component.onCompleted: {
                        Network.onEnabledChanged.connect(() => {
                            // If Wi-Fi is disabled, clear the model
                            if (!Network.enabled) {
                                networkModel.clear();
                            }
                        });

                        Network.onAvailableNetworksChanged.connect(() => {
                            // Update the model with available networks
                            // If a network is already in the model, update its signal strength

                            if (!Network.enabled) {
                                return;
                            }

                            Network.availableNetworks.forEach(network => {
                                // Find the index of the network in the model using a for loop.
                                let index = -1;
                                for (let i = 0; i < networkModel.count; i++) {
                                    if (networkModel.get(i).ssid === network.ssid) {
                                        index = i;
                                        break;
                                    }
                                }

                                // If the network is already in the model, update it; otherwise, append it.
                                if (index !== -1) {
                                    networkModel.set(index, {
                                        ssid: network.ssid,
                                        strength: network.strength,
                                        connected: network.connected
                                    });
                                } else {
                                    networkModel.append({
                                        ssid: network.ssid,
                                        strength: network.strength,
                                        connected: network.connected
                                    });
                                }
                            });
                        });
                    }
                }

                delegate: Item {
                    id: networkItem

                    required property string ssid
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

                    width: networkList.width

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

                                    anchors.verticalCenter: parent.verticalCenter

                                    spacing: 10

                                    Common.TintedIcon {
                                        iconName: Network.getIconNameForStrength(strength)
                                        tint: Appearance.material_colors.on_surface
                                        implicitSize: 20
                                    }

                                    Common.StyledText {
                                        text: ssid
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
