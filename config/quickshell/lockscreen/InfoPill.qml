import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string iconGlyph: ""
    property string labelText: ""
    property string fontFamily: "JetBrains Mono"
    property string iconFontFamily: "Iosevka Nerd Font"
    property color colText: "#cdd6f4"
    property color colOverlay2: "#9399b2"
    property color colSurface0: "#313244"
    property color colSurface1: "#45475a"
    property color accentColor: "#cba6f7"
    property bool enabled: true

    property bool isHovered: mouse.containsMouse

    Layout.preferredHeight: 30
    Layout.preferredWidth: pillRow.implicitWidth + 36
    radius: 5

    color: isHovered ? Qt.rgba(colSurface1.r, colSurface1.g, colSurface1.b, 0.6) : Qt.rgba(colSurface0.r, colSurface0.g, colSurface0.b, 0.4)
    border.color: isHovered ? accentColor : Qt.rgba(colText.r, colText.g, colText.b, 0.08)
    border.width: 1

    scale: isHovered ? 1.05 : 1.0
    Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutExpo } }
    Behavior on color { ColorAnimation { duration: 200 } }
    Behavior on border.color { ColorAnimation { duration: 200 } }

    RowLayout {
        id: pillRow
        anchors.centerIn: parent
        spacing: 8
        Text {
            text: root.iconGlyph
            font.family: root.iconFontFamily
            font.pixelSize: 18
            color: root.isHovered ? root.accentColor : root.colOverlay2
            Behavior on color { ColorAnimation { duration: 200 } }
        }
        Text {
            text: root.labelText
            font.family: root.fontFamily
            font.pixelSize: 14
            font.weight: Font.Black
            color: root.colText
        }
    }

    MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; enabled: root.enabled }
}
