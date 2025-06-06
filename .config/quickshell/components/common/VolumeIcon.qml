import QtQuick
import Quickshell
import Quickshell.Widgets

import "root:/services"

IconImage {
    id: root
    property real volume: Audio.sink?.audio.volume || 0
    property string iconName: {
        if (volume <= 0) {
            return "volume-muted";
        } else if (volume <= 33) {
            return "volume-low";
        } else if (volume <= 66) {
            return "volume-medium";
        } else {
            return "volume-high";
        }
    }

    implicitSize: 18
    Binding {
        root.source: "root:/assets/icons/" + root.iconName + ".svg"
    }
}
