import QtQuick
import QtQuick.Layouts

import Quickshell

import qs.modules.common
import qs.modules.common.widgets
import qs.services

ColumnLayout {
    id: root
    anchors.fill: parent
    spacing: Variable.margin.small
    Rectangle {
        Layout.fillWidth: true
        height: Variable.size.larger
        color: "transparent"
        RowLayout {
            anchors.fill: parent
            spacing: Variable.margin.small
            Text {
                text: "Notifications"
                font.pixelSize: Variable.font.pixelSize.normal
                color: Color.colors.on_surface
                font.weight: Font.Bold
                font.family: Variable.font.family.main
            }
            Item {
                Layout.fillWidth: true
            }
            Rectangle {
                id: clearButton
                width: Variable.size.larger
                height: Variable.size.larger
                radius: Variable.radius.small
                color: hoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface
                // border.color: hoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
                // border.width: Variable.uiScale(2)
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                // Behavior on border.color {
                //     ColorAnimation {
                //         duration: 200
                //     }
                // }
                TapHandler {
                    onTapped: {
                        Notification.discardAllNotifications();
                    }
                }
                HoverHandler {
                    id: hoverHandler
                }
                LucideIcon {
                    icon: "trash"
                    // color: hoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                    color: Color.colors.error
                    anchors.centerIn: parent
                }
            }
        }
    }
    ListView {
        id: listView
        model: ScriptModel {
            values: [...Notification.listSorted]
        }
        clip: true
        Layout.fillWidth: true
        Layout.fillHeight: true
        width: parent.width
        spacing: Variable.margin.small
        property real lastY: 0

        delegate: NotificationItem {
            notificationObject: modelData
            isPopup: false
        }
    }
}
