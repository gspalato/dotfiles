pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root
    property string filePath: "root:/config/Matugen.json"

    function reapplyTheme() {
        themeFileView.reload();
    }

    function applyColors(fileContent) {
        const json = JSON.parse(fileContent);
        for (const key in json) {
            if (json.hasOwnProperty(key)) {
                root[key] = json[key];
            }
        }
    }

    Timer {
        id: delayedFileRead
        interval: 100
        repeat: false
        running: false
        onTriggered: {
            root.applyColors(themeFileView.text());
        }
    }

    FileView {
        id: themeFileView
        path: Qt.resolvedUrl(root.filePath)
        watchChanges: true
        onFileChanged: {
            this.reload();
            delayedFileRead.start();
        }
        onLoadedChanged: {
            const fileContent = themeFileView.text();
            root.applyColors(fileContent);
        }
    }

    property color background
    property color error
    property color error_container
    property color inverse_on_surface
    property color inverse_primary
    property color inverse_surface
    property color on_background
    property color on_error
    property color on_error_container
    property color on_primary
    property color on_primary_container
    property color on_primary_fixed
    property color on_primary_fixed_variant
    property color on_secondary
    property color on_secondary_container
    property color on_secondary_fixed
    property color on_secondary_fixed_variant
    property color on_surface
    property color on_surface_variant
    property color on_tertiary
    property color on_tertiary_container
    property color on_tertiary_fixed
    property color on_tertiary_fixed_variant
    property color outline
    property color outline_variant
    property color primary
    property color primary_container
    property color primary_fixed
    property color primary_fixed_dim
    property color scrim
    property color secondary
    property color secondary_container
    property color secondary_fixed
    property color secondary_fixed_dim
    property color shadow
    property color source_color
    property color surface
    property color surface_bright
    property color surface_container
    property color surface_container_high
    property color surface_container_highest
    property color surface_container_low
    property color surface_container_lowest
    property color surface_dim
    property color surface_tint
    property color surface_variant
    property color tertiary
    property color tertiary_container
    property color tertiary_fixed
    property color tertiary_fixed_dim
}
