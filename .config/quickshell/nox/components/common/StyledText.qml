import QtQuick
import QtQuick.Layouts

import "root:/config"

Text {
    id: root

    property bool animate: false
    property string animateProp: "scale"
    property real animateFrom: 0
    property real animateTo: 1
    property int animateDuration: 200

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: Appearance.material_colors.on_surface ?? "#ffffff"
    font.family: Appearance.font.family.main
    font.pixelSize: Appearance.font.pixelSize.normal

    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    Behavior on text {
        enabled: root.animate

        SequentialAnimation {
            Anim {
                to: root.animateFrom
                easing.bezierCurve: Appearance.animation.curves.standardAccel
            }
            PropertyAction {}
            Anim {
                to: root.animateTo
                easing.bezierCurve: Appearance.animation.curves.standardDecel
            }
        }
    }

    component Anim: NumberAnimation {
        target: root
        property: root.animateProp
        duration: root.animateDuration / 2
        easing.type: Easing.OutCubic
    }
}
