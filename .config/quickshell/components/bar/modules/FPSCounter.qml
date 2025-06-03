pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "root:/config"

Rectangle {
    id: container
    required property PanelWindow bar

    implicitHeight: Theme.moduleHeight
    implicitWidth: text.implicitWidth + Theme.modulePadding[1]

    border.color: Theme.border
    radius: height / 2
    color: Theme.moduleColor

    property alias contentItem: container

    FrameAnimation {
        id: frameAnimation
        property real fps: smoothFrameTime > 0 ? Math.round(1.0 / smoothFrameTime) : 0
        running: true
    }

    Text {
        id: text
        text: frameAnimation.fps

        font.family: Theme.fontFamily
        font.pixelSize: 16
        font.weight: Font.DemiBold

        color: "#ffffff"

        anchors.centerIn: parent
    }
}
