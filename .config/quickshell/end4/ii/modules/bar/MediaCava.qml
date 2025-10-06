import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland
import Quickshell.Widgets

import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services

import "root:/shaders" as Shaders

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    readonly property string cleanedTitle: StringUtils.cleanMusicTitle(activePlayer?.trackTitle) || Translation.tr("No media")
    property real progress: activePlayer?.position / activePlayer?.length || 0

    Layout.fillHeight: true
    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: Appearance.sizes.barHeight

    property bool isHovered: false

    Timer {
        running: activePlayer?.playbackState == MprisPlaybackState.Playing
        interval: Config.options.resources.updateInterval
        repeat: true
        onTriggered: activePlayer.positionChanged()
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton | Qt.RightButton | Qt.LeftButton
        onPressed: (event) => {
            if (event.button === Qt.MiddleButton) {
                activePlayer.togglePlaying();
            } else if (event.button === Qt.BackButton) {
                activePlayer.previous();
            } else if (event.button === Qt.ForwardButton || event.button === Qt.RightButton) {
                activePlayer.next();
            } else if (event.button === Qt.LeftButton) {
                GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen
            }
        }
        
        onEntered: {
            isHovered = true;
            revealer.revealed =  true;
        }
        onExited: {
            isHovered = false;
            revealer.revealed = false;
        }
    }

    /*
    RowLayout { // Real content
        id: rowLayout

        spacing: 4
        anchors.fill: parent

        ClippedFilledCircularProgress {
            id: mediaCircProg
            Layout.alignment: Qt.AlignVCenter
            lineWidth: Appearance.rounding.unsharpen
            value: activePlayer?.position / activePlayer?.length
            implicitSize: 20
            colPrimary: Appearance.colors.colOnSecondaryContainer
            enableAnimation: false

            Item {
                anchors.centerIn: parent
                width: mediaCircProg.implicitSize
                height: mediaCircProg.implicitSize
                
                MaterialSymbol {
                    anchors.centerIn: parent
                    fill: 1
                    text: activePlayer?.isPlaying ? "pause" : "music_note"
                    iconSize: Appearance.font.pixelSize.normal
                    color: Appearance.m3colors.m3onSecondaryContainer
                }
            }
        }

        StyledText {
            visible: Config.options.bar.verbose
            width: rowLayout.width - (CircularProgress.size + rowLayout.spacing * 2)
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true // Ensures the text takes up available space
            Layout.rightMargin: rowLayout.spacing
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight // Truncates the text on the right
            color: Appearance.colors.colOnLayer1
            text: `${cleanedTitle}${activePlayer?.trackArtist ? ' • ' + activePlayer.trackArtist : ''}`
        }

    }
    */

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent

        spacing: 0

        height: parent.height
        //width: cavaCanvas.calculatedWidth + revealer.implicitWidth

        StyledRect {
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

                        source: activePlayer?.identity === "Spotify" ? "root:/assets/icons/spotify.svg" : ""
                    }

                    // Small padding so the progress isn't clipped.
                    Item {
                        Layout.leftMargin: 1
                        implicitHeight: 22
                        implicitWidth: 22

                        Layout.alignment: Qt.AlignVCenter

                        CircularProgress2 {
                            size: 26
                            primaryColor: Appearance.m3colors.m3primary
                            secondaryColor: '#22502d2d'

                            anchors.centerIn: parent

                            value: root.progress
                            //value: player.position / player.length || 0
                        }

                        MaterialSymbol {
                            anchors.centerIn: parent
                            fill: 1
                            text: activePlayer?.isPlaying ? "pause" : "music_note"
                            iconSize: Appearance.font.pixelSize.smaller
                            color: Appearance.m3colors.m3onSecondaryContainer
                        }

                        /*
                        IconImage {
                            visible: true
                            implicitSize: 18
                            mipmap: false

                            anchors.centerIn: parent

                            property string iconName: player?.isPlaying ? "media-pause2" : "media-play2"
                            source: "root:/assets/icons/" + iconName + ".svg"
                            //source: player.identity === "Spotify" ? "root:/assets/icons/spotify.svg" : ""
                        }*/
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignVCenter
                        text: cleanedTitle
                    }

                    // Discrete border
                    Separator {}
                }
            }
        }

        CavaSpectrum {
            id: cavaCanvas

            anchors.centerIn: null

            barHeight: 20

            opacity: activePlayer ? 1.0 : 0.5

            Shaders.LiquidGradient {
                source: cavaCanvas
                timeRunning: true

                layer.enabled: true
                layer.smooth: true 

                property color _color1: Appearance.m3colors.m3primary
                property color _color2: Appearance.m3colors.m3secondary
                property color _color3: Appearance.m3colors.m3tertiary
                property color _color4: Appearance.m3colors.m3background

                Behavior on _color1 {
                    ColorAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on _color2 {
                    ColorAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on _color3 {
                    ColorAnimation {
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on _color4 {
                    ColorAnimation {
                        duration: 500
                        easing.type: Easing.OutCubic
                    }
                }

                color1: Qt.vector3d(_color1.r, _color1.g, _color1.b)
                color2: Qt.vector3d(_color2.r, _color2.g, _color2.b)
                color3: Qt.vector3d(_color3.r, _color3.g, _color3.b)
                color4: Qt.vector3d(_color4.r, _color4.g, _color4.b)

                anchors.fill: parent
            }
        }
    }

}
