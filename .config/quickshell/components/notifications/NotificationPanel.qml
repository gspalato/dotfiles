import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
    WlrLayershell.namespace: "nox:notifications"
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    //color: "#30606000"

    anchors {
        left: true
        top: true
        bottom: true
        right: true
    }

    //NotificationDisplay {
    //	id: display

    //	anchors.fill: parent

    //	stack.y: 45 //(NotificationManager.showTrayNotifs ? 55 : 0)
    //	stack.x: parent.width - stack.width - 10
    //}

    //visible: display.stack.children.length != 0

    //mask: Region { item: display.stack }
    //HyprlandWindow.visibleMask: Region {
    //	regions: display.stack.children.map(child => child.mask)
    //}
}
