import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Layouts

PanelWindow {
    id: bar

    // Change this if you want it on a specific screen only
    // screen: Quickshell.screens.find(s => s.name === "eDP-1")

    anchors {
        top: true
        left: true
        right: true
    }

	implicitHeight: 33
    exclusiveZone: implicitHeight
    color: "#2d333f"

    WlrLayershell.layer: WlrLayershell.Top
    WlrLayershell.namespace: "quickshell-bar"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 3
        anchors.rightMargin: 3
        spacing: 9

        Tags {
            monitorName: "eDP-1"
        }
		Item { Layout.fillWidth: true }
	}
}
