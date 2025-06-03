pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "root:/components/shared" as Shared
import "root:/config"
import "root:/data"

// Container
Shared.BarModule {
    id: container
    implicitHeight: Theme.moduleHeight
    implicitWidth: timeText.implicitWidth + Theme.modulePadding[1]

    /*
    property bool isHovered: false
    property bool isPressed: false

    // Hover handling
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            isHovered = true;
        }
        onExited: {
            isHovered = false;
        }
        onPressed: {
            isPressed = true;
        }
        onReleased: {
            isPressed = false;
        }

        onClicked: {
            Panels.toggleDashboard();
        }
    }
    */

    // Set color based on hover/press state.
    color: Theme.resolvedModuleColor
    //color: Qt.lighter(Theme.resolvedModuleColor, isPressed ? 2.5 : (isHovered ? 1.75 : 0))
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    Text {
        id: timeText

        font.family: Theme.fontFamily
        font.pixelSize: Theme.defaultFontSize
        font.weight: 600
        renderType: Text.NativeRendering

        color: Theme.foreground

        anchors.centerIn: parent
        text: Time.data ?? ""
    }
}
