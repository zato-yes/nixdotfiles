import QtQuick

Item {
    id: root

    required property var appModel       
    required property int selectedIndex   

    signal itemActivated(int index)       

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        model: root.appModel
        currentIndex: root.selectedIndex

        highlightMoveDuration: 80

        delegate: ResultDelegate {
            required property var modelData
            required property int index

            appName: modelData.name
            appComment: modelData.comment ? modelData.comment : ""
            isSelected: index === root.selectedIndex

            onActivated: root.itemActivated(index)
        }
    }

    Text {
        anchors.centerIn: parent
        visible: root.appModel.length === 0
        text: "No results"
        color: "#777777"
        font.pixelSize: 14
    }

    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 6
        visible: root.appModel.length > 0
        text: root.appModel.length + (root.appModel.length === 1 ? " result" : " results")
        color: "#555555"
        font.pixelSize: 10
    }
}
