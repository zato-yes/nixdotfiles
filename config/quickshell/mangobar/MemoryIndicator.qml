import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property color textColor: "red"                      
    property int fontSize: 16
    property string fontFamily: "JetBrainsMono Nerd Font" 
    property int spacing: 4

    property int pollIntervalMs: 4000
    property string glyph: ""
    property bool showGlyph: true

    property real usage: 0.0        // 0.0 - 100.0
    property real usedGiB: 0.0
    property real totalGiB: 0.0
    readonly property int usagePercent: Math.round(usage)

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
        id: memProc
        command: ["cat", "/proc/meminfo"]

        property var lines: []
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                memProc.lines.push(data);
            }
        }
        onRunningChanged: {
            if (running) {
                lines = [];
                return;
            }

            let memTotal = 0;
            let memAvailable = 0;

            for (const line of lines) {
                if (line.startsWith("MemTotal:")) {
                    memTotal = parseInt(line.match(/\d+/)[0], 10);
                } else if (line.startsWith("MemAvailable:")) {
                    memAvailable = parseInt(line.match(/\d+/)[0], 10);
                }
            }

            if (memTotal > 0) {
                const usedKiB = memTotal - memAvailable;
                root.usage = Math.max(0, Math.min(100, 100.0 * usedKiB / memTotal));
                root.usedGiB = usedKiB / (1024 * 1024);
                root.totalGiB = memTotal / (1024 * 1024);
            }
        }
    }

    Timer {
        interval: root.pollIntervalMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: memProc.running = true
    }

    function refresh() {
        memProc.running = true;
    }
}
