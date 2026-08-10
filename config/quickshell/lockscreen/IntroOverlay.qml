import QtQuick

Item {
    id: root

    signal introFinished()

    property color colText: "#cdd6f4"
    property color colSurface0: "#313244"
    property color colMauve: "#cba6f7"
    property string iconFontFamily: "Iosevka Nerd Font"

    property alias introSequence: introSequence

    z: 999
    visible: opacity > 0 || introSequence.running

    Rectangle {
        id: ring3
        width: 360; height: width; radius: height / 2
        anchors.centerIn: parent
        color: "transparent"
        border.color: root.colMauve
        border.width: 1
        scale: 0.5
        opacity: 0.0
    }
    Rectangle {
        id: ring2
        width: 300; height: width; radius: height / 2
        anchors.centerIn: parent
        color: "transparent"
        border.color: root.colText
        border.width: 1
        scale: 0.8
        opacity: 0.0
    }
    Rectangle {
        id: ring1
        width: 240; height: width; radius: height / 2
        anchors.centerIn: parent
        color: "transparent"
        border.color: root.colText
        border.width: 2
        scale: 0.8
        opacity: 0.0
    }

    Item {
        id: introLockOrb
        width: 170; height: width
        anchors.centerIn: parent
        scale: 0.0
        opacity: 0.0

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: Qt.rgba(root.colSurface0.r, root.colSurface0.g, root.colSurface0.b, 0.9)
            border.color: root.colText
            border.width: 2
        }

        Text {
            id: introIconUnlocked
            anchors.centerIn: parent
            text: "󰌿"
            font.family: root.iconFontFamily
            font.pixelSize: 64
            color: root.colText
            opacity: 1.0
            scale: 1.0
        }

        Text {
            id: introIconLocked
            anchors.centerIn: parent
            text: "󰌾"
            font.family: root.iconFontFamily
            font.pixelSize: 64
            color: root.colText
            opacity: 0.0
            scale: 1.6
        }
    }

    SequentialAnimation {
        id: introSequence

        ParallelAnimation {
            NumberAnimation { target: introLockOrb; property: "scale"; from: 0.0; to: 1.0; duration: 300; easing.type: Easing.OutCubic }
            NumberAnimation { target: introLockOrb; property: "opacity"; from: 0.0; to: 1.0; duration: 200; easing.type: Easing.OutCubic }

            NumberAnimation { target: ring1; property: "scale"; from: 0.8; to: 1.25; duration: 250; easing.type: Easing.OutCubic }
            NumberAnimation { target: ring1; property: "opacity"; from: 0.6; to: 0.0; duration: 250; easing.type: Easing.OutCubic }

            NumberAnimation { target: ring2; property: "scale"; from: 0.8; to: 1.4; duration: 300; easing.type: Easing.OutCubic }
            NumberAnimation { target: ring2; property: "opacity"; from: 0.4; to: 0.0; duration: 300; easing.type: Easing.OutCubic }

            NumberAnimation { target: ring3; property: "scale"; from: 0.5; to: 1.5; duration: 350; easing.type: Easing.OutCubic }
            NumberAnimation { target: ring3; property: "opacity"; from: 0.3; to: 0.0; duration: 350; easing.type: Easing.OutCubic }

            SequentialAnimation {
                PauseAnimation { duration: 300 }
                ParallelAnimation {
                    NumberAnimation { target: introIconUnlocked; property: "scale"; from: 1.0; to: 0.5; duration: 100; easing.type: Easing.InCubic }
                    NumberAnimation { target: introIconUnlocked; property: "opacity"; from: 1.0; to: 0.0; duration: 50 }

                    NumberAnimation { target: introIconLocked; property: "scale"; from: 1.6; to: 1.0; duration: 200; easing.type: Easing.OutBack }
                    NumberAnimation { target: introIconLocked; property: "opacity"; from: 0.0; to: 1.0; duration: 100 }

                    SequentialAnimation {
                        NumberAnimation { target: introLockOrb; property: "anchors.verticalCenterOffset"; from: 0; to: 3; duration: 40; easing.type: Easing.OutQuad }
                        NumberAnimation { target: introLockOrb; property: "anchors.verticalCenterOffset"; from: 3; to: 0; duration: 120; easing.type: Easing.OutBack }
                    }
                }
            }
        }

        PauseAnimation { duration: 50 }

        ParallelAnimation {
            NumberAnimation { target: introLockOrb; property: "scale"; to: 1.8; duration: 100; easing.type: Easing.InCubic }
            NumberAnimation { target: root; property: "opacity"; to: 0.0; duration: 100; easing.type: Easing.InCubic }
        }

        ScriptAction { script: root.introFinished() }
    }
}
