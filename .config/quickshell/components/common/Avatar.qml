import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

import "../../config"

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
