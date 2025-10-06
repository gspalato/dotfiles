pragma Singleton
pragma ComponentBehavior: Bound

import Qt.labs.platform
import QtQuick
import Quickshell

Singleton {
    property string configPath: Quickshell.shellPath("config")
    property string shellConfigName: "config.json"
    property string shellConfigPath: `${Directories.configPath}/${Directories.shellConfigName}`
}