import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    property bool borderless: Config.options.bar.borderless
    readonly property var chargeState: Battery.chargeState
    readonly property bool isCharging: Battery.isCharging
    readonly property bool isPluggedIn: Battery.isPluggedIn
    readonly property real percentage: Battery.percentage
    readonly property bool isLow: percentage <= Config.options.battery.low / 100

    implicitWidth: batteryProgress.implicitWidth
    implicitHeight: Appearance.sizes.barHeight

    hoverEnabled: true

    CircularProgress2 {
        id: progress
        size: 24

        anchors.centerIn: parent

        primaryColor: ColorUtils.interpolateColorsInLCH(Appearance.m3colors.m3primary, Appearance.m3colors.m3errorContainer, 1 - percentage)
        secondaryColor: "#22ffffff"

        value: percentage
    }

    BatteryPopup {
        id: batteryPopup
        hoverTarget: root
    }
}
