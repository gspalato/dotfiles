pragma ComponentBehavior: Bound

import "root:/services"
import "root:/config"
import QtQuick
import QtQuick.Controls

TextField {
    id: root

    color: Appearance.material_colors.on_surface
    placeholderTextColor: Appearance.material_colors.outline
    font.family: Appearance.font.family.main
    font.pointSize: Appearance.font.pixelSize.smaller

    cursorDelegate: StyledRect {
        id: cursor

        property bool disableBlink

        implicitWidth: 2
        color: Appearance.material_colors.on_surface
        radius: Appearance.rounding.normal
        onXChanged: {
            opacity = 1;
            disableBlink = true;
            enableBlink.start();
        }

        Timer {
            id: enableBlink

            interval: 100
            onTriggered: cursor.disableBlink = false
        }

        Timer {
            running: root.cursorVisible && !cursor.disableBlink
            repeat: true
            interval: 500
            onTriggered: parent.opacity = parent.opacity === 1 ? 0 : 1
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    Behavior on placeholderTextColor {
        ColorAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
}
