import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland

FocusScope {
	id: root
	property int lastKey: -1
	property double lastPressTime: 0
	readonly property int confirmWindowMs: 500

	focus: true

	Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
			root.Window.window.visible = false;
            return;
        }
        if (event.key !== Qt.Key_1 && event.key !== Qt.Key_2) {
            return;
        }
        const now = Date.now();
        const isConfirm = (event.key === root.lastKey)
                        && (now - root.lastPressTime) < root.confirmWindowMs;
        if (isConfirm) {
            if (event.key === Qt.Key_1) {
                Quickshell.execDetached(["systemctl", "reboot"]);
            } else if (event.key === Qt.Key_2) {
                Quickshell.execDetached(["systemctl", "poweroff"]);
            }
            root.lastKey = -1;
            root.lastPressTime = 0;
        } else {
           root.lastKey = event.key;
           root.lastPressTime = now;
       }
   }
}
