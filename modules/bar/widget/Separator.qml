import QtQuick

import qs.modules.common

Item {
    implicitWidth: Variable.size.large
    implicitHeight: Variable.size.large
    Rectangle {
        anchors.centerIn: parent
        radius: Config.options.bar.borderRadius
        property bool vertical: Config.options.bar.position === "left" || Config.options.bar.position === "right"
        color: Color.colors[Config.options.bar.foreground]
        implicitWidth: vertical ? Variable.size.normal : 2
        implicitHeight: vertical ? 2 : Variable.size.normal
    }
}
