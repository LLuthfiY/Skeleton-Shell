import QtQuick

import qs.modules.common

Item {
    implicitWidth: 24
    implicitHeight: 24
    Rectangle {
        anchors.centerIn: parent
        radius: Config.options.bar.borderRadius
        property bool vertical: Config.options.bar.position === "left" || Config.options.bar.position === "right"
        color: Color.colors[Config.options.bar.foreground]
        implicitWidth: vertical ? 18 : 2
        implicitHeight: vertical ? 2 : 18
    }
}
