import QtQuick

/**
 * A helper component to manage the content being revealed.
 * This separates the content management from the reveal animation logic.
 */
Item {
    id: root
    
    // The actual content to be shown/hidden
    property Item contentItem
    
    // Size is based on content's size
    implicitWidth: contentItem ? contentItem.implicitWidth || contentItem.width : 0
    implicitHeight: contentItem ? contentItem.implicitHeight || contentItem.height : 0
    
    // Update parent when content changes
    onContentItemChanged: {
        if (contentItem) {
            contentItem.parent = root
            contentItem.anchors.fill = root
        }
    }
}
