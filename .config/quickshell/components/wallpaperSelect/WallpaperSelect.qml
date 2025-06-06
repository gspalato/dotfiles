import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects

import "root:/config"
import "root:/services"
import "root:/utils/colorUtils.js" as ColorUtils

import "root:/components/common" as Common

Rectangle {
    id: root

    property real optionSize: 100

    property bool shown: false
    onShownChanged: {
        console.log("WallpaperSelect: shown changed to", shown);
        if (shown) {
            showAnimation.start();
        } else {
            hideAnimation.start();
        }
    }

    opacity: 1
    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutCubic
        }
    }

    visible: opacity > 0

    SequentialAnimation {
        id: hideAnimation
        NumberAnimation {
            target: root
            property: "y"
            from: 0
            to: -root.parent.height
            duration: 200
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: root
            property: "opacity"
            to: 0
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    SequentialAnimation {
        id: showAnimation
        NumberAnimation {
            target: root
            property: "y"
            from: -root.parent.height
            to: 0
            duration: 200
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: root
            property: "opacity"
            to: 1
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    height: layout.height
    width: layout.width
    anchors.centerIn: parent

    color: ColorUtils.alpha(Appearance.material_colors.surface_container, .8)
    clip: true

    antialiasing: true
    border.width: 1
    border.color: Qt.lighter(Appearance.material_colors.surface_container, 1.25)
    border.pixelAligned: true
    radius: Appearance.rounding.windowRounding

    layer.enabled: true
    layer.smooth: true

    /*
    property var fileModel: FolderListModel {
        id: folderModel
        //nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
        showFiles: true
        showDirs: false
        folder: Config.wallpaperDirectory
    }
    */

    property var fileModel: ListModel {
        id: fruitModel

        ListElement {
            fileUrl: "/home/spxlato/Pictures/Wallpapers/a_gas_station_with_purple_lights.jpg"
        }
        ListElement {
            fileUrl: "/home/spxlato/Pictures/Wallpapers/p15.png"
        }
        ListElement {
            fileUrl: "/home/spxlato/Pictures/Wallpapers/cyberskull.png"
        }
    }

    Common.StyledText {
        id: title
        text: "No wallpaper found."
        font.family: Appearance.font.family.display
        font.pixelSize: Appearance.font.pixelSize.large
        font.weight: 400
        color: ColorUtils.alpha(Appearance.material_colors.on_surface, .3)
        anchors.centerIn: parent

        opacity: fileModel.count > 0 ? 0 : 1
        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }

    RowLayout {
        id: layout

        opacity: fileModel.count > 0 ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        ListView {
            id: listView
            orientation: ListView.Horizontal

            implicitHeight: root.optionSize
            implicitWidth: contentWidth

            Layout.preferredHeight: root.optionSize
            Layout.minimumWidth: 3 * root.optionSize + 2 * listView.spacing
            Layout.maximumWidth: 8 * root.optionSize + 7 * listView.spacing
            Layout.margins: 10

            spacing: 10

            model: root.fileModel

            delegate: Image {
                id: wallpaperOption
                required property string fileUrl

                height: root.optionSize
                width: root.optionSize
                clip: true

                fillMode: Image.PreserveAspectCrop
                mipmap: true

                source: Qt.resolvedUrl(fileUrl)

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        id: wallpaperOptionMask
                        width: wallpaperOption.height
                        height: wallpaperOption.width
                        radius: root.radius
                        visible: false
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        Wallnut.apply(fileUrl);
                        root.shown = false;
                    }
                }
            }
        }
    }
}
