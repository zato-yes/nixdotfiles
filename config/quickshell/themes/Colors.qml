pragma Singleton
import Quickshell
import QtQuick
Singleton {
    readonly property color background: "#2d333f"
	readonly property color foreground: "#c6c6c8"

	readonly property color backgroundBar: "#1b1e25"
	readonly property color cursor: "#c6c6c8"

    readonly property color darkRed: "#967786"
    readonly property color darkRedLighter: Qt.lighter(darkRed, 1.5)
	readonly property color darkRedDarker: Qt.darker(darkRed, 1.5)

    readonly property color mediumBlue: "#7293A9"
    readonly property color mediumBlueLight: Qt.lighter(mediumBlue, 1.5)
	readonly property color mediumBlueDark: Qt.darker(mediumBlue, 1.5)

    readonly property color darkPastelRed: "#B28999"
    readonly property color darkPastelRedLight: Qt.lighter(darkPastelRed, 1.5)
	readonly property color darkPastelRedDark: Qt.darker(darkPastelRed, 1.5)
	
	readonly property color pastelBlue: "#83A6BF"
    readonly property color pastelBlueLight: Qt.lighter(pastelBlue, 1.5)
	readonly property color pastelBlueDark: Qt.darker(pastelBlue, 1.5)

    readonly property color pinkRed: "#edb1c2"
    readonly property color pinkRedLight: Qt.lighter(pinkRed, 1.5)
    readonly property color pinkRedDark: Qt.darker(pinkRed, 1.5)
	
	readonly property color pastelYellow: "#e7cb8b"
    readonly property color pastelYellowLight: Qt.lighter(pastelYellow, 1.5)
    readonly property color pastelYellowDark: Qt.darker(pastelYellow, 1.5)
	
	readonly property color pastelGrey: "#626878"
    readonly property color pastelGreyLight: Qt.lighter(pastelGrey, 1.5)
	readonly property color pastelGreyDark: Qt.darker(pastelGrey, 1.5)
		
	readonly property color inactiveGrey: "#717787"
    readonly property color inactiveGreyLight: Qt.lighter(inactiveGrey, 1.5)
    readonly property color inactiveGreyDark: Qt.darker(inactiveGrey, 1.5)

	
}
