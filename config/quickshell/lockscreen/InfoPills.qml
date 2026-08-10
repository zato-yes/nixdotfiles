import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Item {
    id: root

    property real introState: 0.0
    property bool isPlayingIntro: true

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    property string fontFamily: "JetBrains Mono"
    property string iconFontFamily: "Iosevka Nerd Font"
    property color colText: "#cdd6f4"
    property color colOverlay2: "#9399b2"
    property color colSurface0: "#313244"
    property color colSurface1: "#45475a"
    property color colMauve: "#cba6f7"
    property color colBlue: "#89b4fa"
    property color colGreen: "#a6e3a1"
    property color colPeach: "#fab387"
    property color colRed: "#f38ba8"

    property string currentUser: "User"
    property string uptimeText: "--"

    Process {
        id: userPoller
        command: ["whoami"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.currentUser = this.text.trim()
        }
    }

    Process {
        id: uptimePoller
        command: ["cat", "/proc/uptime"]
        stdout: StdioCollector {
            onStreamFinished: {
                let seconds = parseFloat(this.text.trim().split(" ")[0])
                if (isNaN(seconds)) return
                let days = Math.floor(seconds / 86400)
                let hours = Math.floor((seconds % 86400) / 3600)
                let mins = Math.floor((seconds % 3600) / 60)
                let parts = []
                if (days > 0) parts.push(days + "d")
                if (hours > 0 || days > 0) parts.push(hours + "h")
                parts.push(mins + "m")
                root.uptimeText = parts.join(" ")
            }
        }
    }
    Timer {
        interval: 60000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: uptimePoller.running = true
    }

    RowLayout {
        id: row
        spacing: 10

        opacity: root.introState
        transform: Translate { y: 20 * (1.0 - root.introState) }

        InfoPill {
            iconGlyph: "󰀄"
            labelText: root.currentUser
            fontFamily: root.fontFamily
            iconFontFamily: root.iconFontFamily
            colText: root.colText
            colOverlay2: root.colOverlay2
            colSurface0: root.colSurface0
            colSurface1: root.colSurface1
            accentColor: root.colMauve
            enabled: !root.isPlayingIntro
        }

        InfoPill {
			iconGlyph: "uptime:"
            labelText: root.uptimeText
            fontFamily: root.fontFamily
            iconFontFamily: root.iconFontFamily
            colText: root.colText
            colOverlay2: root.colOverlay2
            colSurface0: root.colSurface0
            colSurface1: root.colSurface1
            accentColor: root.colBlue
            enabled: !root.isPlayingIntro
        }

        Rectangle {
            id: batPill
            property bool isHovered: batMouse.containsMouse
            readonly property UPowerDevice device: UPower.displayDevice
            readonly property real pct: device.percentage * 100
            readonly property bool charging: device.state === UPowerDeviceState.Charging
            readonly property color dynamicColor: {
                if (charging) return root.colGreen
                if (pct >= 60) return root.colGreen
                if (pct >= 25) return root.colPeach
                return root.colRed
            }
            readonly property string glyph: {
                if (!device.isLaptopBattery) return "󰇅"
                if (charging) return ""
                if (pct >= 90) return "󰁹"
                if (pct >= 60) return "󰂁"
                if (pct >= 35) return "󰁿"
                if (pct >= 10) return "󰁺"
                return "󰂃"
            }

            Layout.preferredHeight: 30
            Layout.preferredWidth: batRow.implicitWidth + 36
            radius: 5

            color: isHovered ? Qt.rgba(root.colSurface1.r, root.colSurface1.g, root.colSurface1.b, 0.6) : Qt.rgba(root.colSurface0.r, root.colSurface0.g, root.colSurface0.b, 0.4)
            border.color: isHovered ? dynamicColor : Qt.rgba(root.colText.r, root.colText.g, root.colText.b, 0.08)
            border.width: 1

            scale: isHovered ? 1.05 : 1.0
            Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutExpo } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 200 } }

            RowLayout {
                id: batRow
                anchors.centerIn: parent
                spacing: 8
                Text {
                    text: batPill.glyph
                    font.family: root.iconFontFamily
                    font.pixelSize: 20
                    color: batPill.dynamicColor
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
                Text {
                    text: Math.round(batPill.pct) + "%"
                    font.family: root.fontFamily
                    font.pixelSize: 14
                    font.weight: Font.Black
                    color: batPill.dynamicColor
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }
            MouseArea { id: batMouse; anchors.fill: parent; hoverEnabled: true; enabled: !root.isPlayingIntro }
        }
    }
}
