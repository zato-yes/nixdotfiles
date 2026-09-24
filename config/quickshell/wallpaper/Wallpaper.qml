import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell
ShellRoot {
    Variants {
		model: Quickshell.screens
		PanelWindow {
			id: panelWindow
            required property var modelData
            screen: modelData
			property string wallpaperPath: "/nixdotfiles/wallpapers/nixwal.png"
			property string home: Quickshell.env("HOME")
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.exclusiveZone: -1
            WlrLayershell.namespace: "quickshell:wallpaper"

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            color: "transparent"

            Image {
                anchors.fill: parent
                source: WalConfig.wallpaperPath
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                cache: true
            }
        }
	}

	IpcHandler {
    	target: "wallpaper"
    	function set(path: string): void { WalConfig.wallpaperPath = path }
	}

}
