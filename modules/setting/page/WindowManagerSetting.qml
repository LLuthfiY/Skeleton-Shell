import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell

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
            icon: "app-window"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.title
            font.weight: Font.Bold
            label: "Window Manager"
        }
        LucideIcon {
            icon: "layout-panel-left"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.small
            font.weight: Font.DemiBold
            font.family: Variable.font.family.main
            label: "Size"
        }

        RowLayout {
            Layout.preferredWidth: root.width
            Text {
                text: "Workspaces"
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                color: Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.smaller
            }
            Item {
                Layout.fillWidth: true
            }
            StyledStepper {
                value: Config.options.windowManager.workspaces
                min: 0
                max: 10000
                step: 1
                onValueChanged: {
                    Config.options.windowManager.workspaces = value;
                    WindowManagerUtils.setWM(100);
                }
            }
        }
        RowLayout {
            Layout.preferredWidth: root.width
            Text {
                text: "Gaps Out"
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                color: Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.smaller
            }
            Item {
                Layout.fillWidth: true
            }
            StyledStepper {
                value: Config.options.windowManager.gapsOut
                min: 0
                max: 10000
                step: 1
                onValueChanged: {
                    Config.options.windowManager.gapsOut = value;
                    WindowManagerUtils.setWM(100);
                }
            }
        }
        RowLayout {
            Layout.preferredWidth: root.width
            Text {
                text: "Gaps In"
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                color: Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.smaller
            }
            Item {
                Layout.fillWidth: true
            }
            StyledStepper {
                value: Config.options.windowManager.gapsIn
                min: 0
                max: 10000
                step: 1
                onValueChanged: {
                    Config.options.windowManager.gapsIn = value;
                    WindowManagerUtils.setWM(100);
                }
            }
        }
        RowLayout {
            Layout.preferredWidth: root.width
            Text {
                text: "Active Opacity"
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                color: Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.smaller
            }
            Item {
                Layout.fillWidth: true
            }
            StyledStepper {
                value: Config.options.windowManager.activeOpacity
                min: 0
                max: 1
                step: 0.1
                onValueChanged: {
                    Config.options.windowManager.activeOpacity = value;
                    WindowManagerUtils.setWM(100);
                }
            }
        }
        RowLayout {
            Layout.preferredWidth: root.width
            Text {
                text: "Inactive Opacity"
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                color: Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.smaller
            }
            Item {
                Layout.fillWidth: true
            }
            StyledStepper {
                value: Config.options.windowManager.inactiveOpacity
                min: 0
                max: 1
                step: 0.1
                onValueChanged: {
                    Config.options.windowManager.inactiveOpacity = value;
                    WindowManagerUtils.setWM(100);
                }
            }
        }
        RowLayout {
            Layout.preferredWidth: root.width
            Text {
                text: "Window Border Size"
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                color: Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.smaller
            }
            Item {
                Layout.fillWidth: true
            }
            StyledStepper {
                value: Config.options.windowManager.windowBorderSize
                min: 0
                max: 10000
                step: 1
                onValueChanged: {
                    Config.options.windowManager.windowBorderSize = value;
                    WindowManagerUtils.setWM(100);
                }
            }
        }
        RowLayout {
            Layout.preferredWidth: root.width
            Text {
                text: "Window Border Radius"
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                color: Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.smaller
            }
            Item {
                Layout.fillWidth: true
            }
            StyledStepper {
                value: Config.options.windowManager.windowBorderRadius
                min: 0
                max: 10000
                step: 1
                onValueChanged: {
                    Config.options.windowManager.windowBorderRadius = value;
                    WindowManagerUtils.setWM(100);
                }
            }
        }
    }
}
