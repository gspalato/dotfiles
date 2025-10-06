import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "root:/config"
import "root:/services"
import "root:/utils/colorUtils.js" as ColorUtils
import "root:/utils/iconUtils.js" as IconUtils

IconImage {
    id: root

    required property SystemTrayItem item
    property var window

    implicitSize: 16
    source: IconUtils.resolveSystemTrayIconPath(item.icon)
    QsMenuAnchor {
        id: menu

        menu: root.item.menu
        anchor.window: root.window
        anchor.edges: Edges.Top | Edges.Right
        //anchor.rect.width: menu.width
        //anchor.rect.height: menu.height

        anchor.onAnchoring: {
            let point = Panels.dashboard.mapFromItem(root, 0, 0);
            menu.anchor.rect.x = point.x + menu.width;
            menu.anchor.rect.y = point.y + 20;
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: event => {
            switch (event.button) {
            case Qt.LeftButton:
                item.activate();
                break;
            case Qt.RightButton:
                if (item.hasMenu)
                    menu.open();
                break;
            }
            event.accepted = true;
        }
    }

    Desaturate {
        id: desaturatedIcon
        visible: false // There's already color overlay
        anchors.fill: trayIcon
        source: trayIcon
        desaturation: 1 // 1.0 means fully grayscale
    }

    ColorOverlay {
        visible: false
        anchors.fill: desaturatedIcon
        source: desaturatedIcon
        color: ColorUtils.alpha(Appearance.material_colors.primary, .5)
    }
}
