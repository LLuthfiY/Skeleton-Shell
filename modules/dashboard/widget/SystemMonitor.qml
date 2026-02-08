import QtQuick
import QtQuick.Layouts

import Quickshell

import qs.modules.common
import qs.modules.common.widgets
import qs.services

Rectangle {
    id: root
    color: "transparent"
    // border.color: Color.colors.primary_container
    // border.width: 2
    width: parent.width
    height: 82
    radius: Variable.radius.small
    Layout.fillWidth: true
    Rectangle {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 2
        height: parent.height / 2
        color: Color.colors.primary_container
        radius: Variable.radius.small
    }
    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8
        RowLayout {
            spacing: 8
            LucideIcon {
                icon: "cpu"
                color: Color.colors.on_surface_variant
                font.pixelSize: 20
            }
            Rectangle {
                Layout.fillWidth: true
                color: "transparent"
                Layout.preferredHeight: 8
                Rectangle {
                    color: Color.colors.primary_container
                    radius: Variable.radius.small
                    width: parent.width
                    height: 2
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: parent.width * CPU.cpuUsage / 100
                    height: 8
                    color: Color.colors.primary
                    radius: Variable.radius.small
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        RowLayout {
            spacing: 8
            LucideIcon {
                icon: "memory-stick"
                color: Color.colors.on_surface_variant
                font.pixelSize: 20
            }
            Rectangle {
                Layout.fillWidth: true
                color: "transparent"
                Layout.preferredHeight: 8
                Rectangle {
                    color: Color.colors.primary_container
                    radius: Variable.radius.small
                    width: parent.width
                    height: 2
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: parent.width * RAM.ramUsage / 100
                    height: 8
                    color: Color.colors.primary
                    radius: Variable.radius.small
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
