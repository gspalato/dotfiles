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

import "root:/components/common" as Common

import "root:/config"
import "root:/services"

import "root:/utils/colorUtils.js" as ColorUtils

Common.Button {
    id: wifiButton

    implicitHeight: buttonContentPadding.implicitHeight
    implicitWidth: buttonContentPadding.implicitWidth

    property bool isConnected: Network.wifi || Network.ethernet
    background: isConnected ? Appearance.material_colors.primary_container : "#11ffffff"
    backgroundHover: isConnected ? ColorUtils.mix(Appearance.material_colors.primary_container, "#000000", .9) : "#22ffffff"
    backgroundPressed: isConnected ? ColorUtils.mix(Appearance.material_colors.primary_container, "#000000", .8) : "#33ffffff"
    property color textColor: isConnected ? Appearance.material_colors.on_primary_container : Appearance.material_colors.on_surface

    RowLayout {
        id: buttonContentPadding
        spacing: 0

        anchors.fill: parent

        RowLayout {
            Layout.margins: 15
            spacing: 10

            Common.NetworkIcon {
                implicitSize: 20
                Layout.alignment: Qt.AlignVCenter
            }

            Common.StyledText {
                text: "Wi-Fi"
                font.pixelSize: Appearance.font.pixelSize.small
                font.weight: 500
                color: Appearance.material_colors.on_primary_container
                verticalAlignment: Text.AlignVCenter

                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }

        Common.Separator {
            Layout.preferredHeight: 20
            Layout.preferredWidth: 1
            Layout.alignment: Qt.AlignVCenter
            color: "#1fffffff"
        }

        Item {
            Layout.fillHeight: true
            Layout.preferredWidth: 40

            Common.TintedIcon {
                anchors.centerIn: parent

                implicitSize: 24
                iconName: "chevron-right"
                tint: Appearance.material_colors.on_primary_container
            }
        }
    }
}
