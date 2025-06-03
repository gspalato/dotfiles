import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "root:/config"

Rectangle {
    id: root

    property color background: Qt.rgba(255, 255, 255, .1)
    property color backgroundHover: Qt.rgba(255, 255, 255, .2)
    property color backgroundPressed: Qt.rgba(255, 255, 255, .1)

    property bool isHovered: false
    property bool isPressed: false

    signal click

    height: 32
    width: 32
    radius: 100

    color: isPressed ? backgroundPressed : (isHovered ? backgroundHover : background)
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    antialiasing: true
    border.width: .5//.5
    border.color: Theme.border
    border.pixelAligned: false

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            isHovered = true;
        }
        onExited: {
            isHovered = false;
        }
        onPressed: {
            isPressed = true;
        }
        onReleased: {
            isPressed = false;
        }
        onClicked: {
            root.click();
        }
    }
}
