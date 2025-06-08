import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import "root:/components/common" as Common

import "root:/config"
import "root:/utils/colorUtils.js" as ColorUtils

Control {
    id: root
    width: 50
    height: 30

    property bool checked: false
    //property int padding: 4

    property color activeBackgroundColor: Appearance.material_colors.primary
    property color indicatorColor: "white"

    signal toggled

    Rectangle {
        id: background
        anchors.fill: parent
        radius: height / 2

        color: root.checked ? activeBackgroundColor : "#11ffffff"
        Behavior on color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        antialiasing: true
        border.width: .5
        border.pixelAligned: true
        border.color: ColorUtils.alpha(Qt.lighter(background.color, 1.25), .2)

        Rectangle {
            id: indicator
            width: root.height - 2 * 3
            height: width
            radius: width / 2

            color: "#ffffff"

            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? background.width - width - 3 : 3
            Behavior on x {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }

            layer.enabled: true
            layer.smooth: true
            layer.effect: MultiEffect {
                shadowVerticalOffset: 0
                shadowHorizontalOffset: 0
                shadowBlur: .5
                shadowColor: "#000000"
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.toggled()
    }
}
