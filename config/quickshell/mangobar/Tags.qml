import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

RowLayout {
    id: root
    // Which monitor to watch, e.g. "eDP-1"
    property string monitorName: "eDP-1"
    property QtObject colors: Colors {}
    property var tagList: []
    property int activeTag: -1

    spacing: 4

    function parseLine(line) {
        var trimmed = line.trim()
        if (trimmed.length === 0) return
        try {
            var json = JSON.parse(trimmed)
            root.tagList = json.tags
            root.activeTag = (json.active_tags && json.active_tags.length > 0)
                ? json.active_tags[0]
                : -1
        } catch (e) {
            console.warn("Tags: parse error:", e, trimmed)
        }
    }

    function switchToTag(index) {
        switchTagProc.command = ["mmsg", "dispatch", "view," + index]
        switchTagProc.running = true
    }

    Process {
        id: watchTags
        command: ["mmsg", "watch", "tags", root.monitorName]
        running: true
        stdout: SplitParser { onRead: (line) => root.parseLine(line) }
    }

    Process {
        id: switchTagProc
    }

    Repeater {
        model: root.tagList

        delegate: Rectangle {
            id: tagDelegate

            required property var modelData

            readonly property bool isActive: modelData.is_active
            readonly property bool isEmpty: modelData.client_count === 0
            readonly property bool isUrgent: modelData.is_urgent

            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            radius: 3

            color: {
				//if (isUrgent) return colors.pinkRed
               //if (isActive) return colors.background
                if (isEmpty) return colors.background
                return colors.background // occupied but not focused
            }

            Text {
                anchors.centerIn: parent
                text: tagDelegate.modelData.index
                font.pixelSize: 12
                font.bold: tagDelegate.isActive
                color: {
                    if (tagDelegate.isActive || tagDelegate.isUrgent) return colors.pinkRed
                    if (tagDelegate.isEmpty) return colors.inactiveGrey
                    return "#cdd6f4" // not focused but occupied
                }
            }
			
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.switchToTag(tagDelegate.modelData.index)
            }

            Behavior on color {
				ColorAnimation { duration: 120 }

			}


			border.width: tagDelegate.isEmpty || tagDelegate.isActive ? 0 : 0.6
   	 		border.color: {
       		if (isUrgent) return colors.pinkRed
        	return colors.mediumBlue
    		}

   			Rectangle {
        	id: underline
        	visible: tagDelegate.isActive
        	anchors.horizontalCenter: parent.horizontalCenter
        	anchors.top: parent.bottom
        	anchors.topMargin: 2
        	width: parent.width * 0.7
        	height: 2
        	radius: 1
        	color: colors.pinkRed
			} 

		}
    }
}
