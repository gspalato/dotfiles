import QtQuick
import Quickshell
import Quickshell.Widgets

IconImage {
    id: root
    property real volume: 0
    property string iconName: {
        if (volume === 0) {
            return "volume-muted";
        } else if (volume < 50) {
            return "volume-low";
        } else if (volume < 75) {
            return "volume-medium";
        } else {
            return "volume-high";
        }
    }

    implicitSize: 18
    source: `root:/assets/icons/${iconName}.svg`
}
