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
    width: 420

    aboveWindows: true
    exclusionMode: ExclusionMode.Ignore

    anchors.top: true
    anchors.right: true
    anchors.bottom: true

    margins.top: 50
    margins.right: 0
    margins.bottom: 0
}
