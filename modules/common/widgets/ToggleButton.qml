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
    property bool toggleOpacity: false
    property bool toggleSize: false
    property string textColor: Colors.colors.on_surface_variant
    property string label: "Toggle"
    property string icon: ""
    radius: Variable.radius.smallest
    width: loader.width + Variable.size.small * 2
    height: font.pixelSize + Variable.size.small
    color: "transparent"
    property int buttonRadius: Variable.radius.large
    HoverHandler {
        id: hoverHandler
    }
    Rectangle {
        opacity: root.toggleOpacity ? root.toggled ? 1 : hoverHandler.hovered ? 1 : 0.6 : 1
        width: loader.width + Variable.size.normal
        height: loader.height + Variable.size.small
        color: toggled ? Colors.colors.primary : hoverHandler.hovered ? Colors.colors.primary_container : Colors.colors.surface
        radius: root.buttonRadius
        anchors.centerIn: parent
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
        Behavior on opacity {
            NumberAnimation {
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
            color: root.toggled ? Colors.colors.on_primary : root.textColor
            font.family: root.font.family
            font.pixelSize: !root.toggleSize ? root.font.pixelSize : root.toggled ? root.font.pixelSize : root.font.pixelSize - Math.round(root.font.pixelSize / 6)
            font.weight: Font.Normal
        }
    }
    Component {
        id: text
        Text {
            text: root.label
            color: root.toggled ? Colors.colors.on_primary : root.textColor
            font.family: root.font.family
            font.pixelSize: !root.toggleSize ? root.font.pixelSize : root.toggled ? root.font.pixelSize : root.font.pixelSize - Math.round(root.font.pixelSize / 6)
            font.weight: Font.Normal
        }
    }
}
