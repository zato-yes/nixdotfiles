import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Item {
    id: root
    property color textColor: "red"
    property int fontSize: 16
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int spacing: 3
    property string glyphMuted: "󰝟"
    property string glyphLow: "󰕿"
    property string glyphMid: "󰖀"
    property string glyphHigh: "󰕾"
    property int lowMidThreshold: 35
    property int midHighThreshold: 40

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property int volume: sink?.audio ? Math.round(sink.audio.volume * 100) : 0
    readonly property bool muted: sink?.audio ? sink.audio.muted : false

    readonly property string glyph: muted
        ? glyphMuted
        : (volume <= lowMidThreshold
            ? glyphLow
            : (volume <= midHighThreshold ? glyphMid : glyphHigh))

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    // Required so Pipewire actually tracks this node's properties
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Row {
        id: row
        spacing: root.spacing
        Text {
            text: root.glyph
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            color: root.textColor
        }
        Text {
			text: "%" + root.volume 
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            color: root.textColor
        }
    }

    function setVolume(percent) {
        percent = Math.max(0, Math.min(100, percent));
        if (sink?.audio) sink.audio.volume = percent / 100;
    }

    function increaseVolume(step) {
        if (sink?.audio) sink.audio.volume = Math.min(1.0, sink.audio.volume + (step ?? 5) / 100);
    }

    function decreaseVolume(step) {
        if (sink?.audio) sink.audio.volume = Math.max(0.0, sink.audio.volume - (step ?? 5) / 100);
    }

    function toggleMute() {
        if (sink?.audio) sink.audio.muted = !sink.audio.muted;
    }
}
