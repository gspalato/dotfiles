pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "root:/components/common" as Common
import "root:/config"
import "root:/services"

// Container
Common.BarModule {
    id: root

    property real size: 5

    property real activeHeight: 10
    property real activeWidth: 20

    property real relevantHeight: 7
    property real relevantWidth: 7

    property real indicatorSpacing: 7

    property var activeWorkspaceColor: Appearance.material_colors.primary

    property int focusedWorkspaceId: Hyprland.focusedMonitor?.activeWorkspace.id
    Behavior on focusedWorkspaceId {
        NumberAnimation {
            duration: 200
            easing.type: Appearance.easings.main
        }
    }

    implicitWidth: indicatorRow.implicitWidth + Appearance.sizes.moduleHorizontalPadding
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Appearance.easings.main
        }
    }

    // Handle scrolling to change workspace.
    MouseArea {
        anchors.fill: parent
        onWheel: event => {
            if (root.focusedWorkspaceId <= 10 && root.focusedWorkspaceId > 0 && event.angleDelta.y > 0) {
                Hyprland.dispatch("workspace -1");
            } else if (root.focusedWorkspaceId >= 0 && root.focusedWorkspaceId < 10 && event.angleDelta.y < 0) {
                Hyprland.dispatch("workspace +1");
            }
        }
    }

    RowLayout {
        id: indicatorRow

        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: Appearance.sizes.moduleHorizontalPadding / 2

        uniformCellSizes: false

        spacing: root.indicatorSpacing

        Repeater {
            id: repeater

            model: Math.max(Config.minWorkspaceCount, HyprlandUtils.maxWorkspace)

            Workspace {
                id: ws
                required property int index

                property bool focused: index + 1 === focusedWorkspaceId
                onFocusedChanged: {
                    if (focused) {
                        growAnimation.start();
                    } else {
                        shrinkAnimation.start();
                    }
                }

                Layout.preferredHeight: size
                Layout.preferredWidth: size
                Layout.alignment: Qt.AlignVCenter

                color: focused ? activeWorkspaceColor : "#22ffffff"
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                ParallelAnimation {
                    id: growAnimation

                    NumberAnimation {
                        target: ws
                        property: "Layout.preferredHeight"
                        from: size
                        to: activeHeight
                        duration: 200
                        easing.type: Easing.OutCubic
                    }

                    NumberAnimation {
                        target: ws
                        property: "Layout.preferredWidth"
                        from: size
                        to: activeWidth
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }

                ParallelAnimation {
                    id: shrinkAnimation

                    NumberAnimation {
                        id: shrinkHeightAnim
                        target: ws
                        property: "Layout.preferredHeight"
                        from: activeHeight
                        to: size
                        duration: 200
                        easing.type: Easing.OutCubic
                    }

                    NumberAnimation {
                        id: shrinkWidthAnim
                        target: ws
                        property: "Layout.preferredWidth"
                        from: activeWidth
                        to: size
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
