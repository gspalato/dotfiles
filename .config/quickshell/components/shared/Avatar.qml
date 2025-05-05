import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

import "../../config"
/*
Rectangle {
    id: root
    height: parent.height
    width: parent.height

    antialiasing: true
    border.width: .5
    border.color: Theme.border
    border.pixelAligned: false
    radius: 100

    clip: true

    property var resolvedAvatarPath

    // Get current username
    Process {
        id: proc
        command: ["sh", "-c", "echo $HOME/.face.icon"]
        running: true

        stdout: SplitParser {
            onRead: data => resolvedAvatarPath = data
        }
    }

    Image {
        id: img
        height: parent.height
        width: parent.height

        layer.enabled: false
        layer.smooth: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
            maskSource: Item {
                id: mask
                width: root.width
                height: root.height
                layer.enabled: true
                visible: false

                Rectangle {
                    width: root.width
                    height: root.height
                    radius: 100
                    color: "black"
                }
            }
        }

        source: resolvedAvatarPath
    }
}
*/

import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: root
    height: parent.height
    width: parent.height

    property var resolvedAvatarPath

    // Get current username
    Process {
        id: proc
        command: ["sh", "-c", "echo $HOME/.face.icon"]
        running: true

        stdout: SplitParser {
            onRead: data => resolvedAvatarPath = data
        }
    }

    Image {
        id: img
        source: resolvedAvatarPath ?? ""
        width: root.width
        height: root.width
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectCrop
        mipmap: true
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }
    
    Rectangle {
        id: mask
        width: root.width
        height: width
        radius: 100
        visible: false
    }
}

