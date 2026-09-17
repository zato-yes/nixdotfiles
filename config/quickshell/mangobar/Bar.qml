import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Layouts
import "../themes"
PanelWindow {
    id: bar
	required property var modelData
	screen: modelData
    // screen: Quickshell.screens.find(s => s.name === "eDP-1")

    anchors {
        top: true
        left: true
        right: true
	}
	implicitHeight: 30 + margins * 5
	property int margins: 1
    exclusiveZone: implicitHeight
	color: Colors.backgroundBar

	component Divider: Rectangle {
    width: 1
	height: 14
	opacity: 0.7
    color: Colors.mediumBlue
	}
	component Underline: Rectangle {
        id: underline
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: -4
        width: parent.width * 1
        height: 2.5
        radius: 1
        color: Colors.background
	} 


	Rectangle {
    radius: 0
	color: Colors.backgroundBar
        anchors {
            fill: parent
        	margins: bar.margins
        }
	}
    WlrLayershell.layer: WlrLayershell.Top
    WlrLayershell.namespace: "quickshell-bar"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        spacing: 9

        Tags {
            monitorName: "eDP-1"
        }
		Item { Layout.fillWidth: true }
		Rectangle {
			color: Colors.backgroundBar
			border.width: 1.2
			border.color: Colors.background
			radius: 3
    		implicitWidth: clock.implicitWidth + 15
	   		implicitHeight: clock.implicitHeight + 8
			anchors.centerIn: parent
			
			Clock {
				id: clock 
				anchors.centerIn: parent

				textColor: Colors.pastelYellow
				fontSize: 13
			}
		}
		
		Rectangle {
			color: Colors.backgroundBar
			border.width: 1
			border.color: Colors.background
			radius: 3
			implicitWidth: row.implicitWidth + 15
			implicitHeight: row.implicitHeight + 10
			RowLayout {
				id: row
	       		anchors.centerIn: parent
				spacing: 5
				Battery {
		    	    textColor: Colors.pastelBlue
					fontSize: 13
				}		
				Divider {}
				VolumeIndicator {
					usedForBar: true
					spacing: 5
					fontSize: 13
					textColor: Colors.pastelBlue
				}

				Divider {}	

				CpuIndicator {
					spacing: 5
					fontSize: 13
					textColor: Colors.pastelBlue
				}
				Divider {}	
				MemoryIndicator {
					spacing: 5
					fontSize: 13
					textColor: Colors.pastelBlue
				}
					



			}	
		}
	}
}
