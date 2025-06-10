pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import "root:/config"
import "root:/services"

Singleton {
    id: root

    readonly property list<Notif> list: []
    readonly property list<Notif> popups: list.filter(n => n.popup)

    //property bool doNotDisturb: false
    property int notifCount: list.length
    property NotificationServer server: notifServer

    function clearNotifications() {
        [...notifServer.trackedNotifications.values].forEach(elem => {
            elem.dismiss();
        });

        root.notificationsCleared();
    }

    signal notificationReceived(Notif notif)
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

            root.notificationReceived(notifComp.createObject(root, {
                popup: true,
                notification: n
            }));

            n.closed.connect(() => {
                list = list.filter(notif => notif.id !== n.id);
                root.notificationDismissed(n.id);
            });

            root.list.push(notifComp.createObject(root, {
                popup: true,
                notification: n
            }));
        }
    }

    // Custom notification component
    component Notif: QtObject {
        id: notif

        property bool popup
        readonly property date time: new Date()
        readonly property string timeStr: {
            const diff = Time.date.getTime() - time.getTime();
            const m = Math.floor(diff / 60000);
            const h = Math.floor(m / 60);

            if (h < 1 && m < 1)
                return "now";
            if (h < 1)
                return `${m}m`;
            return `${h}h`;
        }

        function resumeTimeout() {
            notif.timer.start();
        }

        function pauseTimeout() {
            notif.timer.stop();
        }

        required property Notification notification
        readonly property int id: notification.id
        readonly property string summary: notification.summary
        readonly property string body: notification.body
        readonly property string appIcon: notification.appIcon
        readonly property string appName: notification.appName
        readonly property string image: notification.image
        readonly property var urgency: notification.urgency // Idk why NotificationUrgency doesn't work
        readonly property list<NotificationAction> actions: notification.actions

        signal timeoutExpired
        readonly property Timer timer: Timer {
            running: true
            interval: notif.notification.expireTimeout > 0 ? notif.notification.expireTimeout : Config.defaultNotificationTimeout
            onTriggered: {
                //if (NotifsConfig.expire)
                //    notif.popup = false;
                notif.timeoutExpired();
            }
        }

        /*
        readonly property Connections conn: Connections {
            target: notif.notification.Retainable

            function onDropped(): void {
                root.list.splice(root.list.indexOf(notif), 1);
            }

            function onAboutToDestroy(): void {
                notif.destroy();
            }
        }
        */
    }

    Component {
        id: notifComp

        Notif {}
    }
}
