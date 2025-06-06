//@ pragma UseQApplication

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell

import "components/bar" as Bar
import "components/dashboard" as Dashboard
import "components/notifications" as Notifs
import "components/wallpaperSelect" as WallpaperSelect

import "root:/services"
import "root:/config"

ShellRoot {
    Bar.Bar {
        id: bar
    }

    Dashboard.DashboardPanel {
        id: dashboardPanel

        mask: Region {
            x: dashboard.x
            y: dashboard.y
            width: dashboard.shown && dashboard.width
            height: dashboard.shown && dashboard.height
        }

        ColumnLayout {
            id: dashboardPadding
            anchors.fill: parent

            spacing: 0

            Dashboard.Dashboard {
                id: dashboard

                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                Layout.margins: 10
                Layout.fillWidth: true

                Component.onCompleted: {
                    Panels.dashboard = dashboard;
                }
            }
        }

        Component.onCompleted: {
            Panels.dashboardPanelWindow = dashboardPanel;
        }
    }

    Notifs.NotificationPanel {
        id: notifPanel
        //screen: Quickshell.screens.find(s => s.name == "DP-1")

        margins {
            top: 60
        }
    }

    // Work in progress.
    /*
    WallpaperSelect.WallpaperSelectPanel {
        id: wallpaperSelectPanel
    }
    */

    Component.onCompleted: {
        Matugen.reapplyTheme();
    }
}
