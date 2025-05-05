import QtQuick
import QtQuick.Layouts

Rectangle {
    id: ws

    property bool hovered: false
    
    Layout.alignment: Qt.AlignHCenter
    radius: height / 2

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: () => {
            ws.hovered = true;
        }
        onExited: () => {
            ws.hovered = false;
        }
        onClicked: () => console.log(`workspace ?`)
    }
}