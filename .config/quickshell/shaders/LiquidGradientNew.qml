// Created with Qt Quick Effect Maker (version 0.44), Sun Jun 8 16:46:53 2025

import QtQuick

Item {
    id: rootItem

    // This is the main source for the effect
    property Item source: null
    // Enable this to animate iTime property
    property bool timeRunning: false
    // When timeRunning is false, this can be used to control iTime manually
    property real animatedTime: frameAnimation.elapsedTime

    property size meshResolution: Qt.size(32, 32)

    property vector4d color1: Qt.vector4d(1, 0, 0, 1)
    property vector4d color2: Qt.vector4d(1, 0, 1, 1)
    property vector4d color3: Qt.vector4d(0, 0, 1, 1)
    property vector4d color4: Qt.vector4d(0, 1, 0, 1)
    property real seed: 0

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
        readonly property alias seed: rootItem.seed

        mesh: GridMesh {
            resolution: meshResolution
        }

        vertexShader: './LiquidGradientNew/liquidgradient.vert.qsb'
        fragmentShader: './LiquidGradientNew/liquidgradient.frag.qsb'
        anchors.fill: parent
    }
}
