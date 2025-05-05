pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/**
 * A completely revised Revealer component that uses a different approach
 * for more reliable reveal animations in QtQuick.
 */
Item {
    id: root

    // API properties
    property bool revealed: false    // Controls whether content is shown/hidden
    property int duration: 200       // Animation duration in ms
    property int direction: Qt.LeftToRight  // Direction to reveal from
    property Item contentItem: null  // Content to be revealed
    
    // Internal properties
    property real _progress: revealed ? 1.0 : 0.0
    property bool _isHorizontal: direction === Qt.LeftToRight || direction === Qt.RightToLeft
    property bool _isForwardDirection: direction === Qt.LeftToRight || direction === Qt.TopToBottom
    
    // Set initial visibility
    visible: _progress > 0
    
    // Calculate the current size based on animation progress
    width: _isHorizontal ? contentSize.width * _progress : contentSize.width
    height: _isHorizontal ? contentSize.height : contentSize.height * _progress
    
    // Content size calculation helper
    QtObject {
        id: contentSize
        property real width: contentItem ? Math.max(contentItem.implicitWidth, contentItem.width, 1) : 1
        property real height: contentItem ? Math.max(contentItem.implicitHeight, contentItem.height, 1) : 1
    }
    
    // Animation for smooth transitions
    Behavior on _progress {
        NumberAnimation {
            duration: root.duration
            easing.type: Easing.OutCubic
        }
    }
    
    // Content wrapper - this is where the actual content lives
    Item {
        id: contentWrapper
        
        // Always match content size regardless of animation
        width: contentSize.width
        height: contentSize.height
        
        // Position based on direction and progress
        // This is what creates the sliding effect
        x: (_isHorizontal && !_isForwardDirection) ? (contentSize.width * (_progress - 1)) : 0
        y: (!_isHorizontal && !_isForwardDirection) ? (contentSize.height * (_progress - 1)) : 0
        
        // Clip content during animation
        clip: true
    }
    
    // Monitor content changes
    onContentItemChanged: {
        if (contentItem) {
            // Reparent the content
            contentItem.parent = contentWrapper
            
            // Reset any existing anchors
            contentItem.anchors.fill = undefined
            contentItem.anchors.left = undefined
            contentItem.anchors.right = undefined
            contentItem.anchors.top = undefined
            contentItem.anchors.bottom = undefined
            
            // Position at the origin of the content wrapper
            contentItem.x = 0
            contentItem.y = 0
            
            // Ensure visibility
            contentItem.visible = true
            contentItem.opacity = 1.0
        }
    }
    
    // Wait a moment after creation to ensure proper initial layout
    Component.onCompleted: {
        initTimer.start()
    }
    
    Timer {
        id: initTimer
        interval: 10
        repeat: false
        onTriggered: {
            if (contentItem) {
                // Force update size calculations
                contentItem.visible = true
                _progress = revealed ? 1.0 : 0.0
            }
        }
    }
}