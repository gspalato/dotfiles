import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services
import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: volumeProgress

    implicitWidth: volumeProgress.implicitWidth
    implicitHeight: Appearance.sizes.barHeight

    CircularProgress2 {
        id: progress
        size: 30

        anchors.centerIn: parent

        primaryColor: Audio.sink.audio.muted ? Qt.alpha(Appearance.material_colors.primary, .75) : Appearance.material_colors.primary
        secondaryColor: "#22ffffff"

        value: Audio.sink?.audio.volume
    }

    /*
    VolumeIcon {
        implicitSize: 14
        anchors.centerIn: parent
    }
    */

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