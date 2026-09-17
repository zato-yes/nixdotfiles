import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import "../themes"
PanelWindow {
    id: root
    visible: false
    mask: Region {}
    anchors {
        left: true
        right: true
        bottom: true
        top: true
    }
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.namespace: "volumeIndicator"

    readonly property var sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    IpcHandler {
        target: "volumeIndicator"
        function show() { root.show() }
    }
    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.visible = false
    }
    function show() {
        root.visible = true
        hideTimer.restart()
    }
    Connections {
        target: root.sink?.audio ?? null
        function onVolumeChanged() { root.show() }
        function onMutedChanged() { root.show() }
    }
    Rectangle {
        implicitHeight: 65
        radius: 1
        color: Colors.backgroundBar
        opacity: 1
		border.width: 0
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 840
            rightMargin: 840
            bottom: parent.bottom
            bottomMargin: 150
        }

        VolumeIndicator {
			anchors.centerIn: parent
			textColor: Colors.pastelBlue
        }
    }
}
