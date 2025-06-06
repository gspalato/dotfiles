pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Configuration
Singleton {
    property var minWorkspaceCount: 5
    property var maxWorkspaceCount: 10

    property var defaultNotificationTimeout: 5000
    property var criticalNotificationTimeout: 10000

    property string wallpaperDirectory: "/home/spxlato/Pictures/Wallpapers"
}
