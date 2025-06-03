pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    id: cavaShape
    implicitHeight: parent.implicitHeight
    implicitWidth: shapeRow.implicitWidth

    anchors.centerIn: parent

    color: "transparent"
    
    // Audio visualization properties
    property var values: []
    property int silenceCounter: 0
    property int silenceThreshold: 10
    property int bars: 20
    property real barHeight: 35
    property real barWidth: 2
    property real barMinHeight: 5
    property real padding: 3
    property real calculatedWidth: bars * barWidth + (bars - 1) * padding // Total width of all bars

    Process {
        id: proc
        command: ["sh", "-c", "cava -p ~/.config/quickshell/config/cava.toml"]
        running: true
        
        stdout: SplitParser {
            onRead: data => {
                const values = data.split(';').map(v => parseFloat(v)/1000); // Normalize the values
                cavaShape.values = values;
            }
        }
        
        stderr: SplitParser {
            onRead: err => {
                console.log(err);
            }
        }
        
        function onExited(code, status) {
            console.log("exited with code", code, "and status", status);
        }
    }

    RowLayout {
        id: shapeRow

        height: parent.height
        implicitHeight: parent.implicitHeight

        anchors.left: parent.left

        uniformCellSizes: false

        spacing: padding

        Repeater {
            id: barsRepeater
            model: bars
            
            Shape {
                id: barShape
                width: barWidth  // Fixed width for each bar

                required property int index
                
                // Position each bar horizontally with proper spacing
                x: index * (barWidth + padding)
                
                // Center the bar vertically relative to the parent shape
                y: (cavaShape.height - calculatedBarHeight) / 2
                
                // Dynamically calculate the height based on the value from 'values[index]'
                property real calculatedBarHeight: Math.min(Math.max(Math.min(values[index], 1) * barHeight, barMinHeight) / 2, barHeight);
                NumberAnimation on calculatedBarHeight {
                    easing.type: Easing.InOutQuad
                }
                
                // Rounded corner radius (optional, can be adjusted)
                property real r: barWidth / 2
                property real w: barWidth  // Fixed width
                property real h: calculatedBarHeight  // Dynamic height
                
                    ShapePath {
                        id: barPath
                        strokeWidth: 0
                        strokeColor: "transparent"
                        fillColor: "white"
                        
                        // Starting point for the pill shape
                        startX: 0
                        startY: 0
                        
                        // Define the pill shape with rounded corners
                        PathMove { x: r; y: 0 }
                        PathLine { x: w - r; y: 0 }
                        PathArc { x: w; y: r; radiusX: r; radiusY: r; direction: PathArc.Clockwise }
                        PathLine { x: w; y: h - r }
                        PathArc { x: w - r; y: h; radiusX: r; radiusY: r; direction: PathArc.Clockwise }
                        PathLine { x: r; y: h }
                        PathArc { x: 0; y: h - r; radiusX: r; radiusY: r; direction: PathArc.Clockwise }
                        PathLine { x: 0; y: r }
                        PathArc { x: r; y: 0; radiusX: r; radiusY: r; direction: PathArc.Clockwise }
                    }
            }
        }
    }
}