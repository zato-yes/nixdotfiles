import Quickshell
import QtQuick.Layouts
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import "../themes"
PanelWindow {
	id: root

    visible: false
	anchors {
		left: true
		right: true
		bottom: true
		top: true
	}
	color: "transparent"
	exclusiveZone: 3
	WlrLayershell.layer: WlrLayer.Overlay

	WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

		Rectangle {
		implicitHeight: 200
		radius: 0
		color: Colors.backgroundBar
		border.color: Colors.darkCreamWhite 
		border.width: 0.5
		opacity: 1
			anchors {
        		left: parent.left
        		right: parent.right
        		leftMargin: 550
				rightMargin: 550
				verticalCenter: parent.verticalCenter 
				verticalCenterOffset: -35
			}
			Text {
				text: "1 Reboot, 2 Poweroff, 3 Logout, ESC Quit"
				color: Colors.pastelBlue
				anchors.top: parent.top
        		anchors.horizontalCenter: parent.horizontalCenter
				anchors.topMargin: 10
				font.pixelSize: 30
				font.family: "JetBrainsMono Nerd Font"
			}
			Keybind {
    		anchors.fill: parent
			focus: true
			}
			RowLayout {
				anchors.centerIn: parent
				spacing: 100
				Rectangle {
					Layout.fillWidth: false
					opacity: 1
					Layout.preferredWidth: 100
					Layout.preferredHeight: 100
					Layout.leftMargin: 0
					color: Colors.background
                    }
					
				}
				Rectangle {
					Layout.fillWidth: false
					opacity: 1
					Layout.preferredWidth: 100
					Layout.preferredHeight: 100
					Layout.rightMargin: 0
					color: Colors.background
				}
				Rectangle {
					Layout.fillWidth: false
					opacity: 1
					Layout.preferredWidth: 100
					Layout.preferredHeight: 100
					Layout.rightMargin: 0
				}
			}
				

		}
		Rectangle {
		anchors.fill: parent	
		color: "black"
		opacity: 0

	
		}


