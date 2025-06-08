pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower

Singleton {
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge || !UPower.onBattery
    property real percentage: UPower.displayDevice.percentage

    property bool isLow: percentage <= 20 / 100
    property bool isCritical: percentage <= 10 / 100
    //property bool isSuspending: percentage <= ConfigOptions.battery.suspend / 100

    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging

    onIsLowAndNotChargingChanged: {
        if (available && isLowAndNotCharging) {}
    }

    onIsCriticalAndNotChargingChanged: {
        if (available && isCriticalAndNotCharging) {}
    }
}
