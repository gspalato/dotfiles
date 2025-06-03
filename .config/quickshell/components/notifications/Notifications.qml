pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: notif

    property bool dndEnabled: false
    property int notifCount: notifServer.trackedNotifications.values.length
    property ScriptModel notifications: serverNotifications
    property NotificationServer server: notifServer

    function clearNotifications() {
        [...notifServer.trackedNotifications.values].forEach(elem => {
            elem.dismiss();
        });
        notif.notificationsCleared();
    }

    signal notificationReceived(Notification notif)
    signal notificationDismissed(int id)
    signal notificationsCleared

    NotificationServer {
        id: notifServer

        actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: n => {
            n.tracked = true;

            notif.notificationReceived(n);
            n.closed.connect(() => {
                notif.notificationDismissed(n.id);
            });
        }
    }

    ScriptModel {
        id: serverNotifications

        values: [...notifServer.trackedNotifications.values].reverse()
    }
}
