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
    width: Variable.sizes.notificationPopupWidth - 100
    implicitHeight: content.implicitHeight

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

    Rectangle {
        id: background
        anchors.fill: parent
        color: Color.colors.surface_container_high

        radius: 16
    }

    ColumnLayout {
        id: content
        spacing: 0
        Rectangle {
            id: appNameBackground

            color: Color.colors.surface_container
            Layout.preferredWidth: Variable.sizes.notificationPopupWidth - 100 - 16
            Layout.alignment: Qt.AlignTop
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 8
            radius: 8
            Layout.preferredHeight: appName.implicitHeight + 8
            Text {
                id: appName
                text: notificationObject.appName ?? "System"
                color: Color.colors.on_surface
                font.pointSize: 12
                font.family: Variable.font.family.main
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: 8
            }
            Rectangle {
                id: closeButtonBackground
                color: Color.colors.surface_container
                width: 16
                height: 16
                radius: 8
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 8

                LucideIcon {
                    id: closeIcon
                    icon: "x"
                    color: Color.colors.on_surface
                    font.pixelSize: Variable.font.pixelSize.normal
                    font.bold: true
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.notificationObject.popup) {
                            Notification.timeoutNotification(notificationObject.notificationId);
                        } else {
                            Notification.discardNotification(notificationObject.notificationId);
                        }
                    }
                }
            }
        }

        RowLayout {
            spacing: 16
            Layout.fillWidth: true
            Layout.margins: 16

            NotificationAppIcon {
                id: appIcon
                notificationObject: root.notificationObject
                Layout.preferredWidth: Variable.sizes.notificationAppIconSize
                Layout.preferredHeight: Variable.sizes.notificationAppIconSize
                Layout.alignment: Qt.AlignTop
            }
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                Label {
                    id: summary
                    text: notificationObject.summary
                    elide: Text.ElideRight
                    Layout.alignment: Qt.AlignVCenter
                    font.pointSize: 12
                    font.family: Variable.font.family.main
                    font.bold: true
                    color: Color.colors.on_surface
                    clip: true
                }

                Label {
                    id: body
                    text: notificationObject.body
                    Layout.preferredWidth: parent.width - 64
                    Layout.alignment: Qt.AlignVCenter
                    font.pointSize: 10
                    font.family: Variable.font.family.main
                    color: Color.colors.on_surface_variant
                    wrapMode: Text.WordWrap
                }

                // Loader {
                //     id: imageLoader
                //     active: notificationObject.appName === "grimblast"
                //     sourceComponent: imageComponent
                // }
                // Component {
                //     id: imageComponent
                //     Image {
                //         id: image
                //         source: notificationObject.image
                //         width: 300
                //         height: 200
                //         fillMode: Image.PreserveAspectCrop
                //     }
                // }
            }
        }
        Flow {
            id: actionsFlow
            Layout.fillWidth: true
            Layout.preferredWidth: Variable.sizes.notificationPopupWidth - 16

            Layout.margins: 8
            Layout.preferredHeight: childrenRect.height
            spacing: 8
            clip: true
            onWidthChanged: {
                actionsFlow.forceLayout();
            }
            Repeater {
                model: notificationObject.actions
                delegate: Rectangle {
                    property bool hovered: false

                    width: buttonText.implicitWidth + 16
                    height: buttonText.implicitHeight + 8
                    radius: 8
                    color: hovered ? Color.colors.surface_container : Color.colors.surface
                    Text {
                        id: buttonText
                        text: modelData.text
                        color: Color.colors.on_surface
                        font.pointSize: 12
                        font.family: Variable.font.family.main
                        font.bold: true
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            hovered = true;
                        }
                        onExited: {
                            hovered = false;
                        }
                        onClicked: {
                            Notification.attemptInvokeAction(notificationObject.notificationId, modelData.identifier);
                        }
                    }
                }
            }
        }
    }
}
