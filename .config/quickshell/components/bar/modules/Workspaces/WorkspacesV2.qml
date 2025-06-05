pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../../../common" as Common
import "../../../../config"
import "../../../../data"

// Container
Common.BarModule {
    id: root

    property real size: 10
    property real pillExtraWidth: 10
    property real selectedWidth: 20
    property real indicatorSpacing: 4

    property int currentWorkspace: 1
    property int visibleCount: {
        return Math.max(Config.minWorkspaceCount, currentWorkspace);
    }

    property var indicatorWidths: []
    function resetWidths() {
        indicatorWidths = Array(visibleCount).fill(radius * 2);
        updateWidths(true);
    }
    function updateWidths(immediate = false) {
        for (let i = 0; i < visibleCount; i++) {
            const targetWidth = (i === currentWorkspace) ? radius * 2 + pillExtraWidth : radius * 2;
            if (immediate) {
                indicatorWidths[i] = targetWidth;
            } else {
                animateWidth(i, targetWidth);
            }
        }
    }
    function animateWidth(index, targetWidth) {
        const animation = Qt.createQmlObject(`
            import QtQuick 2.15
            NumberAnimation {
                duration: 180;
                easing.type: Easing.InOutQuad
            }
        `, canvas, "WidthAnim");

        animation.from = indicatorWidths[index];
        animation.to = targetWidth;
        animation.onRunningChanged.connect(() => requestPaint());
        animation.onValueChanged.connect(v => {
            indicatorWidths[index] = v;
            requestPaint();
        });
        animation.start();
    }
    Component.onCompleted: resetWidths()

    implicitWidth: ((visibleCount - 1) * (size + indicatorSpacing) + selectedWidth) + Appearance.sizes.moduleHorizontalPadding

    Behavior on implicitWidth {
        NumberAnimation {
            // Make duration proportional to the number of workspaces skipped
            duration: 200
            easing.type: EasingInOutQuad
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

    FrameAnimation {
        running: true
        onTriggered: {
            workspaceCanvas.requestAnimationFrame(() => workspaceCanvas.onPaint());
        }
    }

    Canvas {
        id: workspaceCanvas

        function onPaint() {
            const ctx = workspaceCanvas.getContext("2d");
            const cw = workspaceCanvas.width;
            const ch = workspaceCanvas.height;
            ctx.clearRect(0, 0, cw, ch);

            const spacing = indicatorSpacing;
            const radius = size / 2;
            const centerY = ch / 2;

            let x = 0;
            for (let i = 0; i < visibleCount; i++) {
                const w = indicatorWidths[i];
                const isActive = i === currentWorkspace;

                //ctx.globalAlpha = isActive ? 1.0 : 0.25;
                ctx.fillStyle = "white";
                ctx.beginPath();

                const y = centerY - radius;

                if (w > radius * 2 + 1) {
                    // pill shape
                    const h = radius * 2;
                    const r = radius;

                    ctx.moveTo(x + r, y);
                    ctx.lineTo(x + w - r, y);
                    ctx.arcTo(x + w, y, x + w, y + r, r);
                    ctx.lineTo(x + w, y + h - r);
                    ctx.arcTo(x + w, y + h, x + w - r, y + h, r);
                    ctx.lineTo(x + r, y + h);
                    ctx.arcTo(x, y + h, x, y + h - r, r);
                    ctx.lineTo(x, y + r);
                    ctx.arcTo(x, y, x + r, y, r);
                } else {
                    // circle
                    ctx.arc(x + radius, centerY, radius, 0, 2 * Math.PI);
                }

                ctx.fill();
                x += w + indicatorSpacing;
            }
        }
    }
}
