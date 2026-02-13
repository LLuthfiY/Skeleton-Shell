import QtQuick
import QtQuick.Controls

import qs.modules.common

Switch {
    id: root
    width: 44 * Config.options.appearance.uiScale
    height: 22 * Config.options.appearance.uiScale
    property real scale: Config.options.appearance.uiScale
    background: Rectangle {
        id: backgroundSwitch
        color: root.checked ? Color.colors.primary : Color.colors.surface
        border.color: Color.colors.primary
        border.width: 2 * root.scale
        radius: 9999
        implicitWidth: root.width
        implicitHeight: root.height
        anchors.verticalCenter: parent.verticalCenter
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }
    indicator: Rectangle {
        id: indicatorSwitch
        width: root.height - (10 * root.scale)
        height: root.height - (10 * root.scale)
        radius: 9999
        x: root.checked ? root.width - width - ((root.height - height) / 2) : (root.height - height) / 2
        color: root.checked ? Color.colors.on_primary : Color.colors.primary
        anchors.verticalCenter: backgroundSwitch.verticalCenter
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
        Behavior on x {
            NumberAnimation {
                duration: 200
            }
        }
    }
}
