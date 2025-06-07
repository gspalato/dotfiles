import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets

import "root:/config"
import "root:/services"

IconImage {
    implicitSize: 18
    source: "root:/assets/icons/" + Bluetooth.iconName + ".svg"

    layer.enabled: true
    layer.effect: MultiEffect {
        colorization: 1
        colorizationColor: Appearance.material_colors.on_surface
    }
}
