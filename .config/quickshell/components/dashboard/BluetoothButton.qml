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
import "root:/shaders" as Shaders

import "root:/utils/colorUtils.js" as ColorUtils

Common.Button {
    id: bluetoothButton

    implicitHeight: buttonContentPadding.implicitHeight
    implicitWidth: buttonContentPadding.implicitWidth

    property bool isConnected: Bluetooth.connected
    background: isConnected ? Appearance.material_colors.primary_container : "#11ffffff"
    backgroundHover: isConnected ? ColorUtils.mix(background, "#eeeeee", .7) : "#22ffffff"
    backgroundPressed: isConnected ? ColorUtils.mix(background, "#eeeeee", .8) : "#33ffffff"
    property color textColor: isConnected ? Appearance.material_colors.on_primary_container : Appearance.material_colors.on_surface

    antialiasing: true
    layer.enabled: true
    layer.smooth: true
    clip: true

    // This kind of hides the flickering from the gradient shader.
    border.width: 1

    Shaders.MaskedGradientSwirl {
        source: wifiButton
        timeRunning: true
        opacity: isConnected ? .75 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        visible: opacity > 0

        property color _color1: Appearance.material_colors.primary
        property color _color2: Appearance.material_colors.source_color
        property color _color3: Appearance.material_colors.primary_container
        property color _color4: Appearance.material_colors.source_color

        Behavior on _color1 {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        Behavior on _color2 {
            ColorAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
        Behavior on _color3 {
            ColorAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
        Behavior on _color4 {
            ColorAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }

        color1: Qt.vector3d(_color1.r, _color1.g, _color1.b)
        color2: Qt.vector3d(_color2.r, _color2.g, _color2.b)
        color3: Qt.vector3d(_color3.r, _color3.g, _color3.b)
        color4: Qt.vector3d(_color4.r, _color4.g, _color4.b)

        anchors.fill: parent
    }

    RowLayout {
        id: buttonContentPadding
        spacing: 0

        anchors.fill: parent

        RowLayout {
            Layout.margins: 15
            spacing: 10

            Common.BluetoothIcon {
                implicitSize: 20
                Layout.alignment: Qt.AlignVCenter
            }

            Common.StyledText {
                text: "Bluetooth"
                font.pixelSize: Appearance.font.pixelSize.small
                font.weight: 500
                color: Appearance.material_colors.on_primary_container
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
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
