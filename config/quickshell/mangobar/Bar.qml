import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Layouts
PanelWindow {
    id: bar

    // screen: Quickshell.screens.find(s => s.name === "eDP-1")

    anchors {
        top: true
        left: true
        right: true
    }
	implicitHeight: 33 + margins * 3
	property int margins: 6
    exclusiveZone: implicitHeight
	color: "Transparent"

	Rectangle {
    radius: 5
	color: "#1e1e2e"
        anchors {
            fill: parent
        	margins: bar.margins
        }
	}






    WlrLayershell.layer: WlrLayershell.Top
    WlrLayershell.namespace: "quickshell-bar"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 9

        Tags {
            monitorName: "eDP-1"
        }
		Item { Layout.fillWidth: true }
	}
}
