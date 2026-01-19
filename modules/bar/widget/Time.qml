import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import qs.modules.common

Text {
    property string position: Config.options.bar.position
    property bool vertical: position === "left" || position === "right"
    property bool hovered: false
    text: Qt.formatTime(systemClock.date, vertical ? "hh\nmm" : "hh:mm")
    color: Color.colors[Config.options.bar.foreground]
    font.weight: 900
    font.pixelSize: 20
    font.family: "Open Sans"
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    // ToolTip.visible: hovered
    // ToolTip.text: new Date().toLocaleString("id-ID")

    // StyledToolTip {
    //     content: new Date().toLocaleString("id-ID")
    // }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: hovered = true
        onExited: hovered = false
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
}
