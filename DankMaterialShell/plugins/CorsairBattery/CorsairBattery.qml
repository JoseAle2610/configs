import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property int batteryLevel: pluginData.batteryLevel ?? -1
    property string batteryStatus: pluginData.batteryStatus ?? "unknown"
    property bool showPercentage: pluginData.showPercentage !== undefined ? pluginData.showPercentage : true
    property bool showIcon: pluginData.showIcon !== undefined ? pluginData.showIcon : true
    property int updateInterval: pluginData.updateInterval ?? 60

    property string batteryIcon: {
        if (root.batteryLevel < 0) return "battery_unknown"
        if (root.batteryLevel >= 90) return "battery_full"
        if (root.batteryLevel >= 70) return "battery_6_bar"
        if (root.batteryLevel >= 50) return "battery_5_bar"
        if (root.batteryLevel >= 30) return "battery_3_bar"
        if (root.batteryLevel >= 20) return "battery_2_bar"
        if (root.batteryLevel >= 10) return "battery_1_bar"
        return "battery_alert"
    }

    property color batteryColor: {
        if (root.batteryLevel < 0) return Theme.surfaceVariantText
        if (root.batteryLevel <= 20) return Theme.error
        if (root.batteryLevel <= 50) return Theme.warning
        return Theme.primary
    }

    property string _stdoutBuffer: ""
    property string _stderrBuffer: ""

    property string _stdoutBuffer: ""
    property string _stderrBuffer: ""

    Process {
        id: batteryProcess
        command: ["headsetcontrol", "-o", "json"]

        stdout: SplitParser {
            onRead: line => {
                root._stdoutBuffer += line + "\n"
            }
        }

        stderr: SplitParser {
            onRead: line => {
                root._stderrBuffer += line + "\n"
            }
        }

        onExited: (exitCode) => {
            if (exitCode === 0 && root._stdoutBuffer.trim().length > 0) {
                try {
                    var json = JSON.parse(root._stdoutBuffer)
                    var devices = json.devices || json.device_count !== undefined ? json.devices : null
                    if (devices && devices.length > 0) {
                        var device = devices[0]
                        if (device.battery && device.battery.status === "BATTERY_AVAILABLE") {
                            root.batteryLevel = device.battery.level
                            root.batteryStatus = device.battery.status
                            if (pluginService) {
                                pluginService.savePluginData(pluginId, "batteryLevel", root.batteryLevel)
                                pluginService.savePluginData(pluginId, "batteryStatus", root.batteryStatus)
                            }
                        }
                    }
                } catch (e) {
                    console.error("CorsairBattery: Failed to parse headsetcontrol output:", e)
                    console.error("CorsairBattery: Raw output:", root._stdoutBuffer)
                }
            } else if (exitCode !== 0) {
                console.error("CorsairBattery: headsetcontrol exited with code:", exitCode)
                if (root._stderrBuffer.trim().length > 0) {
                    console.error("CorsairBattery: stderr:", root._stderrBuffer)
                }
            }
            root._stdoutBuffer = ""
            root._stderrBuffer = ""
        }
    }
        }

        stderr: SplitParser {
            onRead: line => {
                root._stderrBuffer += line + "\n"
            }
        }

        onExited: (exitCode) => {
            if (exitCode === 0 && root._stdoutBuffer.trim().length > 0) {
                try {
                    var json = JSON.parse(root._stdoutBuffer)
                    var devices = json.devices || json.device_count !== undefined ? json.devices : null
                    if (devices && devices.length > 0) {
                        var device = devices[0]
                        if (device.battery && device.battery.status === "BATTERY_AVAILABLE") {
                            root.batteryLevel = device.battery.level
                            root.batteryStatus = device.battery.status
                            if (pluginService) {
                                pluginService.savePluginData(pluginId, "batteryLevel", root.batteryLevel)
                                pluginService.savePluginData(pluginId, "batteryStatus", root.batteryStatus)
                            }
                        }
                    }
                } catch (e) {
                    console.error("CorsairBattery: Failed to parse headsetcontrol output:", e)
                    console.error("CorsairBattery: Raw output:", root._stdoutBuffer)
                }
            } else if (exitCode !== 0) {
                console.error("CorsairBattery: headsetcontrol exited with code:", exitCode)
                if (root._stderrBuffer.trim().length > 0) {
                    console.error("CorsairBattery: stderr:", root._stderrBuffer)
                }
            }
            root._stdoutBuffer = ""
            root._stderrBuffer = ""
        }
    }

    Timer {
        id: refreshTimer
        interval: root.updateInterval * 1000
        running: true
        repeat: true
        onTriggered: {
            batteryProcess.running = false
            batteryProcess.running = true
        }
    }

    Component.onCompleted: {
        batteryProcess.running = true
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingS

            DankIcon {
                visible: root.showIcon
                name: root.batteryIcon
                size: Theme.iconSize
                color: root.batteryColor
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                visible: root.showPercentage
                text: root.batteryLevel >= 0 ? root.batteryLevel + "%" : "N/A"
                font.pixelSize: Theme.fontSizeMedium
                color: root.batteryColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                visible: root.showIcon
                name: root.batteryIcon
                size: Theme.iconSize
                color: root.batteryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                visible: root.showPercentage
                text: root.batteryLevel >= 0 ? root.batteryLevel + "%" : "N/A"
                font.pixelSize: Theme.fontSizeSmall
                color: root.batteryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
