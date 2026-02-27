import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell
import Quickshell.Io

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

ScrollView {
    clip: true
    height: parent.height
    width: parent.width
    ColumnLayout {
        id: root
        spacing: 8
        width: stackWrapper.width - 24
        LucideIcon {
            icon: "component"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.title
            font.weight: Font.Bold
            font.family: Variable.font.family.main
            label: "Modules"
        }
        LucideIcon {
            icon: "package"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.small
            font.weight: Font.Bold
            font.family: Variable.font.family.main
            label: "Default Modules"
        }
        RowLayout {
            spacing: 8
            LucideIcon {
                icon: "dock"
                color: Color.colors.on_surface_variant
                font.pixelSize: Variable.font.pixelSize.smaller
                font.weight: Font.Normal
                font.family: Variable.font.family.main
                label: "Bar"
            }
            Item {
                Layout.fillWidth: true
            }
            StyledSwitch {
                checked: Config.options.modules.bar
                implicitWidth: 40
                implicitHeight: 20
                Layout.preferredHeight: 20
                height: 20
                onCheckedChanged: {
                    Config.options.modules.bar = checked;
                    WindowManagerUtils.setWM();
                }
            }
        }
        RowLayout {
            spacing: 8
            LucideIcon {
                icon: "image"
                color: Color.colors.on_surface_variant
                font.pixelSize: Variable.font.pixelSize.smaller
                font.weight: Font.Normal
                font.family: Variable.font.family.main
                label: "Background"
            }
            Item {
                Layout.fillWidth: true
            }
            StyledSwitch {
                checked: Config.options.modules.background
                implicitWidth: 40
                implicitHeight: 20
                Layout.preferredHeight: 20
                height: 20
                onCheckedChanged: {
                    Config.options.modules.background = checked;
                    WindowManagerUtils.setWM();
                }
            }
        }
        RowLayout {
            spacing: 8
            LucideIcon {
                icon: "message-circle"
                color: Color.colors.on_surface_variant
                font.pixelSize: Variable.font.pixelSize.smaller
                font.weight: Font.Normal
                font.family: Variable.font.family.main
                label: "Notification"
            }
            Item {
                Layout.fillWidth: true
            }
            StyledSwitch {
                checked: Config.options.modules.notification
                implicitWidth: 40
                implicitHeight: 20
                Layout.preferredHeight: 20
                height: 20
                onCheckedChanged: {
                    Config.options.modules.notification = checked;
                    WindowManagerUtils.setWM();
                }
            }
        }
        RowLayout {
            spacing: 8
            LucideIcon {
                icon: "music"
                color: Color.colors.on_surface_variant
                font.pixelSize: Variable.font.pixelSize.smaller
                font.weight: Font.Normal
                font.family: Variable.font.family.main
                label: "Media Player"
            }
            Item {
                Layout.fillWidth: true
            }
            StyledSwitch {
                checked: Config.options.modules.mediaPlayer
                implicitWidth: 40
                implicitHeight: 20
                Layout.preferredHeight: 20
                height: 20
                onCheckedChanged: {
                    Config.options.modules.mediaPlayer = checked;
                    WindowManagerUtils.setWM();
                }
            }
        }
        RowLayout {
            spacing: 8
            LucideIcon {
                icon: "monitor"
                color: Color.colors.on_surface_variant
                font.pixelSize: Variable.font.pixelSize.smaller
                font.weight: Font.Normal
                font.family: Variable.font.family.main
                label: "Overview"
            }
            Item {
                Layout.fillWidth: true
            }
            StyledSwitch {
                checked: Config.options.modules.overview
                implicitWidth: 40
                implicitHeight: 20
                Layout.preferredHeight: 20
                height: 20
                onCheckedChanged: {
                    Config.options.modules.overview = checked;
                    WindowManagerUtils.setWM();
                }
            }
        }
        RowLayout {
            spacing: 8
            LucideIcon {
                icon: "circle-x"
                color: Color.colors.on_surface_variant
                font.pixelSize: Variable.font.pixelSize.smaller
                font.weight: Font.Normal
                font.family: Variable.font.family.main
                label: "Popup Closer"
            }
            Item {
                Layout.fillWidth: true
            }
            StyledSwitch {
                checked: Config.options.modules.popupCloser
                implicitWidth: 40
                implicitHeight: 20
                Layout.preferredHeight: 20
                height: 20
                onCheckedChanged: {
                    Config.options.modules.popupCloser = checked;
                    WindowManagerUtils.setWM();
                }
            }
        }
        RowLayout {
            spacing: 8
            LucideIcon {
                icon: "layout-dashboard"
                color: Color.colors.on_surface_variant
                font.pixelSize: Variable.font.pixelSize.smaller
                font.weight: Font.Normal
                font.family: Variable.font.family.main
                label: "Dashboard"
            }
            Item {
                Layout.fillWidth: true
            }
            StyledSwitch {
                checked: Config.options.modules.dashboard
                implicitWidth: 40
                implicitHeight: 20
                Layout.preferredHeight: 20
                height: 20
                onCheckedChanged: {
                    Config.options.modules.dashboard = checked;
                    WindowManagerUtils.setWM();
                }
            }
        }
        LucideIcon {
            icon: "package"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.small
            font.weight: Font.DemiBold
            font.family: Variable.font.family.main
            label: "Custom Modules"
        }
        WidgetListWithFill {
            id: customModules
            fill: false
            items: Config.options.modules.enabled
            width: root.width
            path: Directory.shell + "/modules/user"
            listUserPath: false
            onItemsChanged: {
                Config.options.modules.enabled = items;
            }
        }
    }
}
