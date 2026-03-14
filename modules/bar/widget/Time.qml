import QtQuick

import Quickshell
import qs.modules.common

Text {
    property string position: Config.options.bar.position
    property bool vertical: position === "left" || position === "right"
    text: Qt.formatTime(systemClock.date, vertical ? "hh\nmm" : "hh:mm")
    color: Color.colors[Config.options.bar.foreground]
    font.weight: Font.Bold
    font.pixelSize: vertical ? Variable.font.pixelSize.large : Variable.font.pixelSize.normal
    font.family: Variable.font.family.main
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
}
