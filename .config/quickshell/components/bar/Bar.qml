pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts

import "modules" as Modules
import "modules/Workspaces" as Workspaces
import "../shared" as Shared
import "../media" as Media
import "../../config"

Scope {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            PanelWindow {
                id: bar

                property var modelData

                anchors {
                    top: true
                    left: true
                    right: true
                }

                height: Theme.moduleHeight + Theme.barMargins[0]
                color: Qt.rgba(0,0,0,0)

                Rectangle {
                    id: contentContainer

                    anchors.fill: parent
                    anchors.margins: Theme.barMargins[0]

                    color: "transparent"

                    height: Theme.moduleHeight

                    // Left widgets
                    RowLayout {
                        id: leftWidgets

                        spacing: 10
                        layoutDirection: Qt.LeftToRight
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        //Shared.Avatar {}

                        Workspaces.Workspaces {
                            bar: bar
                        }

                        Modules.Media {
                            id: mediaModule
                            bar: bar
                        }
                    }

                    RowLayout {
                        id: centerWidgets

                        spacing: 10
                        layoutDirection: Qt.LeftToRight
                        anchors.centerIn: parent
                        height: parent.height

                        Shared.Avatar {}

                        Modules.Window {
                            bar: bar
                        }
                    }

                    // Right widgets
                    RowLayout {
                        id: rightWidgets

                        spacing: 10
                        layoutDirection: Qt.RightToLeft
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        Modules.Time {
                            bar: bar
                        }
                    }
                }
            }
        }
    }
}