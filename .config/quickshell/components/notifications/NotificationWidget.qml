import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Notifications
import Qt5Compat.GraphicalEffects

import "root:/config"
import "root:/utils/utils.js" as Utils

Rectangle {
    id: root
    required property Notification notif

    property bool isSwipeable: true
    property bool changeOpacityOnSwipe: true

    property var callbackOnDismiss: id => root.notif.dismiss()

    color: Utils.colorAlpha(Matugen.background, .8)
    Behavior on color {
        ColorAnimation {
            duration: 400
            easing.type: Easing.OutCubic
        }
    }

    radius: 20
    implicitWidth: outerLayout.implicitWidth
    implicitHeight: outerLayout.implicitHeight
    clip: true

    antialiasing: true
    border.width: 1
    border.color: Qt.lighter(Matugen.background, 1.75)
    border.pixelAligned: true

    layer.enabled: true
    layer.smooth: true

    Behavior on x {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    // Opacity changes based on the x position of the notification.
    // The notification is automatically dismissed if it is swiped away.
    onXChanged: {
        if (root.changeOpacityOnSwipe)
            root.opacity = 1 - (Math.abs(root.x) / width);

        // If x means the notification was swiped away, dismiss it.
        if (root.x > 1.5 * root.width) {
            root.callbackOnDismiss(notif.id);
        }
    }

    // For some reason, this is the only way to properly
    // trigger the remove animation and the NotificationListView
    // displace animations. The animation has to occur before
    // the notification is dismissed (and therefore removed from
    // the ListModel).
    function triggerRemoveAnimation() {
        root.x = 2 * root.width;
    }

    MouseArea {
        id: dragArea

        enabled: root.isSwipeable
        anchors.fill: parent

        drag {
            minimumX: 0
            axis: Drag.XAxis
            target: parent

            onActiveChanged: {
                if (dragArea.drag.active) {
                    return;
                }

                // Threshold for swiping away notifications.
                if (root.x > (root.width - root.width / 3)) {
                    root.triggerRemoveAnimation();
                } else {
                    root.x = 0;
                }
            }
        }
    }

    GridLayout {
        id: outerLayout

        RowLayout {
            id: layout
            spacing: 10
            //Layout.maximumWidth: 400
            Layout.margins: 10
            clip: true

            Image {
                id: notifImage
                readonly property int size: visible ? 75 : 0

                visible: source != ""
                source: notif?.image || ""
                fillMode: Image.PreserveAspectCrop
                cache: false
                antialiasing: true
                mipmap: true

                width: size
                height: size

                sourceSize.width: size
                sourceSize.height: size

                Layout.preferredHeight: size
                Layout.preferredWidth: size

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: notifIconMask
                }

                Rectangle {
                    id: notifIconMask
                    width: parent.width
                    height: parent.height
                    radius: 15
                    visible: false
                }
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                //Layout.fillHeight: true
                uniformCellSizes: false

                spacing: 1

                // App name and icon row
                RowLayout {
                    id: appRow
                    Layout.alignment: Qt.AlignTop
                    Layout.maximumHeight: 25

                    spacing: 4

                    Image {
                        visible: source != ""
                        source: notif?.appIcon ? Quickshell.iconPath(notif?.appIcon) : (Quickshell.iconPath(DesktopEntries.byId(notif?.appName)?.icon, true) || "")
                        fillMode: Image.PreserveAspectFit

                        antialiasing: true

                        sourceSize.width: 16
                        sourceSize.height: 16

                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: notifAppIconMask
                        }

                        Rectangle {
                            id: notifAppIconMask
                            width: 16
                            height: 16
                            radius: 100
                            visible: false
                        }
                    }

                    Text {
                        text: notif?.appName || ""
                        font.family: Theme.fontFamily
                        font.pointSize: 10
                        font.weight: 600
                        color: "#55ffffff"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    MouseArea {
                        id: closeArea
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20

                        hoverEnabled: true
                        onPressed: root.triggerRemoveAnimation()

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 5
                            radius: width * 0.5
                            antialiasing: true
                            color: "#60ffffff"
                            opacity: closeArea.containsMouse ? 1 : 0
                            Behavior on opacity {
                                SmoothedAnimation {
                                    velocity: 8
                                }
                            }
                        }

                        //CloseButton {
                        // anchors.fill: parent
                        // ringFill: root.backer.timePercentage
                        //}
                    }
                }

                // Title/summary row
                RowLayout {
                    Layout.alignment: Qt.AlignTop

                    Label {
                        visible: text != ""
                        text: notif?.summary || ""
                        elide: Text.ElideRight
                        Layout.maximumWidth: 250

                        font.family: Theme.fontFamily
                        font.pointSize: 13
                        font.weight: 600
                    }
                }

                // Body row
                Label {
                    id: bodyLabel
                    Layout.alignment: Qt.AlignTop

                    width: root.implicitWidth - 20
                    text: notif?.body || ""
                    wrapMode: Text.Wrap
                    visible: text !== ""

                    Layout.maximumWidth: 240

                    font.family: Theme.fontFamily
                    font.pointSize: 11
                    font.weight: 500
                }
            }
        }
    }
}
