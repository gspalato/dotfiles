import QtQuick
import Quickshell

/**
* Recreation of GTK revealer. Expects one single child.
*/
Item {
    id: root
    property bool reveal
    property bool vertical: false
    clip: true

    implicitWidth: (reveal || vertical) ? childrenRect.width : 0
    implicitHeight: (reveal || !vertical) ? childrenRect.height : 0

    Behavior on implicitWidth {
        enabled: !vertical
        animation: NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }
    Behavior on implicitHeight {
        enabled: vertical
        animation: NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }
}
