import QtQuick
import Quickshell
import QtQuick.Layouts
Text {
    id: root
    property color textColor: "red"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    color: textColor
    font { family: fontFamily; pixelSize: fontSize; bold: true }
    textFormat: Text.PlainText

    SystemClock {
        id: clockTimer
        precision: SystemClock.Minutes
    }
    text: Qt.formatDateTime(clockTimer.date, "ddd, MMM dd - HH:mm")
}
