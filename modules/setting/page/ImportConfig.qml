import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic

import Quickshell
import Quickshell.Io

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

ColumnLayout {
    id: root
    spacing: 8
    width: stackWrapper.width - 24
    LucideIcon {
        icon: "download"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.title
        font.weight: Font.Bold
        font.family: Variable.font.family.main
        label: "Import Config"
    }
    LucideIcon {
        icon: "package"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.small
        font.weight: Font.DemiBold
        font.family: Variable.font.family.main
        label: "Import Config"
    }
    RowLayout {
        TextField {
            id: importConfigFieldText
            Layout.fillWidth: true
            background: Rectangle {
                color: Color.colors.surface
                radius: Variable.radius.small
                border.color: importConfigFieldText.focus ? Color.colors.primary : Color.colors.surface_container
                border.width: 2
            }
        }
        Rectangle {
            Layout.preferredHeight: importConfigButtonIcon.implicitHeight + Variable.margin.small
            Layout.preferredWidth: importConfigButtonIcon.implicitWidth + Variable.margin.normal
            color: importConfigButtonHoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface
            radius: Variable.radius.small
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            HoverHandler {
                id: importConfigButtonHoverHandler
            }
            LucideIcon {
              id: importConfigButtonIcon
                anchors.centerIn: parent
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                font.pixelSize: Variable.font.pixelSize.small
                color: Color.colors.on_surface
                icon: "download"
                label: "Import"
            }
        }
    }
}
