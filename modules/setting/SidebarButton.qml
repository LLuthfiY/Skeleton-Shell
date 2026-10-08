import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

Rectangle {
    Layout.preferredHeight: Variable.size.larger
    Layout.preferredWidth: Variable.uiScale(200)
    Layout.fillWidth: true
    color: "transparent"
    Rectangle {
        anchors.left: parent.left
        // width: root.section === index ? parent.width : hoverHandler.hovered ? parent.width : 2
        width: parent.width
        color: root.section === index ? Colors.colors.primary : sidebarHoverHandler.hovered ? Colors.colors.primary_container : Colors.colors.surface
        HoverHandler {
            id: sidebarHoverHandler
        }
        height: parent.height
        radius: Variable.radius.large
        Behavior on width {
            NumberAnimation {
                duration: 200
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }

    LucideIcon {
        icon: modelData.icon
        color: root.section === index ? Colors.colors.on_primary : Colors.colors.on_surface
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.margins: Variable.margin.small
        label: modelData.text
        font.weight: Font.Normal
        font.family: Variable.font.family.main
        font.pixelSize: Variable.font.pixelSize.normal
    }
    TapHandler {
        onTapped: {
            root.section = index;
        }
    }
    HoverHandler {
        id: hoverHandler
    }
}
