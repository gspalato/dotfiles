pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Qt.labs.folderlistmodel

import "root:/config"

/**
 * A migration of my "Wallnut" script to Quickshell.
 * It handles wallpaper applying and theme generation.
 */
Singleton {
    id: root

    property string selectedWallpaper

    property var wallpapersModel: FolderListModel {
        id: folderModel
        //nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
        showFiles: true
        showDirs: false
        folder: Qt.resolvedUrl(Config.wallpaperDirectory)
    }

    function apply(path) {
        console.log("Applying wallpaper:", path);

        // Remove the protocol from the path.
        if (path.startsWith("file://")) {
            path = path.substring(7);
        }

        root.selectedWallpaper = path;

        if (root.selectedWallpaper) {
            // Start the processes
            matugenProcess.running = true;
            wallustProcess.running = true;
            copyWallpaperProcess.running = true;
        } else {
            console.warn("No wallpaper selected");
        }
    }

    Process {
        id: matugenProcess
        running: false
        command: ["matugen", "image", root.selectedWallpaper]
    }

    Process {
        id: wallustProcess
        running: false
        command: ["wallust", "run", root.selectedWallpaper]
    }

    Process {
        id: copyWallpaperProcess
        running: false
        command: ["cp", root.selectedWallpaper, "~/.current.wall"]
    }
}
