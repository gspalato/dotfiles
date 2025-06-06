pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "root:/services"
import "root:/components/common" as Common
import "root:/config"
import "root:/utils/colorUtils.js" as ColorUtils

// Container
Common.BarModule {
    id: root

    Binding {
        root.implicitWidth: row.implicitWidth + Appearance.sizes.moduleHorizontalPadding
    }

    RowLayout {
        id: row
        spacing: 10

        anchors.centerIn: parent

        RowLayout {
            spacing: 0

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    networkNameRevealer.reveal = true;
                }
                onExited: {
                    networkNameRevealer.reveal = false;
                }
            }

            Common.NetworkIcon {
                Layout.alignment: Qt.AlignVCenter
            }

            Common.Revealer {
                id: networkNameRevealer
                vertical: false
                duration: 200

                RowLayout {
                    spacing: 10
                    Common.StyledText {
                        id: networkName
                        Layout.alignment: Qt.AlignVCenter
                        Layout.leftMargin: 10

                        text: Network.networkName
                    }

                    Common.Separator {
                        Layout.preferredHeight: networkName.height
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
        }

        Common.BluetoothIcon {
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
