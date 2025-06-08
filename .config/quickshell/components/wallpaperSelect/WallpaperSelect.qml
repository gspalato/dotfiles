import QtQuick
import QtQuick.Effects
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

Item {
    id: root
    property bool shown: false

    anchors.fill: parent

    function reveal() {
        if (root.shown)
            return;
        root.shown = true;
        selector.revealAnimation.start();
    }

    function hide() {
        if (!root.shown)
            return;
        root.shown = false;
        selector.hideAnimation.start();
    }

    Rectangle {
        id: selector

        opacity: root.shown ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutCubic
            }
        }

        visible: opacity > 0

        height: 120
        width: parent.width
        anchors.bottom: parent.bottom

        color: ColorUtils.alpha(Appearance.material_colors.surface_container, .8)
        clip: true

        antialiasing: true
        border.width: 1
        border.color: Qt.lighter(Appearance.material_colors.surface_container, 1.25)
        border.pixelAligned: true
        topLeftRadius: Appearance.rounding.windowRounding
        topRightRadius: Appearance.rounding.windowRounding

        layer.enabled: true
        layer.smooth: true
        layer.effect: MultiEffect {
            shadowVerticalOffset: 0
            shadowHorizontalOffset: 0
            shadowColor: "#000000"
            shadowEnabled: true
            shadowBlur: 1
        }

        property var revealAnimation: NumberAnimation {
            target: selector
            property: "y"
            from: selector.height
            to: 0
        }
        property var hideAnimation: NumberAnimation {
            target: selector
            property: "y"
            from: 0
            to: selector.height
        }

        property var fileModel: FolderListModel {
            id: folderModel
            //nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
            showFiles: true
            showDirs: false
            folder: Qt.resolvedUrl(Config.wallpaperDirectory)
        }

        Item {
            id: selectorKeyHandler
            anchors.fill: parent

            // Handle escape key to close the panel.
            Keys.enabled: true
            Keys.onEscapePressed: event => {
                console.log("esc pressed");

                root.hide();
                event.accepted = true;
            }
            Keys.onPressed: event => {
                console.log("key pressed:", event.key);
            }
            Component.onCompleted: selectorKeyHandler.forceActiveFocus()
        }

        ColumnLayout {
            id: padding
            anchors.fill: parent

            Rectangle {
                Layout.preferredHeight: listView.implicitHeight
                Layout.fillWidth: true
                Layout.leftMargin: Appearance.spacings.normal
                Layout.rightMargin: Appearance.spacings.normal

                color: "transparent"
                radius: Appearance.rounding.windowRounding
                clip: true

                Common.StyledText {
                    id: noWallpaperText
                    text: "No wallpaper found."
                    font.family: Appearance.font.family.display
                    font.pixelSize: Appearance.font.pixelSize.large
                    font.weight: 400
                    color: ColorUtils.alpha(Appearance.material_colors.on_surface, .3)
                    anchors.centerIn: parent

                    opacity: selector.fileModel.count > 0 ? 0 : 1
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                ListView {
                    id: listView
                    visible: true
                    orientation: ListView.Horizontal

                    anchors.verticalCenter: parent.verticalCenter

                    implicitHeight: 100
                    implicitWidth: parent.width

                    displayMarginBeginning: Appearance.spacings.normal
                    displayMarginEnd: Appearance.spacings.normal
                    keyNavigationEnabled: true

                    spacing: 10

                    model: selector.fileModel

                    delegate: Image {
                        id: wallpaperOption
                        required property string fileUrl

                        height: 100
                        width: height * 16 / 9
                        clip: false

                        sourceSize.width: width
                        sourceSize.height: height

                        cache: true

                        fillMode: Image.PreserveAspectCrop
                        mipmap: true

                        source: Qt.resolvedUrl(fileUrl)

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                id: wallpaperOptionMask
                                width: wallpaperOption.width
                                height: wallpaperOption.height
                                radius: 15
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
    }
}
