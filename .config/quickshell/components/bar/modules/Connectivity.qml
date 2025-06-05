pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "root:/components/common" as Common
import "root:/config"
import "root:/data"

// Container
Common.BarModule {
    id: root

    Binding {
        root.implicitWidth: row.implicitWidth + Appearance.sizes.moduleHorizontalPadding
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

        Common.NetworkIcon {
            Layout.alignment: Qt.AlignVCenter
        }

        Common.BluetoothIcon {
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
