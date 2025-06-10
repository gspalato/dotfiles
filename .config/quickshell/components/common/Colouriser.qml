import QtQuick
import QtQuick.Effects

MultiEffect {
    colorization: 1

    Behavior on colorizationColor {
        ColorAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
}
