pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "root:/components/shared" as Shared
import "root:/config"
import "root:/data"

// Container
Shared.BarModule {
    id: root

    Binding {
        root.implicitWidth: row.implicitWidth + Theme.modulePadding[1]
    }
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    Row {
        id: row
        spacing: 10

        anchors.centerIn: parent

        Shared.NetworkIcon {
            Layout.alignment: Qt.AlignVCenter
        }

        Shared.BluetoothIcon {
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
