// Created with Qt Quick Effect Maker (version 0.44), Fri Jun 6 03:24:53 2025

import QtQuick

Item {
    id: rootItem

    // This is the main source for the effect
    property Item source: null
    // Enable this to animate iTime property
    property bool timeRunning: true
    // When timeRunning is false, this can be used to control iTime manually
    property real animatedTime: frameAnimation.elapsedTime

    property vector3d color1: Qt.vector3d(0.698, 0.773, 1)
    property vector3d color2: Qt.vector3d(0.753, 0.776, 0.867)
    property vector3d color3: Qt.vector3d(0.22, 0.357, 0.69)
    property vector3d color4: Qt.vector3d(0.882, 0.733, 0.863)

    FrameAnimation {
        id: frameAnimation
        running: rootItem.timeRunning
    }

    ShaderEffect {
        readonly property alias iSource: rootItem.source
        readonly property alias iTime: rootItem.animatedTime
        readonly property vector3d iResolution: Qt.vector3d(width, height, 1.0)
        readonly property alias color1: rootItem.color1
        readonly property alias color2: rootItem.color2
        readonly property alias color3: rootItem.color3
        readonly property alias color4: rootItem.color4

        vertexShader: 'maskedgradientswirl.vert.qsb'
        fragmentShader: 'maskedgradientswirl.frag.qsb'
        anchors.fill: parent
    }
}
