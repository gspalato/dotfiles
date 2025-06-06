import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Notifications
import Qt5Compat.GraphicalEffects

import "root:/components/common" as Common
import "root:/config"
import "root:/utils/colorUtils.js" as ColorUtils

Rectangle {
    id: root
    required property Notification notif

    property bool isSwipeable: true
    property real swipeThreshold: root.width - root.width / 3
    property bool changeOpacityOnSwipe: true

    property bool showProgressToDismiss: false
    property real progressToDismiss: 0

    property var callbackOnDismiss: id => root.notif.dismiss()

    color: ColorUtils.alpha(Matugen.surface_container_low, .8)
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
    border.color: Qt.lighter(Appearance.material_colors.surface_container, 1.15)
    border.pixelAligned: true

    layer.enabled: true
    layer.smooth: true

    Behavior on x {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on height {
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

    DropShadow {
        anchors.fill: parent
        horizontalOffset: 0
        verticalOffset: 0
        radius: 5
        samples: 11
        color: Qt.rgba(0, 0, 0, 1)
        cached: true
        visible: true
    }

    MouseArea {
        id: dragArea

        enabled: root.isSwipeable
        anchors.fill: parent

        hoverEnabled: true

        drag {
            minimumX: 0
            axis: Drag.XAxis
            target: parent

            onActiveChanged: {
                if (dragArea.drag.active) {
                    return;
                }

                // Threshold for swiping away notifications.
                if (root.x > root.swipeThreshold) {
                    root.triggerRemoveAnimation();
                } else {
                    root.x = 0;
                }
            }
        }
    }

    GridLayout {
        id: outerLayout

        width: parent.width

        Image {
            id: notifImageOut
            readonly property int size: visible ? height : 0

            visible: false
            //visible: source != ""
            source: notif?.image || ""
            fillMode: Image.PreserveAspectCrop
            cache: false
            antialiasing: true
            mipmap: true

            width: 1.25 * parent.height
            height: parent.height

            sourceSize.width: size
            sourceSize.height: size

            Layout.preferredHeight: size
            Layout.preferredWidth: size
            Layout.alignment: Qt.AlignTop

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: notifIconOpacityMask
            }

            Rectangle {
                id: notifIconOpacityMask
                visible: false
                width: parent.width
                height: parent.height
                topLeftRadius: root.radius
                bottomLeftRadius: root.radius
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop {
                        position: 0.0
                        color: "white"
                    }
                    GradientStop {
                        position: 1.0
                        color: "transparent"
                    }
                }
            }
        }

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
                Layout.alignment: Qt.AlignTop

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

                    Common.StyledText {
                        text: notif?.appName || ""
                        font.pixelSize: Appearance.font.pixelSize.smaller
                        font.family: Appearance.font.family.main
                        font.weight: 400
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

                        Common.CircularProgress {
                            anchors.centerIn: parent
                            size: 22

                            primaryColor: Matugen.primary
                            secondaryColor: "#00ffffff"

                            visible: root.showProgressToDismiss
                            value: root.progressToDismiss
                        }
                    }
                }

                // Title/summary row
                ColumnLayout {
                    id: contentRow
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true

                    Common.StyledText {
                        visible: text != ""
                        text: notif?.summary || ""
                        elide: Text.ElideRight
                        Layout.maximumWidth: 250

                        font.pixelSize: Appearance.font.pixelSize.large
                        font.weight: 600
                        color: "#ffffff"
                    }

                    // Unexpanded body text
                    Common.StyledText {
                        id: bodyLabel
                        Layout.alignment: Qt.AlignTop

                        width: root.implicitWidth - 20
                        text: notif?.body || ""

                        Layout.maximumWidth: 250

                        font.pixelSize: Appearance.font.pixelSize.small
                        font.weight: 300
                        color: "#ffffff"
                        elide: Text.ElideRight
                        wrapMode: Text.WrapAnywhere

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
    }
}
