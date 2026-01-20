import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.services
import qs.modules.common
import qs.modules.common.functions

Item {
    id: root
    property var notificationObject
    property bool pendingClose: notificationObject.pendingClose
    width: Variable.sizes.notificationPopupWidth
    implicitHeight: 0

    opacity: 0
    onPendingCloseChanged: {
        opacity = 0;
        implicitHeight = 0;
        closeTimer.start();
    }

    // todo : make other item animated to y when this item destroyed

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
            easing.type: Easing.OutBack
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

        RowLayout {
            spacing: 16
            Layout.fillWidth: true
            Layout.margins: 16

            Image {
                id: icon
                source: notificationObject.image
                Layout.preferredWidth: 64
                Layout.preferredHeight: 64
                Layout.alignment: Qt.AlignVCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                Label {
                    id: summary
                    text: notificationObject.summary
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    font.pointSize: 12
                    font.family: Variable.font.family.main
                    font.bold: true
                    color: Color.colors.on_surface
                }

                Label {
                    id: body
                    text: notificationObject.body
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    font.pointSize: 10
                    font.family: Variable.font.family.main
                    color: Color.colors.on_surface_variant
                }
            }
        }
    }
}
