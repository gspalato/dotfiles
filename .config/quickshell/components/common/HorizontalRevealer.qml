pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

// HorizontalRevealer.qml
Item {
    id: root

    property bool revealed: false
    property string direction: "left"
    property int duration: 300
    property real contentWidth: contentLoader.item ? contentLoader.item.width : 0

    width: revealed ? contentWidth : 0
    height: contentLoader.item ? contentLoader.item.height : 0
    clip: true

    Behavior on width {
        NumberAnimation {
            duration: root.duration
            easing.type: Easing.InOutQuad
        }
    }

    Loader {
        id: contentLoader
        // No anchors.fill here — just load the component
        sourceComponent: content
        onItemChanged: {
            // Position off-screen initially
            slideTransform.x = revealed
                ? 0
                : (direction === "right" ? contentWidth : -contentWidth)
        }

        transform: [
            Translate { id: slideTransform }
        ]
    }

    NumberAnimation {
        id: slideAnim
        target: slideTransform
        property: "x"
        duration: root.duration
        easing.type: Easing.InOutQuad
    }

    onRevealedChanged: {
        slideAnim.to = revealed
            ? 0
            : (direction === "right" ? contentWidth : -contentWidth)
        slideAnim.running = true
    }

    default property alias content: contentLoader.sourceComponent
}
