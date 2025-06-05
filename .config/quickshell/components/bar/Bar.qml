pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

import "modules" as Modules
import "modules/Workspaces" as Workspaces
import "root:/components/dashboard" as Dashboard
import "root:/components/shared" as Shared
import "root:/components/media" as Media
import "root:/config"
import "root:/data"

Scope {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            PanelWindow {
                id: bar
                WlrLayershell.namespace: "nox:bar"

                property var modelData

                anchors {
                    top: true
                    left: true
                    right: true
                }

                height: Math.max(Theme.barHeight, contentContainer.implicitHeight)
                color: "transparent"

                // Content
                Rectangle {
                    id: contentContainer

                    anchors.fill: parent
                    anchors.topMargin: Theme.barMargins[0]
                    anchors.rightMargin: Theme.barMargins[1]
                    anchors.bottomMargin: Theme.barMargins[2]
                    anchors.leftMargin: Theme.barMargins[3]

                    color: "transparent"

                    implicitHeight: Theme.barHeight + Theme.barMargins[0] + Theme.barMargins[2]

                    // Left widgets
                    RowLayout {
                        id: leftWidgets

                        spacing: 5
                        layoutDirection: Qt.LeftToRight

                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        Workspaces.Workspaces {}

                        /*
                        Shared.Separator {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        */

                        Modules.Media {
                            id: mediaModule
                            bar: bar
                        }
                    }

                    RowLayout {
                        id: centerWidgets

                        spacing: 5
                        layoutDirection: Qt.LeftToRight
                        anchors.centerIn: parent

                        height: parent.height

                        Modules.Window {}
                    }

                    // Right widgets
                    RowLayout {
                        id: rightWidgets

                        spacing: 5
                        layoutDirection: Qt.LeftToRight

                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        Modules.Connectivity {}

                        Modules.Time {}

                        /*
                        Shared.Separator {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        */

                        Modules.DashboardButton {
                            id: dashboardButton
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }

                Component.onCompleted: () => {
                    Panels.bars.push(bar);
                }
            }
        }
    }
}
