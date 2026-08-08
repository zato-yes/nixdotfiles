import QtQuick
import "../themes"
Item {
    id: root

    required property string appName
    required property string appComment

    required property bool isSelected
    signal activated()

    implicitHeight: 40
    implicitWidth: ListView.view ? ListView.view.width : 400
	Rectangle {
        anchors.fill: parent
        anchors.margins: 0
        radius: 4
        color: "transparent"
		border.color: root.isSelected ? Colors.pinkRed : "transparent"
		border.width: 1
        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            spacing: 1

            Text {
                width: parent.width
                text: root.appName
                color: Colors.pastelYellow
                font.pixelSize: 14
                font.bold: root.isSelected
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                text: root.appComment
				color: Colors.pastelYellow
				opacity: root.isSelected ? 0.8 : 0.5
                font.pixelSize: 13
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
