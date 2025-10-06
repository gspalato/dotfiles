import QtQuick
import QtQuick.Effects

import "root:/config"

RectangularShadow {
    required property var target
    anchors.fill: target
    radius: target.radius
    blur: 9
    offset: Qt.vector2d(0.0, 1.0)
    spread: 1
    color: Matugen.shadow
    cached: true
}
