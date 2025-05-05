pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "../../shared" as Shared
import "../../../config"
import "../../../data"

// Container
Shared.BarModule {
    implicitHeight: Theme.moduleHeight
    implicitWidth: timeText.implicitWidth + Theme.modulePadding[1]

    id: container
    color: Theme.moduleColor

    Text {
        id: timeText

        font.family: Theme.fontFamily
        font.pixelSize: 16
        font.weight: Theme.defaultFontWeight

        color: "#ffffff"

        anchors.centerIn: parent
        text: Time.data ?? ""
    }
}