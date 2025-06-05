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

// Container
Shared.BarModule {
    id: root
    //required property PanelWindow bar

    opacity: activeWindow?.activated ? 1 : 0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

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

        IconImage {
            property string icon: Quickshell.iconPath(DesktopEntries.byId(activeWindow?.appId)?.icon, true)

            visible: icon !== "" && activeWindow?.activated
            implicitSize: 18
            source: icon
        }

        Text {
            id: text
            //anchors.centerIn: parent
            text: activeWindow?.activated ? activeWindow?.appId : ""

            font.family: Theme.fontFamily
            font.pixelSize: 16
            font.weight: 450

            color: "#ffffff"
        }
    }
}
