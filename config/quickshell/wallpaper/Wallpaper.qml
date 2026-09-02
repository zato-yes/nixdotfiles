import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

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
                source: "file:///home/dummy/nixdotfiles/themeing/boc1.png"
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true
            }
        }
    }
}
