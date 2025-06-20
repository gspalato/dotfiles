pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects

import "root:/components/notifications" as Notifs
import "root:/components/common" as Common

import "root:/config"
import "root:/services"

Common.BarModule {
    id: root

    height: parent.height
    implicitWidth: height

    property int notificationCount: Notifs.Notifications.notifCount

    property bool isHovered: false
    property bool isPressed: false

    color: Qt.lighter(Appearance.colors.moduleColor, isPressed ? 2.5 : (isHovered ? 1.75 : 0))
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    MouseArea {
        id: mouseArea
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

    IconImage {
        id: icon
        implicitSize: 20
        source: "root:/assets/icons/menu.svg"

        anchors.centerIn: parent

        layer.enabled: true
        layer.effect: MultiEffect {
            colorization: 1
            colorizationColor: Appearance.material_colors.on_surface
        }
    }
}

/*
Common.BarModule {
    id: root
    clip: true

    height: Appearance.sizes.moduleHeight
    implicitWidth: icon.implicitWidth + Appearance.sizes.moduleHorizontalPadding

    property var bar
    property bool isDashboardVisible: false

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            isDashboardVisible = !isDashboardVisible
        }
    }

    IconImage {
        id: icon
        implicitSize: 18
        source: "root:/assets/icons/dashboard.svg"

        anchors.centerIn: parent
    }
}
*/
