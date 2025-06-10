import QtQuick

import "root:/config"
import "root:/services"

StyledRect {
    id: root

    readonly property alias hovered: mouse.hovered
    readonly property alias pressed: mouse.pressed
    property bool disabled

    function onClicked(event: MouseEvent): void {
    }

    anchors.fill: parent

    color: Appearance.material_colors.on_surface
    opacity: disabled ? 0 : mouse.pressed ? 0.1 : mouse.hovered ? 0.08 : 0

    MouseArea {
        id: mouse

        property bool hovered

        anchors.fill: parent
        cursorShape: root.disabled ? undefined : Qt.PointingHandCursor
        hoverEnabled: true

        onEntered: hovered = true
        onExited: hovered = false

        onClicked: event => !root.disabled && root.onClicked(event)
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }
    }
}
