import QtQuick
import QtQuick.Timeline
import Quickshell
import Quickshell.Services.Notifications

import "root:/config"
import "root:/components/common" as Common
import "root:/components/notifications" as Notifs
import "root:/utils/utils.js" as Utils

ListView {
    id: notifList

    height: Math.max(100, Math.min(contentHeight, 500))
    Behavior on height {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    property ListModel notifications: ListModel {
        id: data
        Component.onCompleted: () => {
            Notifs.Notifications.notificationReceived.connect(n => {
                // Ignore notifications when quickshell reloads.
                if (!n.lastGeneration) {
                    data.insert(0, {
                        n: n
                    });
                }
            });
        }
    }

    model: notifications

    spacing: 5

    delegate: Notifs.NotificationWidget {
        id: widget

        required property int index
        required property Notification modelData

        notif: modelData
        changeOpacityOnSwipe: false

        showProgressToDismiss: false

        width: parent?.width

        // Remove the notification only from this popup list view model.
        callbackOnDismiss: id => {
            for (let i = 0; i < notifList.notifications.count; i++) {
                const e = notifList.notifications.get(i);
                if (e.n.id === id) {
                    notifList.notifications.remove(i);
                    return;
                }
            }
        }

        // Only trigger the remove animation if the notification was
        // removed NOT by a swipe gesture.
        ListView.onRemove: () => x === 0 && removeAnimation.start()
        SequentialAnimation {
            id: removeAnimation
            PropertyAction {
                target: widget
                property: "ListView.delayRemove"
                value: true
            }
            NumberAnimation {
                target: widget
                property: "x"
                from: 0
                to: width
                duration: 300
                easing.type: Easing.OutCubic
            }
            PropertyAction {
                target: widget
                property: "ListView.delayRemove"
                value: false
            }
        }

        Timer {
            id: removeTimer
            interval: modelData.expireTimeout > 0 ? modelData.expireTimeout : (modelData.urgency === NotificationUrgency.Critical ? Config.criticalNotificationTimeout : Config.defaultNotificationTimeout) // 5 seconds
            repeat: false
            running: true
            onTriggered: {
                widget.triggerRemoveAnimation();
            }
        }
    }

    add: Transition {
        SequentialAnimation {
            // Start offscreen to the right
            PropertyAction {
                property: "x"
                value: parent.width
            }

            // Wait for displaced items to move down first
            PauseAnimation {
                duration: 300
            }

            // Then slide new item from right to its position
            NumberAnimation {
                properties: "x"
                from: parent.width // start offscreen right
                to: 0 // final x
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    }

    populate: Transition {
        SequentialAnimation {
            // Start offscreen to the right
            PropertyAction {
                property: "x"
                value: parent.width
            }

            // Wait for displaced items to move down first
            PauseAnimation {
                duration: 300
            }

            // Then slide new item from right to its position
            NumberAnimation {
                properties: "x"
                from: parent.width // start offscreen right
                to: 0 // final x
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    }

    addDisplaced: Transition {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
            properties: "y"
        }
    }

    removeDisplaced: Transition {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
            properties: "y"
        }
    }
}
