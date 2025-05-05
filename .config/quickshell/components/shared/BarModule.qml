pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "../../config"

Rectangle {
    required property PanelWindow bar

    implicitHeight: Theme.moduleHeight
    implicitWidth: Theme.modulePadding[1]

    antialiasing: true
    border.width: 0
    border.color: Theme.border
    border.pixelAligned: false
    radius: implicitHeight / 2
    layer.enabled: true
    layer.smooth: false

    id: container
    color: Theme.moduleColor

    property alias contentItem: container
}