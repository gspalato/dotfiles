pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../config"

Canvas {
    id: cavaCanvas
    anchors.centerIn: parent

    implicitHeight: parent.implicitHeight
    implicitWidth: calculatedWidth
    
    property var values: []
    property int silenceCounter: 0
    property int silenceThreshold: 10
    property int bars: 15
    property real barHeight: 22
    property real barWidth: 3
    property real barMinHeight: 4
    property int padding: 5

    property real calculatedWidth: bars * barWidth + (bars - 1) * padding

    Process {
        id: proc
        command: ["sh", "-c", "cava -p ~/.config/quickshell/config/cava.toml"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                const values = data.split(';').map(v => parseFloat(v)/65530);
                cavaCanvas.values = values;
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

    FrameAnimation {
        running: true
        onTriggered: {
            cavaCanvas.requestAnimationFrame(() => cavaCanvas.onPaint(values))
        }
    }

    function onPaint(values) {
        const context = cavaCanvas.getContext('2d');
        const w = cavaCanvas.width;
        const h = cavaCanvas.height;
        const barW = barWidth ?? w / bars - padding;
        const barH = barHeight ?? h / 2;

        // Clear the canvas once before rendering
        context.clearRect(0, 0, w, h);
        
        context.fillStyle = 'white'; // White color for the bars

        // Silence control
        if (values[0] > 0) {
            silenceCounter = 0;
        } else {
            silenceCounter++;
        }
        
        const spectrum = silenceCounter > silenceThreshold ? new Array(bars).fill(0) : values;
        const centerY = h / 2;
        
        let startX = (w - (barWidth * bars + (bars - 1) * padding)) / 2;
        let dx = startX;

        // Optimize the bar rendering
        for (let i = 0; i < spectrum.length; i++) {
            const value = Math.min(spectrum[i], 1);
            let height = Math.max(value * barH, barMinHeight) / 2;
            height = Math.min(height, barH);
            
            const radius = barW / 2;
            
            const yTop = centerY - height;
            const yBottom = centerY + height;

            // Begin the path for each bar
            context.beginPath();
            
            // Top-left arc
            context.arc(dx + radius, yTop + radius, radius, Math.PI, 1.5 * Math.PI, false);
            
            // Top line
            context.lineTo(dx + barW - radius, yTop);
            
            // Top-right arc
            context.arc(dx + barW - radius, yTop + radius, radius, 1.5 * Math.PI, 0, false);
            
            // Right line
            context.lineTo(dx + barW, yBottom - radius);
            
            // Bottom-right arc
            context.arc(dx + barW - radius, yBottom - radius, radius, 0, 0.5 * Math.PI, false);
            
            // Bottom line
            context.lineTo(dx + radius, yBottom);
            
            // Bottom-left arc
            context.arc(dx + radius, yBottom - radius, radius, 0.5 * Math.PI, Math.PI, false);
            
            // Close the path for the current bar
            context.closePath();
            
            // Fill the bar
            context.fill();
            
            // Increment the x-position for the next bar
            dx += barWidth + padding;
        }
    }
}