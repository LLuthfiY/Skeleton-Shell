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
    width: Variable.size.notificationPopupWidth
    implicitHeight: 0
    clip: true

    opacity: 0
    onPendingCloseChanged: {
        opacity = 0;
        implicitHeight = 0;
        closeTimer.start();
    }

    Timer {
        id: closeTimer
        interval: 210
        onTriggered: {
            notificationObject.popup = false;
        }
    }

    Component.onCompleted: {
        opacity = 1;
        implicitHeight = content.implicitHeight;
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Color.colors.surface
        border.color: Color.colors.primary_container
        border.width: Variable.uiScale(1)
        radius: Variable.radius.small
        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: {
                root.opacity = 0;
                root.implicitHeight = 0;
                closeTimer.start();
            }
        }
    }

    ColumnLayout {
        id: content
        spacing: 0
        Rectangle {
            id: appNameBackground

            color: "transparent"
            Layout.preferredWidth: Variable.size.notificationPopupWidth - (Variable.uiScale(16))
            Layout.alignment: Qt.AlignTop
            Layout.leftMargin: Variable.margin.normal
            Layout.rightMargin: Variable.margin.normal
            Layout.topMargin: Variable.margin.small
            radius: Variable.radius.normal
            Layout.preferredHeight: appName.implicitHeight + (Variable.uiScale(8))
            Text {
                id: appName
                text: notificationObject.appName ?? "System"
                color: Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.normal
                font.family: Variable.font.family.main
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: Variable.margin.normal
            }
        }

        RowLayout {
            spacing: Variable.margin.normal
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

                Label {
                    id: summary
                    text: notificationObject.summary
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    font.pixelSize: Variable.font.pixelSize.small
                    font.family: Variable.font.family.main
                    font.bold: true
                    color: Color.colors.on_surface
                    clip: true
                    Layout.preferredWidth: Variable.size.notificationPopupWidth - (Variable.uiScale(16))
                    wrapMode: Text.Wrap
                }

                Label {
                    id: body
                    text: notificationObject.body
                    Layout.preferredWidth: parent.width
                    Layout.alignment: Qt.AlignVCenter
                    font.pixelSize: Variable.font.pixelSize.small
                    font.family: Variable.font.family.main
                    color: Color.colors.on_surface_variant
                    wrapMode: Text.Wrap
                }
            }
        }
        Flow {
            id: actionsFlow
            Layout.fillWidth: true
            Layout.preferredWidth: Variable.size.notificationPopupWidth - (Variable.uiScale(16))

            Layout.margins: Variable.margin.small
            Layout.preferredHeight: childrenRect.height
            spacing: Variable.margin.normal
            clip: true
            onWidthChanged: {
                actionsFlow.forceLayout();
            }
            Repeater {
                model: notificationObject.actions
                delegate: Rectangle {

                    width: buttonText.implicitWidth + (Variable.uiScale(16))
                    height: buttonText.implicitHeight + (Variable.uiScale(8))
                    radius: Variable.radius.small
                    color: hoverHandler.hovered ? Color.colors.primary_container : Color.colors.surface
                    border.color: Color.colors.primary_container
                    border.width: Variable.uiScale(1)
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
