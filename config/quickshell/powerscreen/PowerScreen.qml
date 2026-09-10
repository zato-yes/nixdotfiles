import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
PanelWindow {
	id: root

    visible: true
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
		implicitHeight: 550
		radius: 5
		color: "black"
		border.color: "white"
		border.width: 0.5
		opacity: 1
			anchors {
        		left: parent.left
        		right: parent.right
        		leftMargin: 200
				rightMargin: 200
				verticalCenter: parent.verticalCenter 
				verticalCenterOffset: -50
			}
			Text {
				text: "1 To Reboot, 2 To Poweroff, ESC Quit"
				color: "white"
				anchors.top: parent.top
        		anchors.horizontalCenter: parent.horizontalCenter
				anchors.topMargin: 10
				font.pixelSize: 25
			}
			Keybind {
    		anchors.fill: parent
			focus: true
			}
		}
		Rectangle {
		anchors.fill: parent	
		color: "black"
		opacity: 0.1

	
		}

		

}








   // function toggle() { visible = !visible }
    //IpcHandler {
      //  target: "powerMenu"
        //function toggle() { root.toggle() }
    //}

