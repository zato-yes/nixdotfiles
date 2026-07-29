import QtQuick
import Quickshell
import Quickshell.Services.UPower
Item {
    id: root
    property color textColor: "red"
    property int fontSize: 16
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int spacing: 4
    readonly property UPowerDevice device: UPower.displayDevice
    readonly property real pct: device.percentage * 100
    readonly property bool charging: device.state === UPowerDeviceState.Charging
    readonly property string glyph: {
        if (!device.isLaptopBattery) return "󰇅"
        if (charging)  return ""
        if (pct >= 90) return "󰁹"
        if (pct >= 60) return "󰂁"
        if (pct >= 35) return "󰁿"
        if (pct >= 10) return "󰁺"
		return "󰂃"
				
    }
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    Row {
        id: row
        spacing: root.spacing
		Text {
			id: glyphText
            text: root.glyph
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            color: root.textColor
            anchors.baseline: percentText.baseline
  
        }
		Text {
         	 id: percentText
            text: Math.round(root.pct) + "%"
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            color: root.textColor
        }
    }
}


