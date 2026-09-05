import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root

    property bool open: false
    property real introState: 0.0
    property bool isPlayingIntro: true

    signal toggle()
    signal suspend()
    signal poweroff()
    signal reboot()

    property string fontFamily: "JetBrains Mono"
    property string iconFontFamily: "Iosevka Nerd Font"
    property color colText: "#cdd6f4"
    property color colSubtext0: "#a6adc8"
    property color colSurface0: "#313244"
    property color colSurface1: "#45475a"
    property color colSurface2: "#585b70"
    property color colCrust: "#11111b"
    property color colMauve: "#cba6f7"
    property color colBlue: "#89b4fa"
    property color colPeach: "#fab387"
    property color colRed: "#f38ba8"

    implicitWidth: powerBtn.width
    implicitHeight: powerBtn.height

    Rectangle {
        id: menu
        anchors.bottom: powerBtn.top 
        anchors.left: parent.left
		anchors.bottomMargin: 10
        width: 230
        height: root.open ? (menuLayout.implicitHeight + 10) : 0
        radius: 1
        clip: true
        opacity: root.open ? 1 : 0
		
        color: Qt.rgba(root.colSurface0.r, root.colSurface0.g, root.colSurface0.b, 0.95)
        border.color: Qt.rgba(root.colMauve.r, root.colMauve.g, root.colMauve.b, 0.25)
        border.width: 2

        Behavior on height { NumberAnimation { duration: 350; easing.type: Easing.OutExpo } }
        Behavior on opacity { NumberAnimation { duration: 250 } }

        ColumnLayout {
            id: menuLayout
            anchors.top: parent.top
			anchors.topMargin: 5
			anchors.bottomMargin: 5
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 3
            PowerMenuItem {
                label: "Reboot"; glyph: "󰜉"
                fontFamily: root.fontFamily; iconFontFamily: root.iconFontFamily
                accentColor: root.colBlue
                onClicked: root.reboot()
            }
            PowerMenuItem {
                label: "Suspend"; glyph: "󰒲"
                fontFamily: root.fontFamily; iconFontFamily: root.iconFontFamily
                accentColor: root.colMauve
                onClicked: root.suspend()
            }
            PowerMenuItem {
                label: "Power Off"; glyph: "󰐥"
                fontFamily: root.fontFamily; iconFontFamily: root.iconFontFamily
                accentColor: root.colRed
                isLast: true
                onClicked: root.poweroff()
            }
        }
    }

    Rectangle {
        id: powerBtn
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 45; height: width
        radius: height / 2

        color: root.open ? root.colSurface2
             : (powerBtnMa.containsMouse ? Qt.rgba(root.colSurface1.r, root.colSurface1.g, root.colSurface1.b, 0.8) : Qt.rgba(root.colSurface0.r, root.colSurface0.g, root.colSurface0.b, 0.4))
        border.color: root.open ? root.colText : Qt.rgba(root.colText.r, root.colText.g, root.colText.b, 0.15)
        border.width: 0

        opacity: root.introState
        transform: Translate { y: 20 * (1.0 - root.introState) }

        scale: powerBtnMa.pressed ? 0.9 : (powerBtnMa.containsMouse ? 1.08 : 1.0)

        Behavior on color { ColorAnimation { duration: 200 } }
        Behavior on border.color { ColorAnimation { duration: 200 } }
        Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }

        Text {
            anchors.centerIn: parent
            text: "󰐥"
            font.family: root.iconFontFamily
            font.pixelSize: 20
            color: root.open ? root.colRed : (powerBtnMa.containsMouse ? root.colText : root.colSubtext0)
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        MouseArea {
            id: powerBtnMa
            anchors.fill: parent
            hoverEnabled: true
            enabled: !root.isPlayingIntro
            onClicked: root.toggle()
        }
    }
}
