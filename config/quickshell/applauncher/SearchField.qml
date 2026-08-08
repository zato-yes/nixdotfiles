import QtQuick
import "../themes"
Item {
    id: root

    property alias text: input.text
    property alias placeholderText: placeholder.text

    implicitHeight: 48

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: "Transparent"
        border.color: Colors.pinkRed
        border.width: 1
    }

    Text {
        id: placeholder
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        text: " looking for..."
        color: Colors.pastelGrey
        font.pixelSize: 15
        visible: input.text.length === 0
    }

    TextInput {
        id: input
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        verticalAlignment: TextInput.AlignVCenter
        color: Colors.pastelYellow
        font.pixelSize: 14
        clip: true

        cursorVisible: activeFocus
    }

    function forceFocus() {
        input.forceActiveFocus()
    }
}
