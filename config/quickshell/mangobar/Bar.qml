import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Layouts
import "../themes"
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

	component Divider: Rectangle {
    width: 1
	height: 14
	opacity: 0.7
    color: Colors.mediumBlue
	}



	Rectangle {
    radius: 5
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
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 9

        Tags {
            monitorName: "eDP-1"
        }
		Item { Layout.fillWidth: true }
		Rectangle {
			color: Colors.background
			radius: 7
    		implicitWidth: clock.implicitWidth + 15
	   		implicitHeight: clock.implicitHeight + 10 
			anchors.centerIn: parent	
			Clock {
				id: clock 
				anchors.centerIn: parent

				textColor: Colors.pastelYellow
				fontSize: 13
			}
		}
		
		Rectangle {
			color: Colors.background
			radius: 7
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
