pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "root:/config"

Rectangle {
    id: container
    //required property PanelWindow bar

    implicitHeight: Theme.moduleHeight
    implicitWidth: Theme.modulePadding[1]

    antialiasing: true
    border.width: 1
    border.color: Theme.moduleBorder
    border.pixelAligned: true
    radius: implicitHeight / 2
    layer.enabled: true
    layer.smooth: true

    color: Theme.resolvedModuleColor

    property alias contentItem: container
}
