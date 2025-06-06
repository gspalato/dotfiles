pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<QtObject> bars

    property var dashboard: null
    function toggleDashboard() {
        if (root.dashboard) {
            root.dashboard.shown = !root.dashboard.shown;
        } else {
            console.warn("Dashboard not initialized");
        }
    }
}
