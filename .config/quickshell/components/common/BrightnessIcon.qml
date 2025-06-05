import QtQuick
import Quickshell
import Quickshell.Widgets

IconImage {
    id: root
    property real brightness: 0
    property string iconName: {
        if (brightness === 0) {
            return "volume-muted";
        } else if (brightness < 50) {
            return "volume-low";
        } else if (brightness < 75) {
            return "volume-medium";
        } else {
            return "volume-high";
        }
    }

    implicitSize: 18
    source: `root:/assets/icons/${iconName}.svg`
}
