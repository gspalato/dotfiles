function truncateString(str, num) {
    if (str.length > num) {
        return str.slice(0, num) + "...";
    } else {
        return str;
    }
}

function colorAlpha(color, alpha) {
    return Qt.rgba(color.r, color.g, color.b, alpha);
}

/**
 * Runs a callback after a specified delay in milliseconds.
 *
 * This function creates a QML Timer object, connects the callback to the Timer's
 * triggered signal, and starts the Timer. After the Timer fires, the callback
 * is invoked and the Timer is destroyed.
 *
 * @param {number} ms - The delay in milliseconds
 * @param {function} callback - The function to be invoked after the delay
 */
function delay(ms, callback, root) {
    const timer = Qt.createQmlObject(`
        import QtQuick
        Timer { interval: ${ms}; repeat: false }
    `, root); // or parent or some other object in the tree

    timer.triggered.connect(function() {
        callback();
        timer.destroy(); // clean up
    });
    timer.start();
}