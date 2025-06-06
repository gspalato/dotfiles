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

    height: parent.height
    implicitWidth: height

    visible: Battery.available

    Common.CircularProgress {
        id: progress
        size: 30

        anchors.centerIn: parent

        primaryColor: Appearance.material_colors.primary
        secondaryColor: "#22ffffff"

        value: Battery.percentage
    }

    Common.BatteryIcon {
        implicitSize: 18
        anchors.centerIn: parent
    }
}
