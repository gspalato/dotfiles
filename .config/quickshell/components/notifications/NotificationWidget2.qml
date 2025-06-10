import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import QtQuick.Effects

import "root:/components/common" as Common

import "root:/config"
import "root:/services"

import "root:/utils/colorUtils.js" as ColorUtils

Rectangle {
    id: root

    // The notification object that this widget represents.
    required property Notifications.Notif notif

    readonly property bool hasImage: notif.image.length > 0
    readonly property bool hasAppIcon: notif.appIcon.length > 0
    readonly property int nonAnimHeight: summary.implicitHeight + (root.expanded ? appName.height + body.height + actions.height + actions.anchors.topMargin : bodyPreview.height) + inner.anchors.margins * 2
    property bool expanded

    // Swipe properties
    property bool isSwipeable: true
    property real swipeThreshold: root.width - root.width / 3
    property bool changeOpacityOnSwipe: true

    // Shadow properties
    property bool shadowEnabled: true
    property real shadowBlur: .5
    property color shadowColor: "#000000"
    property real shadowVerticalOffset: 0
    property real shadowHorizontalOffset: 0

    // Progress properties
    property bool showProgressToDismiss: false
    property real progressToDismiss: 0

    // Callback when the notification dismiss/swipe animation is triggered.
    property var callbackOnDismiss: id => root.notif?.notification?.dismiss()

    RetainableLock {
        object: root.notif.notification
        locked: true
    }

    color: ColorUtils.alpha(Matugen.surface_container_low, .8)
    Behavior on color {
        ColorAnimation {
            duration: 400
            easing.type: Easing.OutCubic
        }
    }

    radius: 17.5
    implicitWidth: 350
    implicitHeight: inner.implicitHeight
    clip: true

    antialiasing: true
    border.width: 1
    border.color: Qt.lighter(Appearance.material_colors.surface_container, 1.15)
    border.pixelAligned: true

    layer.enabled: true
    layer.smooth: true
    layer.effect: MultiEffect {
        shadowVerticalOffset: root.shadowVerticalOffset
        shadowHorizontalOffset: root.shadowHorizontalOffset
        shadowColor: root.shadowColor
        shadowEnabled: root.shadowEnabled
        shadowBlur: root.shadowBlur
    }

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
            root.callbackOnDismiss(notif?.id);
        }
    }

    // For some reason, this is the only way I found to properly
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
        visible: false
    }

    MouseArea {
        id: dragArea

        enabled: root.isSwipeable
        anchors.fill: parent

        hoverEnabled: true
        scrollGestureEnabled: true

        onEntered: {
            notif.pauseTimeout();
        }

        onExited: {
            notif.resumeTimeout();
        }

        // Accept swiping right with two fingers on touchpad.
        onWheel: event => {
            if (event.angleDelta.x > 100) {
                root.triggerRemoveAnimation();
                event.accepted = true;
            }
        }

        drag {
            minimumX: 0
            axis: Drag.XAxis
            target: parent

            onActiveChanged: {
                if (dragArea?.drag?.active) {
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

    // Content
    Item {
        id: inner

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Appearance.padding.large

        implicitHeight: root.nonAnimHeight

        Behavior on implicitHeight {
            Anim {}
        }

        Loader {
            id: image

            active: root.hasImage
            asynchronous: true

            anchors.left: parent.left
            anchors.top: parent.top

            width: Appearance.notification.sizes.image
            height: Appearance.notification.sizes.image
            visible: root.hasImage || root.hasAppIcon

            sourceComponent: ClippingRectangle {
                radius: Appearance.rounding.smaller
                implicitWidth: Appearance.notification.sizes.image
                implicitHeight: Appearance.notification.sizes.image

                Image {
                    anchors.fill: parent
                    source: Qt.resolvedUrl(root.notif.image)
                    fillMode: Image.PreserveAspectCrop
                    cache: false
                    asynchronous: true
                    mipmap: true
                }
            }
        }

        Loader {
            id: appIcon

            property string resolvedIconUrl: Quickshell.iconPath(root.notif.appIcon) || (Quickshell.iconPath(DesktopEntries.byId(root.notif.appName)?.icon, true) || "")

            active: false//root.hasAppIcon || root.hasImage
            asynchronous: true

            anchors.horizontalCenter: root.hasImage ? undefined : image.horizontalCenter
            anchors.verticalCenter: root.hasImage ? undefined : image.verticalCenter
            anchors.right: root.hasImage ? image.right : undefined
            anchors.bottom: root.hasImage ? image.bottom : undefined

            sourceComponent: Common.StyledRect {
                radius: Appearance.rounding.smaller
                color: root.notif.urgency === NotificationUrgency.Critical ? Appearance.material_colors.error : root.notif.urgency === NotificationUrgency.Low ? Appearance.material_colors.surface_container_highest : Appearance.material_colors.tertiary_container
                implicitWidth: root.hasImage ? Appearance.notification.sizes.badge : Appearance.notification.sizes.image
                implicitHeight: root.hasImage ? Appearance.notification.sizes.badge : Appearance.notification.sizes.image

                Loader {
                    id: icon

                    active: root.hasAppIcon
                    asynchronous: true

                    anchors.centerIn: parent
                    visible: !root.notif.appIcon.endsWith("symbolic")

                    width: Math.round(parent.width * 0.6)
                    height: Math.round(parent.width * 0.6)

                    sourceComponent: IconImage {
                        implicitSize: Math.round(parent.width * 0.6)
                        source: appIcon.resolvedIconUrl
                        asynchronous: true
                    }
                }

                Loader {
                    active: root.notif.appIcon.endsWith("symbolic")
                    asynchronous: true
                    anchors.fill: icon

                    sourceComponent: Common.Colouriser {
                        source: icon
                        colorizationColor: root.notif.urgency === NotificationUrgency.Critical ? Appearance.material_colors.on_error : root.notif.urgency === NotificationUrgency.Low ? Appearance.material_colors.on_surface : Appearance.material_colors.on_tertiary_container
                    }
                }

                Loader {
                    active: false //!root.hasAppIcon
                    asynchronous: true
                    anchors.centerIn: parent

                    /*
                    sourceComponent: MaterialIcon {
                        text: {
                            const summary = root.notif.summary.toLowerCase();
                            if (summary.includes("reboot"))
                                return "restart_alt";
                            if (summary.includes("recording"))
                                return "screen_record";
                            if (summary.includes("battery"))
                                return "power";
                            if (summary.includes("screenshot"))
                                return "screenshot_monitor";
                            if (summary.includes("welcome"))
                                return "waving_hand";
                            if (summary.includes("time") || summary.includes("a break"))
                                return "schedule";
                            if (summary.includes("installed"))
                                return "download";
                            if (summary.includes("update"))
                                return "update";
                            if (summary.startsWith("file"))
                                return "folder_copy";
                            if (root.notif.urgency === NotificationUrgency.Critical)
                                return "release_alert";
                            return "chat";
                        }

                        color: root.notif.urgency === NotificationUrgency.Critical ? Appearance.material_colors.on_error : root.notif.urgency === NotificationUrgency.Low ? Appearance.material_colors.on_surface : Appearance.material_colors.on_tertiary_container
                        font.pixelSize: Appearance.font.pixelSize.large
                    }
                    */
                }
            }
        }

        Common.StyledText {
            id: appName

            anchors.top: parent.top
            anchors.left: (root.hasImage || root.hasAppIcon) ? image.right : parent.left
            //anchors.leftMargin: root.hasImage || root.hasAppIcon ? Appearance.spacings.normal : 0

            //anchors.leftMargin: Appearance.spacings.normal
            anchors.leftMargin: root.hasImage || root.hasAppIcon ? Appearance.spacings.normal : 0

            animate: true
            text: appNameMetrics.elidedText
            maximumLineCount: 1
            color: Appearance.material_colors.on_surface_variant
            font.pixelSize: Appearance.font.pixelSize.small

            opacity: root.expanded ? 1 : 0

            Behavior on opacity {
                Anim {}
            }
        }

        TextMetrics {
            id: appNameMetrics

            text: root.notif.appName
            font.family: appName.font.family
            font.pointSize: appName.font.pointSize
            elide: Text.ElideRight
            elideWidth: expandBtn.x - time.width - timeSep.width - summary.x - Appearance.spacings.normal * 3
        }

        Common.StyledText {
            id: summary

            anchors.top: parent.top
            //anchors.left: image.right
            anchors.left: (root.hasImage || root.hasAppIcon) ? image.right : parent.left

            //anchors.leftMargin: Appearance.spacings.normal
            anchors.leftMargin: root.hasImage || root.hasAppIcon ? Appearance.spacings.normal : 0

            animate: true
            text: summaryMetrics.elidedText
            font.family: Appearance.font.family.main
            font.weight: 600
            maximumLineCount: 1
            height: implicitHeight

            states: State {
                name: "expanded"
                when: root.expanded

                PropertyChanges {
                    summary.maximumLineCount: undefined
                }

                AnchorChanges {
                    target: summary
                    anchors.top: appName.bottom
                }
            }

            transitions: Transition {
                PropertyAction {
                    target: summary
                    property: "maximumLineCount"
                }
                AnchorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on height {
                Anim {}
            }
        }

        TextMetrics {
            id: summaryMetrics

            text: root.notif.summary
            font.family: summary.font.family
            font.pointSize: summary.font.pointSize
            elide: Text.ElideRight
            elideWidth: expandBtn.x - time.width - timeSep.width - summary.x - Appearance.spacings.normal * 3
        }

        Common.StyledText {
            id: timeSep

            anchors.top: parent.top
            anchors.left: summary.right
            anchors.leftMargin: Appearance.spacings.normal

            text: "•"
            color: Appearance.material_colors.on_surface_variant
            font.pixelSize: Appearance.font.pixelSize.small

            states: State {
                name: "expanded"
                when: root.expanded

                AnchorChanges {
                    target: timeSep
                    anchors.left: appName.right
                }
            }

            transitions: Transition {
                AnchorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }

        Common.StyledText {
            id: time

            anchors.top: parent.top
            anchors.left: timeSep.right
            anchors.leftMargin: Appearance.spacings.normal

            animate: true
            horizontalAlignment: Text.AlignLeft
            text: root.notif.timeStr
            color: Appearance.material_colors.on_surface_variant
            font.pixelSize: Appearance.font.pixelSize.small
        }

        Item {
            id: expandBtn

            anchors.right: parent.right
            anchors.top: parent.top

            implicitWidth: expandIcon.height
            implicitHeight: expandIcon.height

            Common.StateLayer {
                radius: Appearance.rounding.full

                function onClicked() {
                    root.expanded = !root.expanded;
                }
            }

            Common.TintedIcon {
                id: expandIcon

                anchors.centerIn: parent

                //animate: true
                iconName: root.expanded ? "chevron_up" : "chevron_down"
                implicitSize: Appearance.font.pixelSize.normal
                tint: Appearance.material_colors.on_surface
            }
        }

        Common.StyledText {
            id: bodyPreview

            anchors.left: summary.left
            anchors.right: expandBtn.left
            anchors.top: summary.bottom
            anchors.rightMargin: Appearance.spacings.small

            animate: true
            textFormat: Text.MarkdownText
            text: bodyPreviewMetrics.elidedText
            color: Appearance.material_colors.on_surface_variant
            font.pixelSize: Appearance.font.pixelSize.small

            opacity: root.expanded ? 0 : 1

            Behavior on opacity {
                Anim {}
            }
        }

        TextMetrics {
            id: bodyPreviewMetrics

            text: root.notif.body
            font.family: bodyPreview.font.family
            font.pixelSize: bodyPreview.font.pixelSize
            elide: Text.ElideRight
            elideWidth: bodyPreview.width
        }

        Common.StyledText {
            id: body

            anchors.left: summary.left
            anchors.right: expandBtn.left
            anchors.top: summary.bottom
            anchors.rightMargin: Appearance.spacings.normal

            animate: true
            textFormat: Text.MarkdownText
            text: root.notif.body
            color: Appearance.material_colors.on_surface_variant
            font.pixelSize: Appearance.font.pixelSize.small
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            opacity: root.expanded ? 1 : 0

            Behavior on opacity {
                Anim {}
            }
        }

        RowLayout {
            id: actions

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: body.bottom
            anchors.topMargin: Appearance.spacings.normal

            spacing: Appearance.spacings.small

            opacity: root.expanded ? 1 : 0

            Behavior on opacity {
                Anim {}
            }

            Repeater {
                model: root.notif.actions

                delegate: Common.StyledRect {
                    id: action

                    required property NotificationAction modelData

                    radius: Appearance.rounding.full
                    color: Appearance.material_colors.surface_container_high

                    Layout.preferredWidth: actionText.width + Appearance.padding.normal * 2
                    Layout.preferredHeight: actionText.height + Appearance.padding.small * 2
                    implicitWidth: actionText.width + Appearance.padding.normal * 2
                    implicitHeight: actionText.height + Appearance.padding.small * 2

                    Common.StateLayer {
                        radius: Appearance.rounding.full

                        function onClicked(): void {
                            action.modelData.invoke();
                        }
                    }

                    Common.StyledText {
                        id: actionText

                        anchors.centerIn: parent
                        text: actionTextMetrics.elidedText
                        color: Appearance.material_colors.on_surface_variant
                        font.pointSize: Appearance.font.size.small
                    }

                    TextMetrics {
                        id: actionTextMetrics

                        text: modelData.text
                        font.family: actionText.font.family
                        font.pointSize: actionText.font.pointSize
                        elide: Text.ElideRight
                        elideWidth: {
                            const numActions = root.modelData.actions.length;
                            return (inner.width - actions.spacing * (numActions - 1)) / numActions - Appearance.padding.normal * 2;
                        }
                    }
                }
            }
        }
    }

    component Anim: NumberAnimation {
        duration: 200
        easing.type: Easing.OutCubic
    }
}
