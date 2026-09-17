import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Layouts
import "./mangobar"
import "./themes"
import "./wallpaper"
import "./powerscreen"
//import "../themes/Colors.qml"
//
ShellRoot {
	Variants {
		model: Quickshell.screens
		Bar {
			modelData: modelData
		}
	}

	Wallpaper {}
	OnScreenVolumeIndicator {}
	
}
