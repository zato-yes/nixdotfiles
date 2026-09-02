import QtQuick 
import QtQuick.Window
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import "./themes"
import "./lockscreen"
ShellRoot {
    id: root

    property color colBase: Colors.backgroundBar
    property color colText: Colors.foreground
    property color colSubtext0: Colors.inactiveGrey
    property color colOverlay0: "#6c7086"
    property color colOverlay2: "#9399b2"
    property color colSurface0: "#313244"
    property color colSurface1: "#45475a"
    property color colSurface2: "#585b70"
    property color colMauve: Colors.foreground
    property color colRed: Colors.pinkRed
    property color colPeach: Colors.pastelYellow
    property color colBlue: Colors.pastelBlue
    property color colGreen: Colors.lightGreen

    property int cooldownMs: 0
    property int maxAttempts: 10
    property string lockoutMessage: "reboot"

    property string fontFamily: "JetBrains Mono"
    property string iconFontFamily: "Iosevka Nerd Font"

    QtObject {
        id: lockUI
        property bool failed: false
        property bool authenticating: false
        property bool lockedOut: false
        property bool cooldownActive: false
        property int attempts: 0
        property string statusText: "Locked"
    }

    Timer {
        id: cooldownTimer
        interval: root.cooldownMs
        onTriggered: lockUI.cooldownActive = false
    }

    Timer {
        id: pamActionTimer
        interval: 20
        onTriggered: {
            if (!lockUI.lockedOut) pam.start()
        }
    }

    PamContext {
        id: pam
        Component.onCompleted: pamActionTimer.start()

        onCompleted: (result) => {
            lockUI.authenticating = false
            if (result === PamResult.Success) {
                rootLock.locked = false
                Qt.quit()
            } else {
                lockUI.attempts += 1
                if (lockUI.attempts >= root.maxAttempts) {
                    lockUI.lockedOut = true
                    lockUI.failed = true
                    lockUI.statusText = root.lockoutMessage
                } else {
                    lockUI.failed = true
                    lockUI.statusText = "Access Denied"
                    pamActionTimer.start()
                }
            }
        }
    }

    function submitPassword(text) {
        if (lockUI.lockedOut || lockUI.cooldownActive || lockUI.authenticating) return
        lockUI.cooldownActive = true
        cooldownTimer.start()
        if (text.length > 0 && pam.responseRequired) {
            lockUI.authenticating = true
            lockUI.statusText = "Authenticating..."
            lockUI.failed = false
            pam.respond(text)
        }
    }

    Process { id: suspendProcess;  command: ["systemctl", "suspend"] }
    Process { id: poweroffProcess; command: ["systemctl", "poweroff"] }
    Process { id: rebootProcess;   command: ["systemctl", "reboot"] }

    WlSessionLock {
        id: rootLock
        locked: true

        WlSessionLockSurface {
            id: surface

            Item {
                id: screenRoot
                anchors.fill: parent

                property real introState: 0.0
                property bool isPlayingIntro: true
                property bool powerMenuOpen: false

                Component.onCompleted: introOverlay.introSequence.start()

                Rectangle { anchors.fill: parent; color: root.colBase }

                Rectangle {
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.25
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: !screenRoot.isPlayingIntro
                    onClicked: {
                        if (screenRoot.powerMenuOpen) screenRoot.powerMenuOpen = false
                        authModule.focusInput()
                    }
                }

                AuthModule {
                    id: authModule
                    anchors.fill: parent
                    introState: screenRoot.introState
                    isPlayingIntro: screenRoot.isPlayingIntro
                    powerMenuOpen: screenRoot.powerMenuOpen

                    failed: lockUI.failed
                    authenticating: lockUI.authenticating
                    lockedOut: lockUI.lockedOut
                    cooldownActive: lockUI.cooldownActive
                    statusText: lockUI.statusText

                    fontFamily: root.fontFamily
                    iconFontFamily: root.iconFontFamily
                    colText: root.colText
                    colSubtext0: root.colSubtext0
                    colSurface0: root.colSurface0
                    colMauve: root.colMauve
                    colRed: root.colRed
                    colPeach: root.colPeach

                    onSubmit: (text) => root.submitPassword(text)
                    onClearFailed: lockUI.failed = false
                }

                InfoPills {
                    id: infoPills
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    introState: screenRoot.introState
                    isPlayingIntro: screenRoot.isPlayingIntro

                    fontFamily: root.fontFamily
                    iconFontFamily: root.iconFontFamily
                    colText: root.colText
                    colOverlay2: root.colOverlay2
                    colSurface0: root.colSurface0
                    colSurface1: root.colSurface1
                    colMauve: root.colMauve
                    colGreen: root.colGreen
                    colPeach: root.colPeach
                    colRed: root.colRed
                }

                PowerMenu {
                    id: powerMenu
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: 40
                    open: screenRoot.powerMenuOpen
                    introState: screenRoot.introState
                    isPlayingIntro: screenRoot.isPlayingIntro

                    fontFamily: root.fontFamily
                    iconFontFamily: root.iconFontFamily
                    colText: root.colText
                    colSubtext0: root.colSubtext0
                    colSurface0: root.colSurface0
                    colSurface1: root.colSurface1
                    colSurface2: root.colSurface2
                    colMauve: root.colMauve
                    colBlue: root.colBlue
                    colPeach: root.colPeach
                    colRed: root.colRed

                    onToggle: {
                        screenRoot.powerMenuOpen = !screenRoot.powerMenuOpen
                        if (!screenRoot.powerMenuOpen) authModule.focusInput()
                    }
                    onSuspend: { screenRoot.powerMenuOpen = false; suspendProcess.running = true }
                    onPoweroff: { screenRoot.powerMenuOpen = false; poweroffProcess.running = true }
                    onReboot: { screenRoot.powerMenuOpen = false; rebootProcess.running = true }
                }

                IntroOverlay {
                    id: introOverlay
                    anchors.fill: parent
                    colText: root.colText
                    colSurface0: root.colSurface0
                    colMauve: root.colMauve
                    iconFontFamily: root.iconFontFamily

                    onIntroFinished: {
                        screenRoot.isPlayingIntro = false
                        screenRoot.introState = 1.0
                        authModule.focusInput()
                    }
                }

                Behavior on introState { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
            }
        }
    }
}
