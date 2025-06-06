pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

import "modules" as Modules
import "modules/Workspaces" as Workspaces
import "root:/components/dashboard" as Dashboard
import "root:/components/common" as Common
import "root:/components/media" as Media
import "root:/config"
import "root:/services"

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

                height: Math.max(Appearance.sizes.barHeight, contentContainer.implicitHeight)
                color: "transparent"

                // Content
                Rectangle {
                    id: contentContainer

                    anchors.fill: parent
                    anchors.topMargin: Appearance.sizes.barTopMargin
                    anchors.rightMargin: Appearance.sizes.barRightMargin
                    anchors.bottomMargin: Appearance.sizes.barBottomMargin
                    anchors.leftMargin: Appearance.sizes.barLeftMargin

                    color: "transparent"

                    //implicitHeight: 50
                    implicitHeight: Appearance.sizes.barHeight + Appearance.sizes.barTopMargin + Appearance.sizes.barBottomMargin

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
                        Common.Separator {
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

                        Modules.Time {}

                        Modules.Connectivity {}

                        Modules.Battery {}

                        /*
                        Common.Separator {
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
