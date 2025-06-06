pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "root:/components/common" as Common
import "root:/components/media" as Media
import "root:/components/bar"

import "root:/shaders" as Shaders

import "root:/config"
import "root:/services"
import "root:/utils/utils.js" as Utils

// Container
Common.BarModule {
    id: root

    required property PanelWindow bar

    implicitWidth: layout.implicitWidth + Appearance.sizes.moduleHorizontalPadding

    property bool isHovered: false
    property bool isPressed: false
    property bool isMediaControlsToggled: false

    property real progress: player?.position / player?.length || 0

    property var player: MprisController.activePlayer

    // On song change, briefly show the title.
    Connections {
        target: player
        function onPostTrackChanged() {
            revealer.revealed = true;
            titleDisplayCounter.running = true;
        }
    }

    Timer {
        id: titleDisplayCounter
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            revealer.revealed = !isHovered && false;
        }
    }

    // Hover handling
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            isHovered = true;
            revealer.revealed = player && true;
        }
        onExited: {
            isHovered = false;
            revealer.revealed = false;
        }
        onPressed: {
            isPressed = true;
        }
        onReleased: {
            isPressed = false;
        }
        onClicked: {
            isMediaControlsToggled = !isMediaControlsToggled;
            console.log('toggled');
        }
    }

    // Set color based on hover/press state.
    color: Qt.lighter(Appearance.colors.moduleColor, isPressed ? 2.5 : (isHovered ? 1.75 : 0))
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent

        spacing: 0

        height: parent.height
        //width: cavaCanvas.calculatedWidth + revealer.implicitWidth

        Rectangle {
            id: revealer
            clip: true

            property bool revealed: false

            height: parent.height

            Binding {
                revealer.opacity: revealer.revealed ? 1 : 0
                revealer.implicitWidth: revealer.revealed ? revealedContent.implicitWidth : 0
            }

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }

            color: "transparent"

            // Revealed content (i don't know why it flickers when animating)
            Item {
                id: revealedContent
                implicitWidth: titleRow.implicitWidth + 10

                height: parent.height
                anchors.right: parent.right

                RowLayout {
                    id: titleRow
                    height: parent.height
                    spacing: 10

                    IconImage {
                        visible: false
                        implicitSize: 16
                        mipmap: true

                        Layout.alignment: Qt.AlignVCenter

                        source: player.identity === "Spotify" ? "root:/assets/icons/spotify.svg" : ""
                    }

                    // Small padding so the progress isn't clipped.
                    Item {
                        Layout.leftMargin: 1
                        implicitHeight: 22
                        implicitWidth: 22

                        Layout.alignment: Qt.AlignVCenter

                        Common.CircularProgress {
                            size: 26
                            primaryColor: Matugen.primary
                            secondaryColor: "#22ffffff"

                            anchors.centerIn: parent

                            value: root.progress
                            //value: player.position / player.length || 0
                        }

                        IconImage {
                            visible: true
                            implicitSize: 18
                            mipmap: false

                            anchors.centerIn: parent

                            property string iconName: player.isPlaying ? "media-pause2" : "media-play2"
                            source: "root:/assets/icons/" + iconName + ".svg"
                            //source: player.identity === "Spotify" ? "root:/assets/icons/spotify.svg" : ""
                        }
                    }

                    Common.StyledText {
                        Layout.alignment: Qt.AlignVCenter
                        text: player.trackTitle ? Utils.truncateString(player.trackTitle, 25) : "Unknown song"
                    }

                    // Discrete border
                    Common.Separator {}
                }
            }
        }

        Common.CavaSpectrum {
            id: cavaCanvas

            anchors.centerIn: null

            opacity: player ? 1.0 : 0.5

            Shaders.MaskedGradientSwirl {
                source: cavaCanvas
                timeRunning: true

                property color _color1: Appearance.material_colors.primary
                property color _color2: Appearance.material_colors.secondary
                property color _color3: Appearance.material_colors.tertiary
                property color _color4: Appearance.material_colors.source_color

                color1: Qt.vector3d(_color1.r, _color1.g, _color1.b)
                color2: Qt.vector3d(_color2.r, _color2.g, _color2.b)
                color3: Qt.vector3d(_color3.r, _color3.g, _color3.b)
                color4: Qt.vector3d(_color4.r, _color4.g, _color4.b)

                anchors.fill: parent
            }
        }
    }
}
