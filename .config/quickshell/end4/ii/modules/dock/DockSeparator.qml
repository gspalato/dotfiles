import qs
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

StyledRect {
    Layout.topMargin: Appearance.sizes.elevationMargin + dockRow.padding + Appearance.rounding.normal
    Layout.bottomMargin: Appearance.sizes.hyprlandGapsOut + dockRow.padding + Appearance.rounding.normal
    Layout.fillHeight: true
    implicitWidth: 1
    color: Appearance.colors.colOutlineVariant
}
