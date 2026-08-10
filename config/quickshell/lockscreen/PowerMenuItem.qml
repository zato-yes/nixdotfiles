import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string label: ""
    property string glyph: ""
    property string fontFamily: "JetBrains Mono"
    property string iconFontFamily: "Iosevka Nerd Font"
    property color accentColor: "#cba6f7"
    property bool isLast: false

    signal clicked()

    Layout.fillWidth: true
    Layout.preferredHeight: 45
    Layout.leftMargin: 10
    Layout.rightMargin: 10
    Layout.bottomMargin: isLast ? 4 : 0
    radius: 5

    color: ma.containsMouse ? Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.1) : "transparent"
    scale: ma.pressed ? 0.95 : (ma.containsMouse ? 1.02 : 1.0)
    Behavior on color { ColorAnimation { duration: 200 } }
    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

    readonly property color dimAccent: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.6)

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 0
        Text {
            text: root.glyph
            font.family: root.iconFontFamily
            font.pixelSize: 18
            color: ma.containsMouse ? root.accentColor : root.dimAccent
            Behavior on color { ColorAnimation { duration: 200 } }
        }
        Item { Layout.fillWidth: true }
        Text {
            text: root.label
            font.family: root.fontFamily
            font.pixelSize: 15
            font.weight: Font.Medium
            color: ma.containsMouse ? root.accentColor : root.dimAccent
            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
