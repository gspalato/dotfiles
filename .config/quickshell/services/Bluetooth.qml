pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

/**
* Basic polled Bluetooth state.
*/
Singleton {
    id: root

    property int updateInterval: 1000

    property string bluetoothDeviceName: ""
    property string bluetoothDeviceAddress: ""

    property bool enabled: false
    property bool connected: false

    property var availableDevices: []

    property string iconName: enabled ? (connected ? "bluetooth-connected" : "bluetooth-on") : "bluetooth-off"

    function update() {
        updateBluetoothDevice.running = true;
        updateBluetoothStatus.running = true;
        updateBluetoothEnabled.running = true;
        updateBluetoothList.running = true;
    }

    function enable() {
        enableBluetooth.running = true;
    }

    function disable() {
        disableBluetooth.running = true;
    }

    function refreshDevices() {
        updateBluetoothList.running = true;
    }

    Timer {
        interval: 10
        running: true
        repeat: true
        onTriggered: {
            update();
            interval = root.updateInterval;
        }
    }

    Process {
        id: updateBluetoothList
        command: ["sh", "-c", `
        bluetoothctl devices | grep '^Device' | while read -r _ mac name_rest; do
            name="$name_rest"
            info=$(bluetoothctl info "$mac")
            in_use=$(echo "$info" | grep -q "Connected: yes" && echo "*" || echo "")
            rssi=$(echo "$info" | awk '/RSSI:/ {print $2}')
            echo "\${name}:\${rssi:--1}:\${in_use}"
        done
        `]
        stdout: SplitParser {
            onRead: data => {
                const devices = data.trim().split('\n').map(line => {
                    const parts = line.split(':');
                    return {
                        name: parts[0],
                        strength: parseInt(parts[1]),
                        connected: parts[2] === '*'
                    };
                });
                root.availableDevices = devices;
            }
        }
    }

    Process {
        id: enableBluetooth
        command: ["sh", "-c", "bluetoothctl power on"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.enabled = true;
            } else {
                console.error("Failed to enable bluetooth:", exitCode, exitStatus);
            }
        }
    }

    Process {
        id: disableBluetooth
        command: ["sh", "-c", "bluetoothctl power off"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.enabled = false;
            } else {
                console.error("Failed to disable bluetooth:", exitCode, exitStatus);
            }
        }
    }

    // Check if Bluetooth is enabled (controller powered on)
    Process {
        id: updateBluetoothEnabled
        command: ["sh", "-c", "bluetoothctl show | grep -q 'Powered: yes' && echo 1 || echo 0"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.enabled = (parseInt(data) === 1);
            }
        }
    }

    // Get the name and address of the first connected Bluetooth device
    Process {
        id: updateBluetoothDevice
        command: ["sh", "-c", "bluetoothctl info | awk -F': ' '/Name: /{name=$2} /Device /{addr=$2} END{print name \":\" addr}'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let parts = data.split(":");
                root.bluetoothDeviceName = parts[0] || "";
                root.bluetoothDeviceAddress = parts[1] || "";
            }
        }
    }

    // Check if any device is connected
    Process {
        id: updateBluetoothStatus
        command: ["sh", "-c", "bluetoothctl info | grep -q 'Connected: yes' && echo 1 || echo 0"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.connected = (parseInt(data) === 1);
            }
        }
    }
}
