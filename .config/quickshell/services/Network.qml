pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

/**
* Simple polled network state service.
*/
Singleton {
    id: root

    property bool enabled: false
    property bool wifi: true
    property bool ethernet: false

    property int updateInterval: 1000

    property string networkName: ""
    property int networkStrength
    property var availableNetworks: []

    property string iconName: ethernet ? "network-wired" : (Network.networkName.length > 0 && Network.networkName != "lo") ? (Network.networkStrength > 80 ? "wifi_4" : Network.networkStrength > 60 ? "wifi_3" : Network.networkStrength > 40 ? "wifi_2" : Network.networkStrength > 20 ? "wifi_1" : "wifi_0") : "wifi_off"
    function getIconNameForStrength(strength) {
        if (strength > 80)
            return "wifi_4";
        else if (strength > 60)
            return "wifi_3";
        else if (strength > 40)
            return "wifi_2";
        else if (strength > 20)
            return "wifi_1";
        else
            return "wifi_0";
    }

    function update() {
        updateConnectionType.startCheck();
        updateNetworkName.running = true;
        updateNetworkStrength.running = true;
        updateNetworkEnabled.running = true;
        updateAvailableNetworks.running = true;
    }

    function enableWifi() {
        enableNetwork.running = true;
    }

    function disableWifi() {
        disableNetwork.running = true;
    }

    function refreshNetworks() {
        updateAvailableNetworks.running = true;
    }

    function connectToNetwork(ssid, pwd) {
    }

    Timer {
        interval: 10
        running: true
        repeat: true
        onTriggered: {
            root.update();
            interval = root.updateInterval;
        }
    }

    Process {
        id: updateAvailableNetworks
        command: ["sh", "-c", "nmcli -t -f SSID,SIGNAL,IN-USE dev wifi"]
        stdout: SplitParser {
            onRead: data => {
                const networks = data.trim().split('\n').map(line => {
                    const parts = line.split(':');
                    return {
                        ssid: parts[0],
                        strength: parseInt(parts[1]),
                        connected: parts[2] === '*'
                    };
                });
                root.availableNetworks = networks;
            }
        }
    }

    Process {
        id: updateNetworkEnabled
        command: ["sh", "-c", "nmcli radio wifi"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.enabled = data.trim() === "enabled";
            }
        }
    }
    Process {
        id: enableNetwork
        command: ["sh", "-c", "nmcli radio wifi on"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.enabled = true;
            } else {
                console.error("Failed to enable network:", exitCode, exitStatus);
            }
        }
    }
    Process {
        id: disableNetwork
        command: ["sh", "-c", "nmcli radio wifi off"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.enabled = false;
            } else {
                console.error("Failed to disable network:", exitCode, exitStatus);
            }
        }
    }

    Process {
        id: updateConnectionType
        property string buffer
        command: ["sh", "-c", "nmcli -t -f NAME,TYPE,DEVICE c show --active"]
        running: true
        function startCheck() {
            buffer = "";
            updateConnectionType.running = true;
        }
        stdout: SplitParser {
            onRead: data => {
                updateConnectionType.buffer += data + "\n";
            }
        }
        onExited: (exitCode, exitStatus) => {
            const lines = updateConnectionType.buffer.trim().split('\n');
            let hasEthernet = false;
            let hasWifi = false;
            lines.forEach(line => {
                if (line.includes("ethernet"))
                    hasEthernet = true;
                else if (line.includes("wireless"))
                    hasWifi = true;
            });
            root.ethernet = hasEthernet;
            root.wifi = hasWifi;
        }
    }

    Process {
        id: updateNetworkName
        command: ["sh", "-c", "nmcli -t -f NAME c show --active | head -1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.networkName = data;
            }
        }
    }

    Process {
        id: updateNetworkStrength
        running: true
        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}'"]
        stdout: SplitParser {
            onRead: data => {
                root.networkStrength = parseInt(data);
            }
        }
    }
}
