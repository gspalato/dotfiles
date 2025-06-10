import QtQuick
import QtQuick.Controls

import "root:/services"
import "root:/config"

ScrollBar {
    id: root

    contentItem: StyledRect {
        implicitWidth: 6
        opacity: root.pressed ? 1 : root.policy === ScrollBar.AlwaysOn || (root.active && root.size < 1) ? 0.8 : 0
        radius: Appearance.rounding.full
        color: Appearance.material_colors.secondary

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.standard
            }
        }
    }

    MouseArea {
        z: -1
        anchors.fill: parent
        onWheel: event => {
            if (event.angleDelta.y > 0)
                root.decrease();
            else if (event.angleDelta.y < 0)
                root.increase();
        }
    }
}
