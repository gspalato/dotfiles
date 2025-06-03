import Quickshell
import QtQuick

PopupWindow {
    id: root

    required property PanelWindow bar
    //property bool shown: false
    //property var currentPopup: null

    //visible: shown

    height: 300
    width: bar.width

    anchor.window: bar
    anchor.rect.y: bar.height + 10
    anchor.rect.x: bar.left
    visible: true

    color: "transparent"

    Rectangle {
        id: background
        anchors.fill: parent

        anchors.margins: Theme.barMargins[0]

        color: Qt.rgba(0,0,0,0.25)
    }
}