import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "root:/components/common" as Common
import "root:/config"

Common.MaterialRippleButton {
    Layout.fillHeight: true
    Layout.topMargin: Appearance.sizes.elevationMargin - Appearance.sizes.hyprlandGapsOut

    implicitWidth: implicitHeight - topInset - bottomInset

    buttonRadius: Appearance.rounding.normal

    background.implicitHeight: 50
}
