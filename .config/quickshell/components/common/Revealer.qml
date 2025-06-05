import QtQuick
import Quickshell

/**
* Recreation of GTK revealer. Expects one single child.
*/
Item {
    id: root
    property bool reveal
    property bool vertical: false
    property int duration: 200
    property var easing: Easing.OutQuad
    clip: true

    implicitWidth: (reveal || vertical) ? childrenRect.width : 0
    implicitHeight: (reveal || !vertical) ? childrenRect.height : 0

    Behavior on implicitWidth {
        enabled: !vertical
        animation: NumberAnimation {
            duration: root.duration
            easing.type: root.easing
        }
    }
    Behavior on implicitHeight {
        enabled: vertical
        animation: NumberAnimation {
            duration: root.duration
            easing.type: root.easing
        }
    }
}
