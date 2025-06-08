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

    property var stack: stack

    property var pages: QtObject {
        property var main: mainPage
        property var bluetooth: bluetoothPage
        property var wifi: wifiPage
        property var battery: batteryPage
    }

    implicitHeight: stack.implicitHeight

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

        // We're not using a behavior on implicitHeight because it causes weird animations.
        // The stack height lags behind the content if it updates (i.e. notifications on the main page).
        // So, we're animating the push/pop actions manually.
        property var resizeAnimation: NumberAnimation {
            property real height
            target: stack
            property: "implicitHeight"
            from: stack.implicitHeight
            to: height
            duration: 200
            easing.type: Easing.OutCubic
        }

        function pushAnimated(page) {
            if (stack.currentItem === page)
                return;

            stack.resizeAnimation.height = page.implicitHeight;
            stack.resizeAnimation.start();

            stack.push(page);
        }

        function popAnimated() {
            const target = stack.get(stack.index - 1);
            if (!target)
                return;

            stack.resizeAnimation.height = target?.implicitHeight;
            stack.resizeAnimation.start();
            stack.pop();
        }

        function popToIndexAnimated(index) {
            const target = stack.get(index);
            if (!target)
                return;

            stack.resizeAnimation.height = target?.implicitHeight;
            stack.resizeAnimation.start();
            stack.popToIndex(index);
        }

        pushEnter: Transition {
            ParallelAnimation {
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
