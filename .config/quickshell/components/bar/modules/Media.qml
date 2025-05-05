pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "../../shared" as Shared
import "../../media" as Media

import "../../../config"
import "../../../data"
import "../../../utils/utils.js" as Utils

// Container
Shared.BarModule {
    id: root
    clip: true

    implicitWidth: layout.implicitWidth + Theme.modulePadding[1]
    
    property bool isHovered: false
    property var player: {
        const player = Mpris.players.values.find(p => p.identity === "spotify") || Mpris.players.values[0]
        if (!player) {
            console.log("no player found.")
            return
        }

        console.log(player.identity)
        return player
    }

    // On song change, briefly show the title.
    Connections {
        target: player
        function onPostTrackChanged() {
            revealer.revealed = true
            titleDisplayCounter.running = true
        }
    }
    Timer {
        id: titleDisplayCounter
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            revealer.revealed = !isHovered && false
        }
    }

    // Hover handling
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            isHovered = true
            revealer.revealed = true
        }
        onExited: {
            isHovered = false
            revealer.revealed = false
        }
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent

        spacing: 0

        height: parent.height
        width: cavaCanvas.calculatedWidth + revealer.implicitWidth

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

                Row {
                    id: titleRow
                    height: parent.height
                    spacing: 10

                    /*
                    IconImage {
                        implicitSize: 12
                        mipmap: true

                        source: "/usr/share/icons/hicolor/64x64/apps/spotify.png"
                    }
                    */

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: player.trackTitle ? Utils.truncateString(player.trackTitle, 25) : "Unknown song"

                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.defaultFontSize
                        font.weight: Theme.defaultFontWeight

                        color: Theme.foreground
                    }

                    // Discrete border
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter

                        color: Qt.rgba(255, 255, 255, .15)
                        height: .5 * parent.height
                        width: 1
                    }
                }
            }
        }

        Shared.CavaSpectrum {
            id: cavaCanvas

            anchors.centerIn: null
            Layout.fillHeight: true

            opacity: player ? 1.0 : 0.5
        }
    }
}