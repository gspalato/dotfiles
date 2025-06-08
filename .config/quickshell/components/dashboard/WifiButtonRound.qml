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
    id: root

    implicitWidth: height
    radius: Appearance.rounding.full

    property bool isEnabled: Network.enabled
    property bool isConnected: Network.wifi || Network.ethernet
    background: (isConnected || isEnabled) ? Appearance.material_colors.primary_container : "#11ffffff"
    backgroundHover: (isConnected || isEnabled) ? ColorUtils.mix(background, "#eeeeee", .7) : "#22ffffff"
    backgroundPressed: (isConnected || isEnabled) ? ColorUtils.mix(background, "#eeeeee", .8) : "#33ffffff"
    property color textColor: isConnected ? Appearance.material_colors.on_primary_container : Appearance.material_colors.on_surface

    Common.NetworkIcon {
        implicitSize: 22

        anchors.centerIn: parent
    }
}
