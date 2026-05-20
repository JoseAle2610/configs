import QtQuick
import qs.Common
import qs.Modules.Plugins
import qs.Widgets

PluginSettings {
    id: root
    pluginId: "corsairBattery"

    StyledText {
        width: parent.width
        text: "Corsair Battery Settings"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "Display battery level of your Corsair headset via headsetcontrol"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    ToggleSetting {
        settingKey: "showIcon"
        label: "Show Icon"
        description: "Display battery icon in the widget"
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showPercentage"
        label: "Show Percentage"
        description: "Display battery percentage text"
        defaultValue: true
    }

    SliderSetting {
        settingKey: "updateInterval"
        label: "Update Interval"
        description: "How often to refresh battery level"
        defaultValue: 60
        minimum: 10
        maximum: 300
        unit: "sec"
    }
}
