pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<QtObject> bars

    property var dashboardPanelWindow: null
    property var dashboard: null
    function toggleDashboard() {
        if (root.dashboard) {
            root.dashboard.shown = !root.dashboard.shown;
        } else {
            console.warn("Dashboard not initialized");
        }
    }

    property var wallpaperSelect: null
    function toggleWallpaperSelect() {
        if (root.wallpaperSelect) {
            root.wallpaperSelect.shown = !root.wallpaperSelect.shown;
        } else {
            console.warn("Wallpaper select not initialized");
        }
    }
}
