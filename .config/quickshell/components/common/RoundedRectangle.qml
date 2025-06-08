import Quickshell
import QtQuick

Canvas {
    id: root
    property color color: "#ffffff"
    property real squircleStrength: 0 // Rounding power (2.0 = circle, higher = more square-like)
    property real radius: 20 // Corner radius in pixels

    property real topLeftRadius: radius
    property real topRightRadius: radius
    property real bottomRightRadius: radius
    property real bottomLeftRadius: radius

    property color borderColor: "transparent"
    property real borderWidth: 0

    onPaint: {
        const ctx = getContext("2d");
        ctx.reset();
        ctx.clearRect(0, 0, width, height);

        const x = 0;
        const y = 0;
        const w = width;
        const h = height;
        const n = squircleStrength;

        // Draw fill
        ctx.beginPath();
        addSquirclePath(ctx, x, y, w, h, n);
        ctx.closePath();
        ctx.fillStyle = color;
        ctx.fill();

        // Draw border
        if (borderWidth > 0) {
            ctx.lineWidth = borderWidth;
            ctx.strokeStyle = borderColor;
            ctx.stroke();
        }
    }

    function addSquirclePath(ctx, x, y, w, h, n) {
        const hw = 0.5 * w;
        const hh = 0.5 * h;

        ctx.moveTo(x + hw, y); // top mid
        ctx.bezierCurveTo(x + hw * (1 - n), y, x, y + hh * (1 - n), x, y + hh);
        ctx.bezierCurveTo(x, y + hh + hh * n, x + hw * (1 - n), y + h, x + hw, y + h);
        ctx.bezierCurveTo(x + hw + hw * n, y + h, x + w, y + hh + hh * n, x + w, y + hh);
        ctx.bezierCurveTo(x + w, y + hh * (1 - n), x + hw + hw * n, y, x + hw, y);
    }

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onColorChanged: requestPaint()
    onRoundingChanged: requestPaint()
    onRadiusChanged: requestPaint()
    onBorderColorChanged: requestPaint()
    onBorderWidthChanged: requestPaint()
}
