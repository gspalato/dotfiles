import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    property real padding: 5
    implicitWidth: icon.width + padding * 2
    implicitHeight: icon.height + padding * 2

    CustomIcon {
        id: icon
        anchors.centerIn: parent
        width: 19.5
        height: 19.5
        source: `spxlato-star`
        colorize: true
        color: Appearance.colors.colOnLayer0

        StyledRect {
            opacity: root.showPing ? 1 : 0
            visible: opacity > 0
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: -2
                rightMargin: -2
            }
            implicitWidth: 8
            implicitHeight: 8
            radius: Appearance.rounding.full
            color: Appearance.colors.colTertiary

            Behavior on opacity {
                animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
            }
        }
    }
}