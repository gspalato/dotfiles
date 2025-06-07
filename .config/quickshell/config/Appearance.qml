pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "root:/utils/colorUtils.js" as ColorUtils

Singleton {
    id: root

    property var font: QtObject {
        property QtObject family: QtObject {
            property string main: "Gabarito"
            property string title: "Gabarito"
            property string display: "Unbounded"
            property string secondary: "Outfit"

            //property string iconMaterial: "Material Symbols Rounded"
            //property string iconNerd: "SpaceMono NF"
            //property string monospace: "JetBrains Mono NF"
            //property string reading: "Readex Pro"
        }

        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 14
            property int small: 15
            property int normal: 16
            property int large: 17
            property int larger: 19
            property int huge: 22
        }
    }

    property var material_colors: Matugen
    property var colors: QtObject {
        property color moduleColor: ColorUtils.alpha(root.material_colors.surface_container, .45)
        property color moduleBorder: ColorUtils.alpha(Qt.lighter(root.material_colors.surface_container, 1.75), .45)
    }

    property var rounding: QtObject {
        property int unsharpen: 2
        property int smaller: 8
        property int small: 15
        property int normal: 20
        property int large: 25
        property int larger: 30
        property int full: 9999
        property int screenRounding: large
        property int windowRounding: large
    }

    property var sizes: QtObject {
        property int moduleHeight: 40
        property int moduleHorizontalPadding: 30

        property int barTopMargin: 10
        property int barBottomMargin: 6
        property int barLeftMargin: 10
        property int barRightMargin: 10

        property int barHeight: moduleHeight
    }

    property var easings: QtObject {
        property var main: Easing.OutCubic
    }
}
