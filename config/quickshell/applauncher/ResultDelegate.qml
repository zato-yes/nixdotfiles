import QtQuick

Item {
    id: root

    required property string appName
    required property string appComment

    required property bool isSelected
    signal activated()

    implicitHeight: 44
    implicitWidth: ListView.view ? ListView.view.width : 400

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        radius: 6
        color: root.isSelected ? "#3a3a3a" : "transparent"

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 2

            Text {
                width: parent.width
                text: root.appName
                color: "#e8e8e8"
                font.pixelSize: 15
                font.bold: root.isSelected
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                text: root.appComment
                color: "#999999"
                font.pixelSize: 12
                elide: Text.ElideRight
                visible: root.appComment.length > 0
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.activated()
    }
}
