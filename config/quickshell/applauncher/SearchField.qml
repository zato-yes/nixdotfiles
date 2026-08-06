import QtQuick
Item {
    id: root

    property alias text: input.text
    property alias placeholderText: placeholder.text

    implicitHeight: 48

    Rectangle {
        anchors.fill: parent
        radius: 6
        color: "#2a2a2a"
        border.color: "#444444"
        border.width: 1
    }

    Text {
        id: placeholder
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        text: "looking for..."
        color: "#666666"
        font.pixelSize: 15
        visible: input.text.length === 0
    }

    TextInput {
        id: input
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        verticalAlignment: TextInput.AlignVCenter
        color: "#e8e8e8"
        font.pixelSize: 15
        clip: true

        cursorVisible: activeFocus
    }

    function forceFocus() {
        input.forceActiveFocus()
    }
}
