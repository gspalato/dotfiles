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

    implicitHeight: Appearance.sizes.moduleHeight
    implicitWidth: Appearance.sizes.moduleHorizontalPadding

    antialiasing: true
    border.width: 1
    border.color: Appearance.colors.moduleBorder
    border.pixelAligned: true
    radius: Appearance.rounding.full

    layer.enabled: true
    layer.smooth: true

    color: Appearance.colors.moduleColor
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    property alias contentItem: container
}
