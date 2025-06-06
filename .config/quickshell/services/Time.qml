pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property var data

    Process {
        id: proc
        command: ["date", "+%H:%M"]

        running: true
        stdout: SplitParser {
            onRead: data => {
                root.data = data;
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: proc.running = true
    }
}
