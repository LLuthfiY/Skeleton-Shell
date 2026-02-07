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
    width: Variable.sizes.notificationPopupWidth
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
        border.width: 1
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
            Layout.preferredWidth: Variable.sizes.notificationPopupWidth - 16
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
                font.pixelSize: 12
                font.family: Variable.font.family.main
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: 8
            }
        }

        RowLayout {
            spacing: 16
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: Variable.margin.small

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
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    font.pixelSize: 12
                    font.family: Variable.font.family.main
                    font.bold: true
                    color: Color.colors.on_surface
                    clip: true
                    Layout.preferredWidth: 250
                    wrapMode: Text.Wrap
                }

                Label {
                    id: body
                    text: notificationObject.body
                    Layout.preferredWidth: parent.width
                    Layout.alignment: Qt.AlignVCenter
                    font.pixelSize: 12
                    font.family: Variable.font.family.main
                    color: Color.colors.on_surface_variant
                    wrapMode: Text.Wrap
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
                    color: hovered ? Color.colors.primary_container : Color.colors.surface
                    border.color: Color.colors.primary_container
                    border.width: 1
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                    Text {
                        id: buttonText
                        text: modelData.text
                        color: Color.colors.on_surface
                        font.pixelSize: 12
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
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
