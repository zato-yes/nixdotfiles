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
	Bar {}
	Wallpaper {}
	PowerScreen {
	id: powerMenu
	visible: false
	}	 
	
}
