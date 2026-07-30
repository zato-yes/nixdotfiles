import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property color textColor: "red"                      
    property int fontSize: 16
    property string fontFamily: "JetBrainsMono Nerd Font" 
    property int spacing: 4

    property int pollIntervalMs: 2000
    property string glyph: ""
    property bool showGlyph: true

    property real usage: 0.0   // 0.0 - 100.0
    readonly property int usagePercent: Math.round(usage)

    property var _prevIdle: 0
    property var _prevTotal: 0
    property bool _hasPrevSample: false

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: root.spacing

        Text {
            visible: root.showGlyph
            text: root.glyph
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            color: root.textColor
        }
        Text {
            text: root.usagePercent + "%"
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            color: root.textColor
        }
    }

    Process {
        id: statProc
        command: ["cat", "/proc/stat"]
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                if (!data.startsWith("cpu ")) return;
                const parts = data.trim().split(/\s+/).slice(1).map(Number);
                const idle = (parts[3] || 0) + (parts[4] || 0); // idle + iowait
                const total = parts.reduce((a, b) => a + b, 0);
                if (root._hasPrevSample) {
                    const idleDelta = idle - root._prevIdle;
                    const totalDelta = total - root._prevTotal;
                    if (totalDelta > 0) {
                        root.usage = Math.max(0, Math.min(100, 100.0 * (1 - idleDelta / totalDelta)));
                    }
                } else {
                    root._hasPrevSample = true;
                }

                root._prevIdle = idle;
                root._prevTotal = total;
            }
        }
    }

    Timer {
        interval: root.pollIntervalMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statProc.running = true
    }

    function refresh() {
        statProc.running = true;
    }
}
