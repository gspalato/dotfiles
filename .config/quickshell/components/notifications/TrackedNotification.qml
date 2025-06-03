import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: root

    required property Notification notification
    property bool isInTray: true

    signal dismiss
    signal discard
    signal discarded

    function handleDiscard() {
        if (!lock.retained)
            notification.dismiss();

        root.discarded();
    }

    function handleDismiss() {
        isInTray = true;
    }

    RetainableLock {
        id: lock
        object: root.notif
        locked: true
        onRetainedChanged: {
            if (retained)
                root.discard();
        }
    }

    expireTimeout: notification.expireTimeout
}
