import QtQuick
import QtQuick.Layouts

import "root:/config"

Text {
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter

    font {
        hintingPreference: Font.PreferFullHinting
        family: Appearance.font.family.main
        pixelSize: Appearance.font.pixelSize.normal
        weight: 500
    }

    color: Appearance.material_colors.on_surface ?? "#ffffff"
}
