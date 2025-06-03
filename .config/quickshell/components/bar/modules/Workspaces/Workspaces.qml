pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../../../shared" as Shared
import "../../../../config"
import "../../../../data"

// Container
Shared.BarModule {
    id: root

    property real size: 5

    property real activeHeight: 10
    property real activeWidth: 20

    property real relevantHeight: 7
    property real relevantWidth: 7

    property real indicatorSpacing: 7

    property var activeWorkspaceColor: Theme.primary

    //property HyprlandWorkspace focusedWorkspace: Hyprland.workspaces.values.find(e => e.id == index + 1) || null
    property int focusedWorkspaceId: Hyprland.focusedMonitor.activeWorkspace.id
    property int visibleCount: {
        return Math.max(Config.minWorkspaceCount, focusedWorkspaceId);
    }

    property real workspaceTransitionProgress: 0 // 0 to visibleCount - 1
    Binding {
        root.workspaceTransitionProgress: focusedWorkspaceId - 1
    }

    function mapProgressToIndicatorProportion(progress, index) {
        // Calculate the absolute difference between progress and index
        const diff = Math.abs(progress - index);

        // Normalize the difference to the range 0 to 1, where ±0.5 maps to 0
        const proportion = Math.max(0, 1 - diff * 2);  // Clamping to 0 at a distance of 0.5

        return proportion;
    }

    Binding {
        root.implicitWidth: indicatorRow.implicitWidth + Theme.modulePadding[1]
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    // Handle scrolling to change workspace.
    MouseArea {
        anchors.fill: parent
        onWheel: event => {
            // TODO streamline this
            if (root.mon?.id <= 10) {
                (event.angleDelta.y > 0) ? Hyprland.dispatch("workspace -1") : Hyprland.dispatch("workspace +1");
            } else {
                Hyprland.dispatch("workspace 10");
            }
        }
    }

    RowLayout {
        id: indicatorRow

        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: Theme.modulePadding[1] / 2

        uniformCellSizes: false

        spacing: root.indicatorSpacing

        Repeater {
            id: repeater

            model: HyprlandUtils.maxWorkspace

            Workspace {
                id: ws
                required property int index

                property bool focused: index + 1 === focusedWorkspaceId
                property real proportion: root.mapProgressToIndicatorProportion(root.workspaceTransitionProgress, index)

                Layout.preferredHeight: focused ? activeHeight : size
                Layout.preferredWidth: size + (activeWidth - size) * proportion

                color: activeWorkspaceColor
                opacity: focused ? 1 : .25

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                Behavior on Layout.preferredWidth {
                    NumberAnimation {
                        duration: 50
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
}
