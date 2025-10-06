// Created with Qt Quick Effect Maker (version 0.44), Sun Jun 8 14:59:01 2025

import QtQuick

Item {
    id: rootItem

    // This is the main source for the effect
    property Item source: null
    // Enable this to animate iTime property
    property bool timeRunning: false
    // When timeRunning is false, this can be used to control iTime manually
    property real animatedTime: frameAnimation.elapsedTime

    property vector3d color1: Qt.vector3d(0.141935, 0.773, 1)
    property vector3d color2: Qt.vector3d(0.753, 0.231627, 0.867)
    property vector3d color3: Qt.vector3d(0.22, 0.115485, 0.69)
    property vector3d color4: Qt.vector3d(0.882, 0.733, 0.212447)

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

        mesh: GridMesh {
            resolution: Qt.size(32, 32)
        }

        vertexShader: './LiquidGradient/liquidgradient.vert.qsb'
        fragmentShader: './LiquidGradient/liquidgradient.frag.qsb'
        anchors.fill: parent
    }
}
