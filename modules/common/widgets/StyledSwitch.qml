import QtQuick
import QtQuick.Controls

import qs.modules.common

Switch {
    id: root
    width: Variable.uiScale(44)
    height: Variable.uiScale(22)
    property string backgroundColor: Color.colors.surface
    property string accentColor: Color.colors.primary
    implicitWidth: root.width
    implicitHeight: root.height
    property real scale: Config.options.appearance.uiScale
    background: Rectangle {
        id: backgroundSwitch
        color: root.checked ? root.accentColor : root.backgroundColor
        border.color: root.accentColor
        border.width: 2 * root.scale
        radius: 9999
        width: root.width
        height: root.height
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
        color: root.checked ? root.backgroundColor : root.accentColor
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
