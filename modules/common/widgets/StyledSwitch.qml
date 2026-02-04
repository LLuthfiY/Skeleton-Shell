import QtQuick
import QtQuick.Controls

import qs.modules.common

Switch {
    id: root
    background: Rectangle {
        id: backgroundSwitch
        color: root.checked ? Color.colors.primary : Color.colors.surface_container
        border.color: Color.colors.primary
        radius: 9999
        implicitWidth: 40
        implicitHeight: 20
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }
    indicator: Rectangle {
        id: indicatorSwitch
        implicitWidth: 16
        implicitHeight: 16
        radius: 9999
        x: root.checked ? root.width - width - ((root.height - height) / 2) : (root.height - height) / 2
        color: root.checked ? Color.colors.on_primary : Color.colors.primary
        border.color: Color.colors.on_primary
        anchors.verticalCenter: parent.verticalCenter
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
