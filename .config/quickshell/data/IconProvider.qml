pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.platform
import QtQuick.Controls

Singleton {
    id: root

    // Standard icon search paths on different platforms
    readonly property var iconPaths: {
        if (Qt.platform.os === "linux") {
            return [
                "/usr/share/icons/",
                "/usr/local/share/icons/",
                "~/.local/share/icons/",
                "/usr/share/pixmaps/"
            ];
        } else if (Qt.platform.os === "windows") {
            return [
                "C:/Program Files/",
                "C:/Program Files (x86)/",
                "C:/Windows/System32/"
            ];
        } else if (Qt.platform.os === "osx") {
            return [
                "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/",
                "/Applications/",
                "/System/Applications/",
                "~/Applications/"
            ];
        }
        return [];
    }

    // Standard icon themes on Linux
    readonly property var iconThemes: [
        "hicolor",
        "Adwaita",
        "breeze",
        "oxygen",
        "Papirus",
        "elementary"
    ]

    // Icon types/categories
    readonly property var iconTypes: [
        "apps",
        "actions",
        "devices",
        "emblems",
        "emotes",
        "mimetypes",
        "places",
        "status",
        "categories"
    ]

    // Standard icon sizes
    readonly property var iconSizes: [
        "16x16",
        "22x22",
        "24x24",
        "32x32",
        "48x48",
        "64x64",
        "96x96",
        "128x128",
        "256x256",
        "512x512"
    ]

    /**
     * Find a program icon by name
     * @param {string} iconName - The name of the icon to find (without extension)
     * @param {int} preferredSize - Preferred icon size (default: 48)
     * @param {string} preferredTheme - Preferred icon theme (default: first available)
     * @return {string} Full path to the icon or empty string if not found
     */
    function findProgramIcon(iconName, preferredSize = 48, preferredTheme = "") {
        // Try to find exact match first
        let iconPath = findExactIcon(iconName, preferredSize, preferredTheme, "apps");
        if (iconPath) return iconPath;

        // Try with common extensions
        const extensions = [".png", ".svg", ".xpm", ".ico", ".jpg", ".jpeg"];
        
        // Try with common locations and extensions
        for (const path of iconPaths) {
            // Direct match in path
            for (const ext of extensions) {
                iconPath = path + iconName + ext;
                if (fileExists(iconPath)) return iconPath;
            }
            
            // On Linux, try standard theme locations
            if (Qt.platform.os === "linux") {
                // Try with preferred theme first
                if (preferredTheme) {
                    iconPath = searchLinuxTheme(path, preferredTheme, iconName, preferredSize, "apps");
                    if (iconPath) return iconPath;
                }
                
                // Try all themes
                for (const theme of iconThemes) {
                    if (theme === preferredTheme) continue; // Already checked
                    iconPath = searchLinuxTheme(path, theme, iconName, preferredSize, "apps");
                    if (iconPath) return iconPath;
                }
            }
        }
        
        return ""; // Not found
    }

    /**
     * Find a symbolic icon by name (mostly used in UI controls)
     * @param {string} iconName - The name of the symbolic icon
     * @param {int} preferredSize - Preferred icon size (default: 16)
     * @param {string} preferredTheme - Preferred icon theme (default: first available)
     * @param {string} iconType - Type of icon (actions, status, etc.)
     * @return {string} Full path to the icon or empty string if not found
     */
    function findSymbolicIcon(iconName, preferredSize = 16, preferredTheme = "", iconType = "actions") {
        // For symbolic icons, try with -symbolic suffix first
        let iconPath = findExactIcon(iconName + "-symbolic", preferredSize, preferredTheme, iconType);
        if (iconPath) return iconPath;
        
        // Try without -symbolic suffix
        iconPath = findExactIcon(iconName, preferredSize, preferredTheme, iconType);
        if (iconPath) return iconPath;
        
        // Try all icon types if specific type not found
        if (iconType !== "all") {
            for (const type of iconTypes) {
                if (type === iconType) continue; // Already checked
                iconPath = findExactIcon(iconName + "-symbolic", preferredSize, preferredTheme, type);
                if (iconPath) return iconPath;
                
                iconPath = findExactIcon(iconName, preferredSize, preferredTheme, type);
                if (iconPath) return iconPath;
            }
        }
        
        return ""; // Not found
    }

    /**
     * Find exact icon in theme directory structure
     * @private
     */
    function findExactIcon(iconName, preferredSize, preferredTheme, iconType) {
        if (Qt.platform.os !== "linux") return ""; // This exact search is mainly for Linux
        
        // Find nearest size directory
        const targetSize = findNearestSize(preferredSize);
        const extensions = [".svg", ".png", ".xpm"];
        
        for (const path of iconPaths) {
            // Try with preferred theme first
            if (preferredTheme) {
                const themePath = path + preferredTheme + "/";
                
                // Check exact size
                let iconPath = themePath + targetSize + "/" + iconType + "/" + iconName;
                for (const ext of extensions) {
                    if (fileExists(iconPath + ext)) return iconPath + ext;
                }
                
                // Check scalable directory
                iconPath = themePath + "scalable/" + iconType + "/" + iconName;
                for (const ext of extensions) {
                    if (fileExists(iconPath + ext)) return iconPath + ext;
                }
            }
            
            // Try all themes
            for (const theme of iconThemes) {
                if (theme === preferredTheme) continue; // Already checked
                
                const themePath = path + theme + "/";
                
                // Check exact size
                let iconPath = themePath + targetSize + "/" + iconType + "/" + iconName;
                for (const ext of extensions) {
                    if (fileExists(iconPath + ext)) return iconPath + ext;
                }
                
                // Check scalable directory
                iconPath = themePath + "scalable/" + iconType + "/" + iconName;
                for (const ext of extensions) {
                    if (fileExists(iconPath + ext)) return iconPath + ext;
                }
            }
        }
        
        return "";
    }

    /**
     * Find the nearest standard size to the requested size
     * @private
     */
    function findNearestSize(size) {
        // First try exact match
        if (iconSizes.includes(size + "x" + size)) {
            return size + "x" + size;
        }
        
        // Find closest size
        let closest = iconSizes[0];
        let diff = Math.abs(parseInt(closest.split("x")[0]) - size);
        
        for (const sizeStr of iconSizes) {
            const currentSize = parseInt(sizeStr.split("x")[0]);
            const currentDiff = Math.abs(currentSize - size);
            
            if (currentDiff < diff) {
                closest = sizeStr;
                diff = currentDiff;
            }
        }
        
        return closest;
    }

    /**
     * Search for icon in Linux theme directories
     * @private
     */
    function searchLinuxTheme(basePath, theme, iconName, size, iconType) {
        const themePath = basePath + theme + "/";
        const sizeStr = findNearestSize(size);
        const extensions = [".svg", ".png", ".xpm"];
        
        // Check in specific size directory
        let iconPath = themePath + sizeStr + "/" + iconType + "/" + iconName;
        for (const ext of extensions) {
            if (fileExists(iconPath + ext)) return iconPath + ext;
        }
        
        // Check in scalable directory
        iconPath = themePath + "scalable/" + iconType + "/" + iconName;
        for (const ext of extensions) {
            if (fileExists(iconPath + ext)) return iconPath + ext;
        }
        
        return "";
    }

    /**
     * Check if a file exists at the given path
     * @private
     */
    function fileExists(filePath) {
        // Use Qt.resolvedUrl to handle relative paths
        // Not actually checking if the file exists for now.
        const url = Qt.resolvedUrl(filePath);

        return url
    }

    /**
     * List all available icons of a specific type
     * @param {string} iconType - Type of icons to list (apps, actions, etc.)
     * @param {string} theme - Icon theme to search in (default: first available)
     * @return {array} List of icon names found
     */
    function listAvailableIcons(iconType = "apps", theme = "") {
        const result = [];
        const checkedPaths = {};
        
        // Process theme-specific directories for Linux
        if (Qt.platform.os === "linux") {
            for (const path of iconPaths) {
                const themesToCheck = theme ? [theme] : iconThemes;
                
                for (const currentTheme of themesToCheck) {
                    for (const size of iconSizes) {
                        const dirPath = path + currentTheme + "/" + size + "/" + iconType + "/";
                        
                        // In real implementation, you would use directory listing functions here
                        // This is a placeholder for the concept
                        // listDirectoryContents(dirPath, result, checkedPaths);
                    }
                    
                    // Check scalable directory
                    const scalablePath = path + currentTheme + "/scalable/" + iconType + "/";
                    // listDirectoryContents(scalablePath, result, checkedPaths);
                }
            }
        }
        
        return result;
    }

    /**
     * Check if a specific icon exists
     * @param {string} iconName - Name of icon to check
     * @param {string} iconType - Type of icon (apps, actions, etc.)
     * @return {boolean} True if icon exists
     */
    function iconExists(iconName, iconType = "apps") {
        return findProgramIcon(iconName) !== "" || 
               findSymbolicIcon(iconName, 16, "", iconType) !== "";
    }

    /**
     * Get full icon URL that can be used in Image source
     * @param {string} iconName - Name of the icon
     * @param {boolean} isSymbolic - Whether to look for symbolic icon
     * @param {int} size - Desired icon size
     * @param {string} theme - Desired icon theme
     * @param {string} type - Icon type for symbolic icons
     * @return {url} URL that can be used in Image source
     */
    function getIconUrl(iconName, isSymbolic = false, size = 32, theme = "", type = "actions") {
        const path = isSymbolic 
            ? findSymbolicIcon(iconName, size, theme, type)
            : findProgramIcon(iconName, size, theme);
            
        return path ? Qt.resolvedUrl(path) : "";
    }
}