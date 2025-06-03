pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "root:/config"

Rectangle {
    height: parent.height
    width: parent.width
    anchors.centerIn: parent

    color: Theme.background
    border.color: Theme.border
    radius: 30
}