import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import "root:/config"
import "root:/services"

PanelWindow {
    WlrLayershell.namespace: "nox:notifications"
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    //color: "#30606000"

    height: padding.height
    width: 360 + 10

    margins {
        bottom: 10
        right: 0
    }

    anchors {
        left: false
        top: true
        bottom: true
        right: true
    }

    ColumnLayout {
        id: padding

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right

        NotificationPopupListView {
            id: notifList

            width: 350

            Layout.topMargin: 10
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            opacity: 1 - Panels.dashboard?.scale

            Behavior on Layout.topMargin {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    // Disable the mask when the dashboard is open.
    mask: Region {
        item: Panels.dashboard?.scale < 1 ? notifList.contentItem : null
    }
}
