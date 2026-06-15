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
    height: Variable.uiScale(82)
    radius: Variable.radius.small
    Layout.fillWidth: true

    RowLayout {
        anchors.fill: parent
        spacing: Variable.margin.normal

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height
            color: Color.colors.surface_container
            radius: Variable.radius.normal

            RowLayout {
                anchors.fill: parent
                spacing: Variable.margin.small
                anchors.margins: Variable.margin.normal

                CircularProgress {
                    id: cpuUsage
                    value: CPU.cpuUsage / 100
                    colPrimary: Color.colors.primary
                    colSecondary: Color.colors.primary_container
                    enableAnimation: false
                }

                ColumnLayout {
                    spacing: Variable.margin.small
                    LucideIcon {
                        icon: "cpu"
                        label: "CPU"
                        font.pixelSize: Variable.font.pixelSize.normal
                        color: Color.colors.on_surface
                        font.weight: Font.Bold
                        font.family: Variable.font.family.main
                    }
                    Text {
                        text: CPU.cpuUsage + "%"
                        font.pixelSize: Variable.font.pixelSize.small
                        color: Color.colors.on_surface_variant
                        font.weight: Font.Normal
                        font.family: Variable.font.family.main
                    }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height
            color: Color.colors.surface_container
            radius: Variable.radius.normal
            RowLayout {
                anchors.fill: parent
                spacing: Variable.margin.small
                anchors.margins: Variable.margin.normal

                CircularProgress {
                    id: ramUsage
                    value: RAM.ramUsage / 100
                    colPrimary: Color.colors.primary
                    colSecondary: Color.colors.primary_container
                    enableAnimation: false
                }

                ColumnLayout {
                    spacing: Variable.margin.small
                    LucideIcon {
                        icon: "memory-stick"
                        label: "RAM"
                        font.pixelSize: Variable.font.pixelSize.normal
                        color: Color.colors.on_surface
                        font.weight: Font.Bold
                        font.family: Variable.font.family.main
                    }
                    Text {
                        text: RAM.ramUsage + "%"
                        font.pixelSize: Variable.font.pixelSize.small
                        color: Color.colors.on_surface_variant
                        font.weight: Font.Normal
                        font.family: Variable.font.family.main
                    }
                }
            }
        }
    }
}
