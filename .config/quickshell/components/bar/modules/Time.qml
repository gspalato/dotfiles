pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "root:/components/common" as Common
import "root:/config"
import "root:/data"

// Container
Common.BarModule {
    id: container
    implicitHeight: Appearance.sizes.moduleHeight
    implicitWidth: timeText.implicitWidth + Appearance.sizes.moduleHorizontalPadding

    color: Appearance.colors.moduleColor
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    Common.StyledText {
        id: timeText

        font.family: Appearance.font.family.display
        font.pixelSize: Appearance.font.pixelSize.small
        font.weight: 600

        color: Appearance.material_colors.on_surface

        anchors.centerIn: parent
        text: Time.data ?? ""
    }
}
