pragma ComponentBehavior: Bound

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

import "root:/components/dashboard" as Dashboard
import "root:/components/notifications" as Notifs
import "root:/components/common" as Common

import "root:/config"
import "root:/services"
import "root:/utils/colorUtils.js" as ColorUtils

ColumnLayout {
    id: root

    property var notificationList: notifList
    property var confirmationDialog: confirmationDialog

    //anchors.left: parent.left
    //anchors.right: parent.right

    ColumnLayout {
        Layout.topMargin: 15
        Layout.bottomMargin: 15

        spacing: 10

        RowLayout {
            id: header

            spacing: 10

            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            Item {
                height: 40
                width: 40

                Common.Avatar {}
            }

            // Greeting text
            ColumnLayout {
                id: greetingContainer
                Layout.alignment: Qt.AlignVCenter

                spacing: -2

                Common.StyledText {
                    id: greeting

                    property string username: ""
                    text: "Welcome back,"

                    font.pixelSize: 15
                    font.weight: 500
                }

                Common.StyledText {
                    id: usernameLabel

                    property string username: ""
                    text: username

                    font.family: Appearance.font.family.display
                    font.pixelSize: 17
                    font.weight: 500

                    // Get current username
                    Process {
                        id: proc
                        command: ["sh", "-c", "echo $USER"]
                        running: true

                        stdout: SplitParser {
                            onRead: data => usernameLabel.username = data
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            RowLayout {
                id: buttons

                spacing: 10
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight

                Dashboard.HeaderButton {
                    id: wallnutButton

                    Common.TintedIcon {
                        anchors.centerIn: parent
                        implicitSize: 18
                        iconName: "palette"
                        tint: Appearance.material_colors.on_surface
                    }

                    onClick: {
                        // Toggle the Wallnut panel.
                        Panels.wallpaperSelect.shown = !Panels.wallpaperSelect.shown;
                    }
                }

                Dashboard.HeaderButton {
                    id: rebootButton

                    IconImage {
                        anchors.centerIn: parent
                        implicitSize: 18
                        source: "root:/assets/icons/reboot.svg"
                    }

                    Process {
                        id: rebootProc
                        command: ["sh", "-c", "systemctl reboot"]
                        running: false
                    }

                    // Prepare the confirmation dialog to be about rebooting the computer.
                    onClick: {
                        confirmationDialog.updateAndReveal("Are you sure you want to reboot your computer?", () => {
                            console.log("Rebooting...");
                            rebootProc.running = true;
                        }, "reboot", "Confirm", "Cancel");
                    }
                }

                Dashboard.HeaderButton {
                    id: shutdownButton

                    IconImage {
                        anchors.centerIn: parent
                        implicitSize: 18
                        source: "root:/assets/icons/power.svg"
                    }

                    Process {
                        id: shutdownProc
                        command: ["sh", "-c", "systemctl poweroff"]
                        running: false
                    }

                    // Prepare the confirmation dialog to be about shutting down the computer.
                    onClick: {
                        confirmationDialog.updateAndReveal("Are you sure you want to shut down your computer?", () => {
                            console.log("Shutting down...");
                            shutdownProc.running = true;
                        }, "shutdown", "Confirm", "Cancel");
                    }
                }
            }
        }

        // Confirmation dialog
        Common.Revealer {
            id: confirmationDialog
            vertical: true
            duration: 200

            property var currentDialog: null
            property string prompt
            property string confirmText: "Yup"
            property string cancelText: "Nah"
            property var confirmCallback

            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            function updateAndReveal(prompt, callback, dialog, confirmText = "Yup", cancelText = "Nah") {
                // If switching dialogs, use the hide and reveal animation.
                console.log();
                let animation = (dialog != confirmationDialog.currentDialog) ? hideAndRevealAnimation : revealAnimation;
                confirmationDialog.currentDialog = dialog;

                animation.prompt = prompt;
                confirmationDialog.confirmCallback = callback;

                animation.confirmText = confirmText;
                animation.cancelText = cancelText;

                animation.start();
            }

            SequentialAnimation {
                id: revealAnimation

                property string prompt
                property string confirmText
                property string cancelText

                // Update the content of the dialog.
                ParallelAnimation {
                    PropertyAction {
                        target: confirmationDialog
                        property: "prompt"
                        value: revealAnimation.prompt
                    }
                    PropertyAction {
                        target: confirmationDialog
                        property: "confirmText"
                        value: revealAnimation.confirmText
                    }
                    PropertyAction {
                        target: confirmationDialog
                        property: "cancelText"
                        value: revealAnimation.cancelText
                    }
                }
                // Reveal the dialog.
                PropertyAction {
                    target: confirmationDialog
                    property: "reveal"
                    value: true
                }
            }

            SequentialAnimation {
                id: hideAndRevealAnimation

                property string prompt
                property string confirmText
                property string cancelText

                PropertyAction {
                    target: confirmationDialog
                    property: "reveal"
                    value: false
                }
                // Wait for revealer to be hidden.
                PauseAnimation {
                    duration: 200
                }
                // Update the content of the dialog.
                ParallelAnimation {
                    PropertyAction {
                        target: confirmationDialog
                        property: "prompt"
                        value: hideAndRevealAnimation.prompt
                    }
                    PropertyAction {
                        target: confirmationDialog
                        property: "confirmText"
                        value: hideAndRevealAnimation.confirmText
                    }
                    PropertyAction {
                        target: confirmationDialog
                        property: "cancelText"
                        value: hideAndRevealAnimation.cancelText
                    }
                }
                // Reveal the dialog.
                PropertyAction {
                    target: confirmationDialog
                    property: "reveal"
                    value: true
                }
            }

            Rectangle {
                id: confirmationDialogBg

                implicitHeight: confirmationDialogContentContainer.implicitHeight
                implicitWidth: parent.width

                color: "#11ffffff"
                border.width: 1
                border.color: "#1fffffff"
                Layout.fillWidth: true

                radius: Appearance.rounding.small || 15

                GridLayout {
                    id: confirmationDialogContentContainer
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    ColumnLayout {
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        Layout.topMargin: 10
                        Layout.bottomMargin: 10

                        spacing: 10

                        Common.StyledText {
                            text: confirmationDialog.prompt
                            wrapMode: Text.Wrap

                            font.family: Appearance.font.family.secondary
                            font.pixelSize: Appearance.font.pixelSize.small
                            font.weight: 400

                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter

                            //renderType: Text.QtRendering
                        }

                        RowLayout {
                            Common.Button {
                                id: confirmButton

                                Layout.fillWidth: true
                                radius: 12

                                Common.StyledText {
                                    text: confirmationDialog.confirmText
                                    font.pixelSize: 14
                                    font.weight: 500
                                    anchors.centerIn: parent
                                }

                                onClick: {
                                    confirmationDialog.confirmCallback();
                                    confirmationDialog.reveal = false;
                                }
                            }

                            Common.Button {
                                id: cancelButton

                                Layout.fillWidth: true
                                radius: 12

                                Common.StyledText {
                                    text: confirmationDialog.cancelText
                                    font.pixelSize: 14
                                    font.weight: 500
                                    anchors.centerIn: parent
                                }

                                onClick: {
                                    confirmationDialog.reveal = false;
                                }
                            }
                        }
                    }
                }
            }
        }

        // Buttons (work in progress)
        Rectangle {
            id: buttonsBg
            visible: true

            implicitHeight: buttonsContainer.implicitHeight
            implicitWidth: buttonsContainer.width

            color: "transparent"
            //color: "#11ffffff"
            border.width: 0
            border.color: "#1fffffff"

            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.fillWidth: true

            radius: Appearance.rounding.full

            RowLayout {
                id: buttonsContainer
                spacing: 10

                width: buttonsBg.width

                //anchors.horizontalCenter: parent.horizontalCenter

                Dashboard.WifiButton {
                    height: 50
                    Layout.preferredWidth: buttonsContainer.width / 2 - 5
                    //radius: Appearance.rounding.full

                    onClick: {
                        // Push the Wifi page onto the stack.
                        Panels.dashboard.stack.pushAnimated(Panels.dashboard.pages.wifi);
                    }
                }

                Dashboard.BluetoothButton {
                    height: 50
                    Layout.preferredWidth: buttonsContainer.width / 2 - 5
                    //radius: Appearance.rounding.full

                    onClick: {
                        // Push the Bluetooth page onto the stack.
                        Panels.dashboard.stack.pushAnimated(Panels.dashboard.pages.bluetooth);
                    }
                }
            }
        }

        // Sliders
        Rectangle {
            id: slidersBg

            implicitHeight: slidersContainer.implicitHeight
            implicitWidth: parent.width

            color: "#11ffffff"
            border.width: 1
            border.color: "#1fffffff"

            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.fillWidth: true

            radius: Appearance.rounding.small || 15

            GridLayout {
                id: slidersContainer
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                ColumnLayout {
                    id: slidersContent
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    Layout.fillWidth: true

                    spacing: 15

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Common.VolumeIcon {}

                        Common.CustomSlider {
                            id: volumeSlider
                            Layout.fillWidth: true

                            fillColor: Appearance.material_colors.primary

                            value: Audio.sink?.audio.volume
                            onValueChanged: {
                                if (Audio.sink?.audio)
                                    Audio.sink.audio.volume = value;
                            }
                        }
                    }
                }
            }
        }

        // Notifications
        Rectangle {
            id: notifsBg

            implicitHeight: notifsContainer.implicitHeight
            implicitWidth: parent.width

            color: "#11ffffff"
            border.width: 1
            border.color: "#1fffffff"

            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.fillWidth: true

            radius: Appearance.rounding.small || 15

            GridLayout {
                id: notifsContainer
                anchors.left: parent.left
                anchors.right: parent.right

                ColumnLayout {
                    id: notifsContent
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10

                    spacing: 10

                    // Notifications header
                    RowLayout {
                        spacing: 4

                        IconImage {
                            implicitSize: 16
                            source: "root:/assets/icons/notification.svg"
                        }

                        Common.StyledText {
                            text: "Notifications"
                            font.pixelSize: 15
                            font.weight: 500
                            renderType: Text.NativeRendering
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Common.Button {
                            id: clearButton

                            height: 20
                            width: 20
                            Layout.alignment: Qt.AlignVCenter

                            opacity: root.notificationList.notifications.count > 0 ? 1 : 0
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                            }

                            visible: opacity > 0

                            background: "transparent"
                            border.width: 0

                            IconImage {
                                anchors.centerIn: parent
                                implicitSize: 18
                                source: "root:/assets/icons/clear-all.svg"
                            }

                            onClick: {
                                notifList.clearAllNotifications();
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        clip: true

                        Layout.minimumHeight: emptyNotifText.height
                        Layout.preferredHeight: notifList.height

                        color: "transparent"
                        radius: 10

                        // Empty notifications message
                        Common.StyledText {
                            id: emptyNotifText

                            anchors.centerIn: parent

                            text: "No notifications"
                            font.pixelSize: 14
                            font.weight: 300
                            verticalAlignment: Text.AlignVCenter

                            opacity: notifList.notifications.count === 0 ? 0.5 : 0
                            visible: opacity > 0

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                            }

                            height: 50
                        }

                        // Notifications list
                        Notifs.NotificationListView {
                            id: notifList

                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                        }
                    }
                }
            }
        }

        // Tray
        Rectangle {
            id: trayBg

            implicitHeight: trayContainer.implicitHeight
            implicitWidth: parent.width

            color: "#11ffffff"
            border.width: 1
            border.color: "#1fffffff"

            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.fillWidth: true

            radius: Appearance.rounding.small || 15

            GridLayout {
                id: trayContainer
                anchors.left: parent.left
                anchors.right: parent.right

                ColumnLayout {
                    id: trayContent
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10

                    spacing: 10

                    RowLayout {
                        spacing: 4

                        /*
                            IconImage {
                            implicitSize: 16
                            source: "root:/assets/icons/ellipsis.svg"
                            }

                            Item {
                            Layout.fillWidth: true
                            }
                            */

                        Item {
                            Layout.fillWidth: true
                        }

                        ListView {
                            id: trayListView
                            Layout.fillHeight: true
                            Layout.minimumHeight: 16
                            Layout.preferredWidth: contentWidth
                            Layout.alignment: Qt.AlignHCenter
                            clip: true

                            orientation: ListView.Horizontal
                            spacing: 5
                            model: SystemTray.items.values

                            delegate: Dashboard.TrayItem {
                                id: trayIcon
                                required property SystemTrayItem modelData
                                item: modelData
                                window: Panels.dashboardPanelWindow
                            }

                            add: Transition {
                                NumberAnimation {
                                    properties: "x"
                                    duration: 150
                                    from: parent.width
                                    to: 0
                                    easing.type: Easing.OutQuad
                                }
                            }

                            remove: Transition {
                                NumberAnimation {
                                    properties: "x"
                                    duration: 150
                                    to: parent.width
                                    easing.type: Easing.OutQuad
                                }
                            }

                            displaced: Transition {
                                NumberAnimation {
                                    properties: "x"
                                    duration: 150
                                    easing.type: Easing.OutQuad
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }
}
