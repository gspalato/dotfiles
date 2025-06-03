pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "root:/config"

PanelWindow {
    id: dashboardPanel
    WlrLayershell.namespace: "nox:dashboard"

    color: "transparent"

    visible: true

    height: 500
    width: 400

    aboveWindows: true
    exclusionMode: ExclusionMode.Ignore

    anchors.top: true
    anchors.right: true
    anchors.bottom: true

    margins.top: 60
    margins.right: 10
    margins.bottom: 10
}
