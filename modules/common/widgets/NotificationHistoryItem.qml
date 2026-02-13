import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

Item {
    id: root
    property var notificationObject
    property bool pendingClose: notificationObject.pendingClose
    width: listView.width
    implicitHeight: content.implicitHeight
    clip: true

    Rectangle {
        id: background
        anchors.fill: parent
        color: Color.colors.surface
        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: {
                root.opacity = 0;
                root.implicitHeight = 0;
                closeTimer.start();
            }
        }
        Rectangle {
            anchors.right: parent.right
            width: Variable.size.smallest / 2
            height: parent.height - (48 * Config.options.appearance.uiScale)
            radius: Variable.radius.smallest
            anchors.verticalCenter: parent.verticalCenter
            color: Color.colors.primary_container
        }
    }
    Behavior on opacity {
        OpacityAnimator {
            duration: 200
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
        }
    }

    Timer {
        id: closeTimer
        interval: 210
        onTriggered: {
            Notification.discardNotification(notificationObject.notificationId);
        }
    }

    ColumnLayout {
        id: content
        spacing: 0
        width: parent.width
        Rectangle {
            id: appNameBackground

            color: "transparent"
            Layout.preferredWidth: parent.width - (16 * Config.options.appearance.uiScale)
            Layout.alignment: Qt.AlignTop
            Layout.leftMargin: Variable.margin.normal
            Layout.rightMargin: Variable.margin.normal
            radius: Variable.radius.normal
            Layout.preferredHeight: appName.implicitHeight + (8 * Config.options.appearance.uiScale)
            Text {
                id: appName
                text: notificationObject.appName ?? "System"
                color: Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.small
                font.family: Variable.font.family.main
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: Variable.margin.normal
            }
            Text {
                id: time
                text: Time.formatTime(notificationObject.time)
                color: Color.colors.on_surface_variant
                font.pixelSize: Variable.font.pixelSize.smaller
                font.family: Variable.font.family.main
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.margins: Variable.margin.normal
            }
        }

        RowLayout {
            spacing: Variable.margin.small
            Layout.fillWidth: true
            Layout.leftMargin: Variable.margin.normal
            Layout.rightMargin: Variable.margin.normal

            NotificationAppIcon {
                id: appIcon
                notificationObject: root.notificationObject
                Layout.preferredWidth: Variable.size.notificationAppIconSize
                Layout.preferredHeight: Variable.size.notificationAppIconSize
                Layout.alignment: Qt.AlignTop
            }
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                clip: true

                Text {
                    id: summary
                    text: notificationObject.summary
                    Layout.alignment: Qt.AlignVCenter
                    font.pixelSize: Variable.font.pixelSize.smaller
                    font.family: Variable.font.family.main
                    font.bold: true
                    color: Color.colors.on_surface
                    clip: true
                    wrapMode: Text.Wrap
                    Layout.preferredWidth: Variable.size.notificationHistoryWidth
                }

                Text {
                    id: body
                    text: notificationObject.body
                    Layout.alignment: Qt.AlignVCenter
                    font.pixelSize: Variable.font.pixelSize.smaller
                    font.family: Variable.font.family.main
                    color: Color.colors.on_surface_variant
                    wrapMode: Text.Wrap
                    Layout.preferredWidth: Variable.size.notificationHistoryWidth
                }
            }
        }
        Flow {
            id: actionsFlow
            Layout.fillWidth: true
            Layout.preferredWidth: Variable.size.notificationPopupWidth - (16 * Config.options.appearance.uiScale)
            Layout.margins: notificationObject.actions.length > 0 ? Variable.margin.small : 0
            Layout.bottomMargin: notificationObject.actions.length > 0 ? Variable.margin.small : Variable.margin.small
            Layout.preferredHeight: childrenRect.height
            spacing: Variable.margin.small
            clip: true
            onWidthChanged: {
                actionsFlow.forceLayout();
            }
            Repeater {
                model: notificationObject.actions
                delegate: Rectangle {

                    width: buttonText.implicitWidth + (16 * Config.options.appearance.uiScale)
                    height: buttonText.implicitHeight + (8 * Config.options.appearance.uiScale)
                    radius: Variable.radius.small
                    color: hoverHandler.hovered ? Color.colors.primary_container : Color.colors.surface
                    border.color: Color.colors.primary_container
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                    Text {
                        id: buttonText
                        text: modelData.text
                        color: Color.colors.on_surface
                        font.pixelSize: Variable.font.pixelSize.smallest
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
                        anchors.centerIn: parent
                    }
                    TapHandler {
                        onTapped: {
                            Notification.attemptInvokeAction(notificationObject.notificationId, modelData.identifier);
                        }
                    }
                    HoverHandler {
                        id: hoverHandler
                    }
                }
            }
        }
    }
}
