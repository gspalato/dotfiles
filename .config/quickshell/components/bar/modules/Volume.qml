pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "root:/services"
import "root:/components/common" as Common
import "root:/config"
import "root:/utils/colorUtils.js" as ColorUtils

Common.BarModule {
    id: root

    height: parent.height
    implicitWidth: height

    Common.CircularProgress {
        id: progress
        size: 30

        anchors.centerIn: parent

        primaryColor: Audio.sink.audio.muted ? Qt.alpha(Appearance.material_colors.primary, .75) : Appearance.material_colors.primary
        secondaryColor: "#22ffffff"

        value: Audio.sink?.audio.volume
    }

    Common.VolumeIcon {
        implicitSize: 14
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Audio.sink.audio.muted = !Audio.sink.audio.muted;
        }
        onWheel: event => {
            // On scroll, adjust the volume by 5%
            if (event.angleDelta.y > 0) {
                Audio.sink.audio.volume = Math.min(Audio.sink?.audio.volume + .05, 1);
            } else if (event.angleDelta.y < 0) {
                Audio.sink.audio.volume = Math.max(Audio.sink?.audio.volume - .05, 0);
            }
        }
    }
}
