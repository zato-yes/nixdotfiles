import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./themes"
import "./applauncher"
//   - loading the app cache (with first-run auto-generation)
//   - filtering the list as the user types
//   - tracking which row is selected
//   - handling every keypress (Esc / Up / Down / Enter)
//   - actually launching the chosen app and quitting
//
ShellRoot {
    id: shellRoot

    readonly property string parserScriptPath:
        Qt.resolvedUrl("./parseDesktop.py").toString().replace("file://", "")

    readonly property string cacheFilePath:
        Quickshell.env("HOME") + "/.cache/quickshell-launcher/apps.json"

    property var allApps: []

    property var filteredApps: []

    property int selectedIndex: 0


    FileView {
        id: cacheFile
        path: shellRoot.cacheFilePath
        watchChanges: true
        onFileChanged: reload()

        onLoaded: {
            try {
                shellRoot.allApps = JSON.parse(text())
            } catch (e) {
                console.warn("app launcher: failed to parse cache JSON:", e)
                shellRoot.allApps = []
            }
            shellRoot.applyFilter()
        }

        onLoadFailed: (error) => {
            console.log("app launcher: cache missing or unreadable, generating it now")
            cacheGenerator.running = true
        }
    }

    Process {
        id: cacheGenerator
        command: ["python3", shellRoot.parserScriptPath]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                cacheFile.reload()
            } else {
                console.warn("app launcher: parseDesktop.py failed with exit code", exitCode)
            }
        }
    }

    function applyFilter() {
        const query = searchField.text.trim().toLowerCase()

        if (query.length === 0) {
            filteredApps = allApps
        } else {
            filteredApps = allApps.filter(app =>
                app.name.toLowerCase().includes(query)
            )
        }

        if (selectedIndex >= filteredApps.length) {
            selectedIndex = Math.max(0, filteredApps.length - 1)
        }
    }


    function launchSelected() {
        if (filteredApps.length === 0) return

        const app = filteredApps[selectedIndex]

        Quickshell.execDetached(["sh", "-c", app.exec])
        Qt.quit()
    }


    PanelWindow {
        id: window
		//backgroundwindow
        implicitWidth: 600
        implicitHeight: 500

		color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
		WlrLayershell.namespace: "quickshell:applauncher"
		Rectangle {
			color: Qt.rgba(0.12, 0.12, 0.16, 0.6)
				
            anchors.fill: parent
            radius: 10
         	//color: Colors.backgroundBar
            border.color: Colors.backgroundBar
            border.width: 3

			Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 5
                SearchField {
                    id: searchField
                    width: parent.width

                    onTextChanged: {
                        shellRoot.selectedIndex = 0
                        shellRoot.applyFilter()
                    }
                }

                ResultsList {
                    id: resultsList
                    width: parent.width
                    height: parent.height - searchField.height - parent.spacing

                    appModel: shellRoot.filteredApps
                    selectedIndex: shellRoot.selectedIndex

                    onItemActivated: (index) => {
                        shellRoot.selectedIndex = index
                        shellRoot.launchSelected()
                    }
                }
            }

            focus: true

            Keys.onPressed: (event) => {
                switch (event.key) {
                    case Qt.Key_Escape:
                        Qt.quit()
                        event.accepted = true
                        break

                    case Qt.Key_Down:
                        if (shellRoot.filteredApps.length > 0) {
                            shellRoot.selectedIndex =
                                Math.min(shellRoot.selectedIndex + 1, shellRoot.filteredApps.length - 1)
                        }
                        event.accepted = true
                        break

                    case Qt.Key_Up:
                        if (shellRoot.filteredApps.length > 0) {
                            shellRoot.selectedIndex = Math.max(shellRoot.selectedIndex - 1, 0)
                        }
                        event.accepted = true
                        break

                    case Qt.Key_Return:
                    case Qt.Key_Enter:
                        shellRoot.launchSelected()
                        event.accepted = true
                        break

                }
            }
        }

        Component.onCompleted: {
            searchField.forceFocus()
        }
    }
}
