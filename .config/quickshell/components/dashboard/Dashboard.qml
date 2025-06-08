import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Effects

import Quickshell.Services.Greetd

import "root:/components/notifications" as Notifs
import "root:/components/common" as Common

import "root:/components/dashboard/pages" as DashboardPages

import "root:/config"
import "root:/services"
import "root:/utils/colorUtils.js" as ColorUtils

Rectangle {
    id: dashboard

    property bool shown: false
    onShownChanged: {
        if (shown) {} else {
            mainPage.confirmationDialog.reveal = false;
            stack.popToIndex(0);
        }
    }

    property var notificationList: notifList
    property var stack: stack

    property var pages: QtObject {
        property var main: mainPage
        property var bluetooth: bluetoothPage
        property var wifi: wifiPage
        property var battery: batteryPage
    }

    implicitHeight: stack.implicitHeight
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    implicitWidth: 400
    transformOrigin: Item.TopRight

    color: ColorUtils.alpha(Appearance.material_colors.surface_container, .8)

    antialiasing: true
    radius: Appearance.rounding.windowRounding

    border.width: 1
    border.color: Qt.lighter(Appearance.material_colors.surface_container, 1.25)
    border.pixelAligned: true

    layer.enabled: true
    layer.smooth: true
    layer.effect: MultiEffect {
        shadowVerticalOffset: 0
        shadowHorizontalOffset: 0
        shadowColor: "#000000"
        shadowEnabled: true
        shadowBlur: 0.5
    }

    scale: shown ? 1 : 0
    Behavior on scale {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    visible: true

    StackView {
        id: stack
        implicitHeight: currentItem.implicitHeight

        anchors.left: parent.left
        anchors.right: parent.right

        opacity: dashboard.scale

        pushEnter: Transition {
            SequentialAnimation {
                PropertyAction {
                    property: "visible"
                    value: true
                }
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }
            }
        }

        pushExit: Transition {
            SequentialAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                }
                PropertyAction {
                    property: "visible"
                    value: false
                }
            }
        }

        popEnter: Transition {
            SequentialAnimation {
                PropertyAction {
                    property: "visible"
                    value: true
                }
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }
            }
        }

        popExit: Transition {
            SequentialAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                }
                PropertyAction {
                    property: "visible"
                    value: false
                }
            }
        }

        initialItem: mainPage

        DashboardPages.Main {
            id: mainPage

            Component.onCompleted: {
                dashboard.pages.main = mainPage;
            }
        }

        DashboardPages.Bluetooth {
            id: bluetoothPage

            Component.onCompleted: {
                dashboard.pages.bluetooth = bluetoothPage;
            }
        }

        DashboardPages.Wifi {
            id: wifiPage

            Component.onCompleted: {
                dashboard.pages.wifi = wifiPage;
            }
        }

        DashboardPages.Battery {
            id: batteryPage

            Component.onCompleted: {
                dashboard.pages.battery = batteryPage;
            }
        }
    }
}
