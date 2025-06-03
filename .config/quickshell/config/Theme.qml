pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import "."

// Configuration
Singleton {
    // Shared
    property var primary: "#ffffff"
    property var secondary: "#aaaaaa"

    property var background: Qt.rgba(0, 0, 0, .15)
    property var foreground: Qt.rgba(255, 255, 255, 0.9)
    property var border: Qt.rgba(255, 255, 255, 0.025)
    property var fontFamily: "Figtree"
    property var defaultFontSize: 16
    property var defaultFontWeight: 600

    // Bar
    property var barMode: "modular" // "modular" or "unified"
    property var barMargins: [10, 10, 0, 10]
    property var barColor: Qt.rgba(Matugen.background.r, Matugen.background.g, Matugen.background.b, .4)
    property var resolvedBarColor: Theme.barMode === "modular" ? "transparent" : Theme.barColor
    property var barHeight: moduleHeight + barMargins[0]

    property var moduleHeight: 40
    property var moduleColor: Qt.rgba(Matugen.background.r, Matugen.background.g, Matugen.background.b, .45)
    property var moduleBorder: Qt.rgba(Qt.lighter(Matugen.background, 1.75).r, Qt.lighter(Matugen.background, 1.75).g, Qt.lighter(Matugen.background, 1.75).b, .45)
    property var resolvedModuleColor: Theme.barMode === "modular" ? Theme.moduleColor : "transparent"
    property var modulePadding: [0, 30]
}
