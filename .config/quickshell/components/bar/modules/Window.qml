pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "../../shared" as Shared
import "../../../config"

// Container
Shared.BarModule {
    id: root
    //required property PanelWindow bar

    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

    implicitWidth: text.implicitWidth + Theme.modulePadding[1]
    
    IconImage {
        implicitSize: 15
        source: ""
    }

    Text {
        id: text
        anchors.centerIn: parent
        text: activeWindow?.activated?activeWindow?.appId : "Desktop"

        font.family: Theme.fontFamily
        font.pixelSize: 16
        font.weight: Font.DemiBold

        color: "#ffffff"
    }
}