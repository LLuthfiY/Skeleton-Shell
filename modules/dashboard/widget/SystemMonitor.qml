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
    height: 82 * Config.options.appearance.uiScale
    radius: Variable.radius.small
    Layout.fillWidth: true
    Rectangle {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 2 * Config.options.appearance.uiScale
        height: parent.height / 2
        color: Color.colors.primary_container
        radius: Variable.radius.small
    }
    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: Variable.margin.normal
        spacing: Variable.margin.small

        RowLayout {
            spacing: Variable.margin.small
            LucideIcon {
                icon: "cpu"
                color: Color.colors.on_surface_variant
                font.pixelSize: Variable.font.pixelSize.normal
            }
            Rectangle {
                Layout.fillWidth: true
                color: "transparent"
                Layout.preferredHeight: Variable.size.normal
                Rectangle {
                    color: Color.colors.primary_container
                    radius: Variable.radius.small
                    width: parent.width
                    height: 2 * Config.options.appearance.uiScale
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: parent.width * CPU.cpuUsage / 100
                    height: Variable.size.small
                    color: Color.colors.primary
                    radius: Variable.radius.small
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        RowLayout {
            spacing: Variable.margin.small
            LucideIcon {
                icon: "memory-stick"
                color: Color.colors.on_surface_variant
                font.pixelSize: Variable.font.pixelSize.normal
            }
            Rectangle {
                Layout.fillWidth: true
                color: "transparent"
                Layout.preferredHeight: Variable.size.small
                Rectangle {
                    color: Color.colors.primary_container
                    radius: Variable.radius.small
                    width: parent.width
                    height: 2 * Config.options.appearance.uiScale
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: parent.width * RAM.ramUsage / 100
                    height: Variable.size.small
                    color: Color.colors.primary
                    radius: Variable.radius.small
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
