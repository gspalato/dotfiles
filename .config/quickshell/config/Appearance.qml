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
        property int barBottomMargin: 10
        property int barLeftMargin: 10
        property int barRightMargin: 10

        property int barHeight: moduleHeight
    }

    property var spacings: QtObject {
        property int large: 15
        property int normal: 10
        property int small: 5
    }

    property var padding: QtObject {
        readonly property int small: 5
        readonly property int smaller: 7
        readonly property int normal: 10
        readonly property int larger: 12
        readonly property int large: 15
    }

    property var easings: QtObject {
        property var main: Easing.OutCubic
    }

    property var animation: QtObject {
        property var curves: QtObject {
            readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
            readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
            readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
            readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
            readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
            readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
            readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
            readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
            readonly property list<real> expressiveEffects: [0.34, 0.8, 0.34, 1, 1, 1]
        }
    }

    property var notification: QtObject {
        property var sizes: QtObject {
            readonly property int width: 400
            readonly property int image: 41
            readonly property int badge: 20
        }
    }
}
