pragma ComponentBehavior: Bound

import QtQuick 2.15

import "root:/config"
import "root:/shaders" as Shaders

Item {
    id: root
    width: 200
    height: 6

    property real from: 0.0
    property real to: 1.0
    property real stepSize: 0.01
    readonly property int stepCount: Math.max(1, Math.floor((to - from) / stepSize))

    // value in the normalized [0,1] range
    property real value: 0.5

    property color trackColor: "#33ffffff"
    property real trackRadius: 10
    property color fillColor: "#ffffff"
    property color thumbColor: "#ffffff"
    property real thumbRadius: 0

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: root.height
        radius: trackRadius
        color: trackColor
        Behavior on color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
    }

    Rectangle {
        id: progress
        anchors.verticalCenter: track.verticalCenter
        width: value * parent.width
        height: track.height
        radius: track.radius
        color: fillColor
        Behavior on color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent

        onPressed: updateValue(mouse.x)
        onPositionChanged: {
            if (pressed)
                updateValue(mouse.x);
        }

        function updateValue(xPos) {
            const normalized = Math.max(0, Math.min(1, xPos / root.width));
            const stepped = Math.round(normalized * stepCount) / stepCount;

            if (stepped !== root.value) {
                root.value = stepped;
            }
        }
    }
}
