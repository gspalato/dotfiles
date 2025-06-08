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
                    Panels.dashboard.stack.pop();
                }
            }

            Common.StyledText {
                text: "Battery"
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
        }

        ColumnLayout {
            id: content
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
        }
    }
}
