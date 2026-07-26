import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell.Io



Item {
    id: root

    function parseLine(line) {
        var trimmed = line.trim()
        if (trimmed.length === 0) return

        try {
            var json = JSON.parse(trimmed)

            console.log("---- new line received ----")
            console.log("raw json object:", JSON.stringify(json, null, 2))
            console.log("tags array:", JSON.stringify(json.tags))
            console.log("first tag object:", JSON.stringify(json.tags[0]))
            console.log("first tag is_active:", json.tags[0].is_active)

        } catch (e) {
            console.warn("parse error:", e, trimmed)
        }
    }

    Process {
        id: watchTags
        command: ["mmsg", "watch", "tags", "eDP-1"]
        running: true
        stdout: SplitParser { onRead: (line) => root.parseLine(line) }
    }
}


