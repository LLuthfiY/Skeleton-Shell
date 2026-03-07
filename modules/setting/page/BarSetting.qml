import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

// ScrollView {
//     clip: true
//     height: parent.height
//     width: parent.width * Config.options.appearance.uiScale
ColumnLayout {
    id: root
    spacing: Variable.margin.small
    width: stackWrapper.width - Variable.uiScale(32)
    // height: parent.height
    LucideIcon {
        icon: "layout-panel-left"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.title
        font.weight: Font.Bold
        font.family: Variable.font.family.main
        label: "Bar"
    }
    LucideIcon {
        icon: "layout-panel-left"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.small
        font.weight: Font.DemiBold
        font.family: Variable.font.family.main
        label: "Background"
    }
    Flow {
        spacing: Variable.margin.small
        Layout.preferredWidth: root.width
        Repeater {
            model: ["surface", "surface_container", "surface_container_high", "on_surface", "primary", "primary_container", "on_primary", "secondary", "secondary_container", "on_secondary", "tertiary", "tertiary_container", "on_tertiary", "error", "error_container", "on_error", "transparent"]

            delegate: ToggleButton {
                toggled: Config.options.bar.background === modelData
                label: modelData
                font.pixelSize: Variable.font.pixelSize.small
                font.weight: Font.Normal
                font.family: Variable.font.family.main
                toggleOpacity: true
                TapHandler {
                    onTapped: {
                        Config.options.bar.background = modelData;
                        WindowManagerUtils.setWM();
                    }
                }
            }
        }
    }
    LucideIcon {
        icon: "layout-panel-left"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.small
        font.weight: Font.DemiBold
        font.family: Variable.font.family.main
        label: "Foreground"
    }

    Flow {
        spacing: Variable.margin.small
        Layout.preferredWidth: root.width
        Repeater {
            model: ["surface", "surface_container", "surface_container_high", "on_surface", "primary", "primary_container", "on_primary", "secondary", "secondary_container", "on_secondary", "tertiary", "tertiary_container", "on_tertiary", "error", "error_container", "on_error"]
            delegate: ToggleButton {
                toggled: Config.options.bar.foreground === modelData
                label: modelData
                font.pixelSize: Variable.font.pixelSize.small
                font.weight: Font.Normal
                font.family: Variable.font.family.main
                toggleOpacity: true
                TapHandler {
                    onTapped: {
                        Config.options.bar.foreground = modelData;
                    }
                }
            }
        }
    }
    LucideIcon {
        icon: "layout-panel-left"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.small
        font.weight: Font.DemiBold
        font.family: Variable.font.family.main
        label: "Position"
    }
    RowLayout {
        spacing: Variable.margin.small
        Repeater {
            model: ["left", "top", "right", "bottom"]
            delegate: ToggleButton {
                toggled: Config.options.bar.position === modelData
                label: modelData
                icon: modelData === "left" ? "arrow-left" : modelData === "right" ? "arrow-right" : modelData === "top" ? "arrow-up" : modelData === "bottom" ? "arrow-down" : ""
                font.pixelSize: Variable.font.pixelSize.small
                font.weight: Font.Normal
                font.family: Variable.font.family.main
                toggleOpacity: true
                TapHandler {
                    onTapped: {
                        Config.options.bar.position = modelData;
                        WindowManagerUtils.setWM();
                    }
                }
            }
        }
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
            text: "Full Width"
            font.family: Variable.font.family.main
            font.weight: Font.Normal
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.smaller
        }
        Item {
            Layout.fillWidth: true
        }
        StyledSwitch {
            checked: Config.options.bar.fullWidth
            implicitWidth: 40
            implicitHeight: 20
            Layout.preferredHeight: 20
            height: 20
            onCheckedChanged: {
                Config.options.bar.fullWidth = checked;
                WindowManagerUtils.setWM();
            }
        }
    }
    RowLayout {
        Layout.preferredWidth: root.width
        Text {
            text: "Border Screen"
            font.family: Variable.font.family.main
            font.weight: Font.Normal
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.smaller
        }
        Item {
            Layout.fillWidth: true
        }
        StyledSwitch {
            checked: Config.options.bar.borderScreen
            implicitWidth: 40
            implicitHeight: 20
            Layout.preferredHeight: 20
            height: 20
            onCheckedChanged: {
                Config.options.bar.borderScreen = checked;
                WindowManagerUtils.setWM();
            }
        }
    }
    RowLayout {
        Layout.preferredWidth: root.width
        Text {
            text: "Minimal Width"
            font.family: Variable.font.family.main
            font.weight: Font.Normal
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.smaller
        }
        Item {
            Layout.fillWidth: true
        }
        StyledStepper {
            value: Config.options.bar.width
            min: 0
            max: 10000
            step: 10
            onValueChanged: {
                Config.options.bar.width = value;
                WindowManagerUtils.setWM();
            }
        }
    }
    RowLayout {
        Layout.preferredWidth: root.width
        Text {
            text: "Margin"
            font.family: Variable.font.family.main
            font.weight: Font.Normal
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.smaller
        }
        Item {
            Layout.fillWidth: true
        }
        StyledStepper {
            value: Config.options.bar.margin
            min: 0
            max: 10000
            step: 1
            onValueChanged: {
                Config.options.bar.margin = value;
                WindowManagerUtils.setWM();
            }
        }
    }
    RowLayout {
        Layout.preferredWidth: root.width
        Text {
            text: "Border"
            font.family: Variable.font.family.main
            font.weight: Font.Normal
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.smaller
        }
        Item {
            Layout.fillWidth: true
        }
        StyledStepper {
            value: Config.options.bar.border
            min: 0
            max: 10000
            step: 1
            onValueChanged: {
                Config.options.bar.border = value;
                WindowManagerUtils.setWM();
            }
        }
    }
    RowLayout {
        Layout.preferredWidth: root.width
        Text {
            text: "Border Radius"
            font.family: Variable.font.family.main
            font.weight: Font.Normal
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.smaller
        }
        Item {
            Layout.fillWidth: true
        }
        StyledStepper {
            value: Config.options.bar.borderRadius
            min: 0
            max: 10000
            step: 1
            onValueChanged: {
                Config.options.bar.borderRadius = value;
                WindowManagerUtils.setWM();
            }
        }
    }
    LucideIcon {
        icon: "layout-panel-left"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.small
        font.weight: Font.DemiBold
        font.family: Variable.font.family.main
        label: "Bar Widgets"
    }

    ColumnLayout {
        spacing: Variable.margin.small
        LucideIcon {
            icon: "layout-panel-left"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.small
            font.weight: Font.DemiBold
            font.family: Variable.font.family.main
            label: "Start Widgets"
        }
        WidgetListWithFill {
            id: startWidgets
            fill: false
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            excludedWidgetList: ["CustomTrayMenu.qml", "DynamicLayout.qml", "SysTrayItem.qml"]
            items: Config.options.bar.startWidgets
            path: Directory.shell + "/modules/bar/widget"
            listUserPath: true
            onItemsChanged: {
                Config.options.bar.startWidgets = items;
            }
        }
        LucideIcon {
            icon: "layout-panel-left"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.small
            font.weight: Font.DemiBold
            font.family: Variable.font.family.main
            label: "Center Widgets"
        }
        WidgetListWithFill {
            id: centerWidgets
            fill: false
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            excludedWidgetList: ["CustomTrayMenu.qml", "DynamicLayout.qml", "SysTrayItem.qml"]
            items: Config.options.bar.centerWidgets
            path: Directory.shell + "/modules/bar/widget"
            listUserPath: true
            onItemsChanged: {
                Config.options.bar.centerWidgets = items;
            }
        }
        LucideIcon {
            icon: "layout-panel-left"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.small
            font.weight: Font.DemiBold
            font.family: Variable.font.family.main
            label: "End Widgets"
        }
        WidgetListWithFill {
            id: endWidgets
            fill: false
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            items: Config.options.bar.endWidgets
            excludedWidgetList: ["CustomTrayMenu.qml", "DynamicLayout.qml", "SysTrayItem.qml"]
            path: Directory.shell + "/modules/bar/widget"
            listUserPath: true
            onItemsChanged: {
                Config.options.bar.endWidgets = items;
            }
        }
    }
}
// }
