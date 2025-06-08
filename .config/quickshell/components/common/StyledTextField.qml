import QtQuick
import QtQuick.Controls

import "root:/config"
import "root:/utils/colorUtils.js" as ColorUtils

TextField {
    background: Rectangle {
        id: background
        anchors.fill: parent
        radius: Appearance.rounding.small

        color: "#11ffffff"
        Behavior on color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        antialiasing: true
        border.width: .5
        border.pixelAligned: true
        border.color: ColorUtils.alpha(Qt.lighter(background.color, 1.25), .2)
    }
}
