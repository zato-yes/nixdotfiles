import Quickshell
import QtQuick
import Quickshell.Io

PanelWindow {
    id: root
    visible: false

    function toggle() { visible = !visible }

    IpcHandler {
        target: "powerMenu"
        function toggle() { root.toggle() }
    }
}
