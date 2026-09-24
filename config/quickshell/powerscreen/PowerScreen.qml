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
	WlrLayershell.namespace: "powerScreenQS"

		Rectangle {
		implicitHeight: 200
		radius: 0
		color: Colors.backgroundBar
		border.color: Colors.darkCreamWhite 
		border.width: 0
		opacity: 1
			anchors {
        		left: parent.left
        		right: parent.right
        		leftMargin: 650
				rightMargin: 650
				verticalCenter: parent.verticalCenter 
				verticalCenterOffset: -50
			}
			Text {
				text: "1 Reboot, 2 Poweroff, 3 Logout, ESC Quit"
				color: Colors.pastelBlue
				anchors.top: parent.top
        		anchors.horizontalCenter: parent.horizontalCenter
				anchors.topMargin: 10
				font.pixelSize: 20
				font.family: "JetBrainsMono Nerd Font"
			}
			Keybind {
				id: keys
    			anchors.fill: parent
				focus: true
			}
			RowLayout {
				anchors.centerIn: parent
				spacing: 100
				Rectangle {
					Layout.fillWidth: false
					radius: 5
					opacity: 1
					Layout.preferredWidth: 100
					Layout.preferredHeight: 100
					Layout.leftMargin: 0
					color: keys.lastKey == Qt.Key_1 ? Colors.backgroundBar : "transparent"
					border.color: keys.lastKey == Qt.Key_1 ?  Colors.background : "transparent"
					border.width: 1
					Text {
						anchors.centerIn: parent
						fontSizeMode: Text.Fit
                        text: "󰜉"
						font.pixelSize: 105
						color: keys.lastKey == Qt.Key_1 ? Colors.cursor : Colors.inactiveGrey
                        font.family: "JetBrainsMono Nerd Font"
                    }
					
				}
				Rectangle {
					Layout.fillWidth: false
					radius: 5
					opacity: 1
					Layout.preferredWidth: 100
					Layout.preferredHeight: 100
					Layout.rightMargin: 0
					color: keys.lastKey == Qt.Key_2 ? Colors.backgroundBar : "transparent"
					border.color: keys.lastKey == Qt.Key_2 ?  Colors.background : "transparent"
					border.width: 1
					Text {
						anchors.centerIn: parent
						fontSizeMode: Text.Fit
                        text: "󰐥"
                        font.pixelSize: 105
						font.family: "JetBrainsMono Nerd Font"
						color: keys.lastKey == Qt.Key_2 ? Colors.cursor : Colors.inactiveGrey
                    }
				}
				Rectangle {
					Layout.fillWidth: false
					radius: 5
					opacity: 1
					Layout.preferredWidth: 100
					Layout.preferredHeight: 100
					Layout.rightMargin: 0
					color: keys.lastKey == Qt.Key_3 ? Colors.backgroundBar : "transparent"
					border.color: keys.lastKey == Qt.Key_3 ?  Colors.background : "transparent"
					border.width: 1
					Text {
						anchors.centerIn: parent
						fontSizeMode: Text.Fit
                        text: "󰍃"
                        font.pixelSize: 95
						font.family: "JetBrainsMono Nerd Font"
						color: keys.lastKey == Qt.Key_3 ? Colors.cursor : Colors.inactiveGrey
                    }
				}

			}
				

		}
		Rectangle {
		anchors.fill: parent	
		color: "black"
		opacity: 0.1

	
		}

		




function toggle() { visible = !visible }
	IpcHandler { 
      target: "powerMenu"
    	function toggle() { root.toggle() }
    }
}
