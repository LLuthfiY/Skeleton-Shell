import QtQuick

import qs.modules.common

Rectangle {
    id: root
    property bool toggled: false
    property font font: Qt.font({
        family: Variable.font.family.main,
        pixelSize: Variable.font.pixelSize.normal,
        weight: Font.Normal
    })
    property bool toggleSize: false
    property string textColor: Color.colors.on_surface
    property string label: "Toggle"
    property string icon: ""
    radius: Variable.radius.smallest
    width: loader.width + Variable.size.small * 2
    height: font.pixelSize + Variable.size.small
    color: "transparent"
    HoverHandler {
        id: hoverHandler
    }
    Rectangle {
        width: loader.width + Variable.size.normal
        height: loader.height + Variable.size.small
        color: toggled ? Color.colors.primary : hoverHandler.hovered ? Color.colors.primary_container : Color.colors.surface
        radius: Variable.radius.large
        anchors.centerIn: parent
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
        Behavior on width {
            NumberAnimation {
                duration: 200
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: 200
            }
        }
        Loader {
            id: loader
            sourceComponent: root.icon !== "" ? icon : text
            anchors.centerIn: parent
        }
    }
    Component {
        id: icon
        LucideIcon {
            icon: root.icon
            label: root.label
            color: root.toggled ? Color.colors.on_primary : root.textColor
            font.family: root.font.family
            font.pixelSize: !root.toggleSize ? root.font.pixelSize : root.toggled ? root.font.pixelSize : root.font.pixelSize - Math.round(root.font.pixelSize / 6)
            font.weight: Font.Normal
        }
    }
    Component {
        id: text
        Text {
            text: root.label
            color: root.toggled ? Color.colors.on_primary : root.textColor
            font.family: root.font.family
            font.pixelSize: !root.toggleSize ? root.font.pixelSize : root.toggled ? root.font.pixelSize : root.font.pixelSize - Math.round(root.font.pixelSize / 6)
            font.weight: Font.Normal
        }
    }
}
