import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    property real introState: 0.0
    property bool isPlayingIntro: true
    property bool powerMenuOpen: false

    property bool failed: false
    property bool authenticating: false
    property bool lockedOut: false
    property bool cooldownActive: false
    property string statusText: "Locked"

    signal submit(string text)
    signal clearFailed()

    property string fontFamily: "JetBrains Mono"
    property string iconFontFamily: "Iosevka Nerd Font"
    property color colText: "#cdd6f4"
    property color colSubtext0: "#a6adc8"
    property color colSurface0: "#313244"
    property color colMauve: "#cba6f7"
    property color colRed: "#f38ba8"
    property color colPeach: "#fab387"

    property bool hidePassword: true
    property int revealDuration: 200
    property string currentUser: "User"

    function focusInput() {
        if (!root.lockedOut) inputField.forceActiveFocus()
    }

    Process {
        id: userPoller
        command: ["whoami"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.currentUser = this.text.trim()
        }
    }

    onFailedChanged: if (failed) shakeAnim.restart()

    ColumnLayout {
        id: authColumn
        anchors.centerIn: parent
        spacing: 28

        opacity: root.introState
        scale: 0.95 + (0.05 * root.introState)
        transform: Translate { y: 20 * (1.0 - root.introState) }

        ColumnLayout {
            id: clockModule
            Layout.alignment: Qt.AlignHCenter
            spacing: 60

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 0
                Text {
                    id: clockHours
                    font.family: root.fontFamily; font.pixelSize: 140; font.weight: Font.Bold
                    color: root.colText
                }
                Text {
                    text: ":"
                    font.family: root.fontFamily; font.pixelSize: 140; font.weight: Font.Bold
                    opacity: 0.5; color: root.colText
                }
                Text {
                    id: clockMinutes
                    font.family: root.fontFamily; font.pixelSize: 140; font.weight: Font.Bold
                    color: root.colText
                }
            }

            Text {
                id: dateText
                Layout.alignment: Qt.AlignHCenter
                font.family: root.fontFamily; font.pixelSize: 22; font.weight: Font.Bold
                color: root.colText
            }

            Timer {
                interval: 1000; running: true; repeat: true; triggeredOnStart: true
                onTriggered: {
                    let d = new Date()
                    clockHours.text = Qt.formatDateTime(d, "hh")
                    clockMinutes.text = Qt.formatDateTime(d, "mm")
                    dateText.text = Qt.formatDateTime(d, "dddd, MMMM dd")
                }
            }
        }

        RowLayout {
            id: authRow
            Layout.alignment: Qt.AlignHCenter
            spacing: 30
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10
                Rectangle {
                    id: pinPill
                    visible: !root.lockedOut
                    width: 280; height: 56; radius: 5
                    clip: true
                    color: root.failed ? Qt.rgba(root.colRed.r, root.colRed.g, root.colRed.b, 0.1) : Qt.rgba(root.colSurface0.r, root.colSurface0.g, root.colSurface0.b, 0.5)
                    border.width: 2
                    border.color: {
                        if (root.failed) return root.colRed
                        if (root.authenticating) return root.colPeach
                        if (inputField.text.length > 0) return root.colText
                        return Qt.rgba(root.colText.r, root.colText.g, root.colText.b, 0.08)
                    }
                    Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutExpo } }
                    Behavior on border.color { ColorAnimation { duration: 250; easing.type: Easing.OutExpo } }

                    scale: root.failed ? 1.05 : (root.authenticating ? 0.98 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }

                    transform: Translate { id: shakeTranslate; x: 0 }

                    SequentialAnimation {
                        id: shakeAnim
                        NumberAnimation { target: shakeTranslate; property: "x"; from: 0; to: -8; duration: 120; easing.type: Easing.InOutSine }
                        NumberAnimation { target: shakeTranslate; property: "x"; from: -8; to: 8; duration: 120; easing.type: Easing.InOutSine }
						NumberAnimation { target: shakeTranslate; property: "x"; from: 8; to: 0; duration: 120; easing.type: Easing.InOutSine }
					}
										
                    

                    TextInput {
                        id: inputField
                        anchors.fill: parent
                        opacity: 0
                        echoMode: TextInput.Password
                        enabled: !root.isPlayingIntro && !root.lockedOut && !root.cooldownActive
                        focus: true

                        property string oldText: ""

                        // always try to hold focus back unless the power menu
                        // is open or we're locked out/midintro
                        onActiveFocusChanged: {
                            if (!activeFocus && !root.powerMenuOpen && !root.isPlayingIntro && !root.lockedOut) {
                                forceActiveFocus()
                            }
                        }

                        Component.onCompleted: forceActiveFocus()

                        Keys.onPressed: (event) => {
                            if (event.key === Qt.Key_Escape) {
                                text = ""
                                passModel.clear()
                                event.accepted = true
                            }
                        }

                        onAccepted: {
                            if (!enabled) return
                            root.clearFailed()
                            root.submit(text)
                            text = ""
                            oldText = ""
                            passModel.clear()
                        }

                        onTextChanged: {
                            if (root.authenticating) return

                            if (text !== oldText) {
                                if (text.length > oldText.length) {
                                    for (let i = oldText.length; i < text.length; i++)
                                        passModel.append({ "charStr": text.charAt(i), "isDot": root.hidePassword })
                                } else if (text.length < oldText.length) {
                                    let diff = oldText.length - text.length
                                    for (let i = 0; i < diff; i++) passModel.remove(passModel.count - 1)
                                } else {
                                    passModel.clear()
                                    for (let i = 0; i < text.length; i++)
                                        passModel.append({ "charStr": text.charAt(i), "isDot": root.hidePassword })
                                }
                                oldText = text
                            }

                            if (text.length > 0) {
                                root.clearFailed()
                            }
                        }
                    }

                    ListModel { id: passModel }

                    Item {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        clip: true

                        Row {
                            id: dotRow
                            anchors.verticalCenter: parent.verticalCenter
                            x: width > parent.width ? parent.width - width : (parent.width - width) / 2
                            spacing: 4
                            Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }	

                            Repeater {
                                model: passModel
                                delegate: Text {
                                    text: model.isDot ? "•" : model.charStr
                                    font.family: root.fontFamily
                                    font.pixelSize: model.isDot ? 32 : 24
                                    font.weight: Font.Bold
                                    color: root.failed ? root.colRed : (root.authenticating ? root.colPeach : root.colText)
                                    verticalAlignment: Text.AlignVCenter
                                    height: pinPill.height

                                    NumberAnimation on opacity { from: 0; to: 1; duration: 140 }

                                    Timer {
                                        interval: root.revealDuration
                                        running: !model.isDot && !root.hidePassword
                                        onTriggered: if (index >= 0 && index < passModel.count) passModel.setProperty(index, "isDot", true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
