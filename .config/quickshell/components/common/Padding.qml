import QtQuick

Item {
    id: root

    property int leftPadding: 0
    property int rightPadding: 0
    property int topPadding: 0
    property int bottomPadding: 0

    // Let the user add any children inside this Item
    default property alias content: contentItem.data

    implicitHeight: {
        var maxBottom = 0;
        for (var i = 0; i < root.children.length; i++) {
            var child = root.children[i];
            if (child.visible) {
                var childBottom = child.y + child.height;
                if (childBottom > maxBottom)
                    maxBottom = childBottom;
            }
        }

        return maxBottom + root.topPadding + root.bottomPadding;
    }

    implicitWidth: {
        var maxRight = 0;
        for (var i = 0; i < root.children.length; i++) {
            var child = root.children[i];
            if (child.visible) {
                var childRight = child.x + child.width;
                if (childRight > maxRight)
                    maxRight = childRight;
            }
        }

        return maxRight + root.leftPadding + root.rightPadding;
    }

    // Internal item that applies padding
    Item {
        id: contentItem
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: root.topPadding
            bottomMargin: root.bottomPadding
            leftMargin: root.leftPadding
            rightMargin: root.rightPadding
        }
    }
}
