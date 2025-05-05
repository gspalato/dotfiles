pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Configuration
Singleton {
    // Shared
    property var primary: "#ffffff"
    property var secondary: "#aaaaaa"

    property var background: Qt.rgba(0, 0, 0, .15)
    property var foreground: Qt.rgba(255, 255, 255, 0.93)
    property var border: Qt.rgba(255, 255, 255, 0.025)
    property var fontFamily: "Figtree"
    property var defaultFontSize: 16
    property var defaultFontWeight: 600

    // Bar
    property var barMode: "modular" // "modular" or "unified"

    property var barMargins: [10, 10, 0, 10]

    property var barColor: Qt.rgba(0, 0, 0, .15)
    property var barHeight: 35

    property var moduleHeight: 35
    property var moduleColor: Qt.rgba(0, 0, 0, 1)
    property var modulePadding: [0, 30]
}