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
                property bool isHovered: false
                width: Variable.size.larger
                height: Variable.size.larger
                radius: Variable.radius.small
                color: isHovered ? Color.colors.primary : "transparent"
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        clearButton.isHovered = true;
                    }
                    onExited: {
                        clearButton.isHovered = false;
                    }
                    onClicked: {
                        Notification.discardAllNotifications();
                    }
                }
                LucideIcon {
                    icon: "trash"
                    color: clearButton.isHovered ? Color.colors.on_primary : Color.colors.primary
                    anchors.centerIn: parent
                }
            }
        }
    }
    ListView {
        id: listView
        model: Notification.list.sort((a, b) => b.time - a.time)
        clip: true
        Layout.fillWidth: true
        Layout.fillHeight: true
        width: parent.width
        spacing: Variable.margin.small
        property real lastY: 0

        onContentYChanged: {
            if (!moving) {
                listView.contentY = Math.max(0, Math.min(listView.lastY, listView.contentHeight - listView.height)) + listView.originY;
            }
            listView.lastY = listView.contentY - listView.originY;
        }
        delegate: NotificationHistoryItem {
            notificationObject: modelData
        }
    }
}
