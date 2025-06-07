import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets

IconImage {
    id: root
    implicitSize: 18

    property string iconName
    property color tint
    source: "root:/assets/icons/" + root.iconName + ".svg"

    layer.enabled: true
    layer.effect: MultiEffect {
        colorization: 1
        colorizationColor: root.tint
    }
}
