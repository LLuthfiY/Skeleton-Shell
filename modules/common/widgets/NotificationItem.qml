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
    property real uiScale: Config.options.appearance.uiScale
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
        border.width: 1 * root.uiScale
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
            Layout.preferredWidth: Variable.size.notificationPopupWidth - (16 * root.uiScale)
            Layout.alignment: Qt.AlignTop
            Layout.leftMargin: Variable.margin.normal
            Layout.rightMargin: Variable.margin.normal
            Layout.topMargin: Variable.margin.normal
            radius: Variable.radius.normal
            Layout.preferredHeight: appName.implicitHeight + (8 * root.uiScale)
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
                    font.pixelSize: Variable.font.pixelSize.normal
                    font.family: Variable.font.family.main
                    font.bold: true
                    color: Color.colors.on_surface
                    clip: true
                    Layout.preferredWidth: Variable.size.notificationPopupWidth - (16 * root.uiScale)
                    wrapMode: Text.Wrap
                }

                Label {
                    id: body
                    text: notificationObject.body
                    Layout.preferredWidth: parent.width
                    Layout.alignment: Qt.AlignVCenter
                    font.pixelSize: Variable.font.pixelSize.normal
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
            Layout.preferredWidth: Variable.size.notificationPopupWidth - (16 * root.uiScale)

            Layout.margins: notificationObject.actions.length > 0 ? Variable.margin.small : 0
            Layout.bottomMargin: notificationObject.actions.length > 0 ? Variable.margin.small : Variable.margin.small
            Layout.preferredHeight: childrenRect.height
            spacing: Variable.margin.normal
            clip: true
            onWidthChanged: {
                actionsFlow.forceLayout();
            }
            Repeater {
                model: notificationObject.actions
                delegate: Rectangle {
                    property bool hovered: false

                    width: buttonText.implicitWidth + (16 * root.uiScale)
                    height: buttonText.implicitHeight + (8 * root.uiScale)
                    radius: Variable.radius.small
                    color: hovered ? Color.colors.primary_container : Color.colors.surface
                    border.color: Color.colors.primary_container
                    border.width: 1 * root.uiScale
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
