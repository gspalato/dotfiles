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

        Shaders.MaskedGradientSwirl {
            id: gradientSwirl
            source: progress
            timeRunning: true

            anchors.fill: progress

            property color _color1: "#ffffff" || Appearance.material_colors.primary
            property color _color2: "#ffffff" || Appearance.material_colors.primary
            property color _color3: "#ffffff" || Appearance.material_colors.source_color
            property color _color4: "#ffffff" || Appearance.material_colors.source_color

            Behavior on _color1 {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on _color2 {
                ColorAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on _color3 {
                ColorAnimation {
                    duration: 400
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on _color4 {
                ColorAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            color1: Qt.vector3d(_color1.r, _color1.g, _color1.b)
            color2: Qt.vector3d(_color2.r, _color2.g, _color2.b)
            color3: Qt.vector3d(_color3.r, _color3.g, _color3.b)
            color4: Qt.vector3d(_color4.r, _color4.g, _color4.b)
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
