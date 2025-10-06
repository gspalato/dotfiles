import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "root:/components/common" as Common
import "root:/config"
import "root:/utils/colorUtils.js" as ColorUtils

Rectangle {
    id: root

    property color background: Qt.rgba(255, 255, 255, .1)
    property color backgroundHover: Qt.rgba(255, 255, 255, .2)
    property color backgroundPressed: Qt.rgba(255, 255, 255, .15)
    property color borderColor: ColorUtils.alpha(Qt.lighter(root.background, 1.25), .2)

    property int padding: 0
    property int topInset: 0
    property int bottomInset: 0
    property int buttonRadius: Appearance.rounding.small

    property var downAction        // When left clicking (down)
    property var releaseAction     // When left clicking (release)
    property var altAction         // When right clicking
    property var middleClickAction // When middle clicking

    property bool isHovered: false
    property bool isPressed: false

    signal click

    height: 32
    width: 32
    radius: buttonRadius

    color: isPressed ? backgroundPressed : (isHovered ? backgroundHover : background)
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    antialiasing: true
    border.width: .5
    border.pixelAligned: false
    border.color: borderColor

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onEntered: {
            isHovered = true;
        }

        onExited: {
            isHovered = false;
        }

        onPressed: (event) => { 
            if (event.button === Qt.RightButton) {
                if (root.altAction) root.altAction(event);
                return;
            }
            if (event.button === Qt.MiddleButton) {
                if (root.middleClickAction) root.middleClickAction();
                return;
            }
            root.isPressed = true

            if (root.downAction) root.downAction();
        }

        onReleased: (event) => {
            root.isPressed = false
            if (event.button != Qt.LeftButton) return;
            if (root.releaseAction) root.releaseAction();

            root.click() // Because the MouseArea already consumed the event
        }

        onCanceled: (event) => {
            root.isPressed = false
        }
    }

    property var contentItem: Common.StyledText {
        text: root.buttonText
    }
}
