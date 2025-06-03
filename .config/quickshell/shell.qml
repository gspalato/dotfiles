pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "components/bar" as BarComponents
import "components/dashboard" as DashboardComponents
import "components/notifications" as Notifs

import "root:/data"

ShellRoot {
    BarComponents.Bar {
        id: bar
    }

    DashboardComponents.DashboardPanel {
        id: dashboardPanel

        mask: Region {
            x: dashboard.x
            y: dashboard.y
            width: dashboard.shown && dashboard.width
            height: dashboard.shown && dashboard.height
        }

        DashboardComponents.Dashboard {
            id: dashboard

            Component.onCompleted: {
                Panels.dashboard = dashboard;
            }
        }
    }

    Notifs.NotificationPanel {
        id: notifPanel
        screen: Quickshell.screens.find(s => s.name == "DP-1")

        margins {
            top: 60
        }
    }
}
