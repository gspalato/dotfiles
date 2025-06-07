import QtQuick
import Quickshell
import Quickshell.Widgets

import "root:/services"

IconImage {
    id: root
    implicitSize: 18

    property string iconName
    source: "root:/assets/icons/" + iconName + ".svg"

    Connections {
        target: Battery
        function onPercentageChanged() {
            root.updateIconName();
        }
        function onIsChargingChanged() {
            root.updateIconName();
        }
        function onIsPluggedInChanged() {
            root.updateIconName();
        }
        function onChargeStateChanged() {
            root.updateIconName();
        }
    }

    function updateIconName() {
        if (Battery.isCharging || Battery.isPluggedIn) {
            root.iconName = "bolt";
        } else {
            if (Battery.percentage <= .125)
                root.iconName = "battery-0-bar";
            else if (Battery.percentage <= .25)
                root.iconName = "battery-1-bar";
            else if (Battery.percentage <= .375)
                root.iconName = "battery-2-bar";
            else if (Battery.percentage <= .50)
                root.iconName = "battery-3-bar";
            else if (Battery.percentage <= .625)
                root.iconName = "battery-4-bar";
            else if (Battery.percentage <= .75)
                root.iconName = "battery-5-bar";
            else if (Battery.percentage <= .875)
                root.iconName = "battery-6-bar";
            else
                root.iconName = "battery-full";
        }
    }

    Component.onCompleted: {
        updateIconName();
    }
}
