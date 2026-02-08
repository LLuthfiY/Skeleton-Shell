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
            icon: "layout-panel-left"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.title
            font.weight: Font.Bold
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
            spacing: 8
            Layout.preferredWidth: root.width
            Repeater {
                model: ["surface", "surface_container", "surface_container_high", "on_surface", "primary", "primary_container", "on_primary", "transparent"]
                delegate: Rectangle {
                    property bool hovered: false
                    width: text.width + 16
                    height: text.height + 8
                    radius: Variable.radius.small
                    color: "transparent"
                    Rectangle {
                        width: Config.options.bar.background === modelData ? parent.width : parent.hovered ? parent.width : 2
                        height: parent.height
                        radius: Variable.radius.smallest
                        anchors.verticalCenter: parent.verticalCenter
                        color: Config.options.bar.background === modelData ? Color.colors.primary : Color.colors.primary_container
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                        Behavior on width {
                            NumberAnimation {
                                duration: 200
                            }
                        }
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
                            Config.options.bar.background = modelData;
                        }
                    }
                    Text {
                        id: text
                        text: modelData
                        anchors.centerIn: parent
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
                        color: Config.options.bar.background === modelData ? Color.colors.on_primary : Color.colors.on_surface
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
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
            spacing: 8
            Layout.preferredWidth: root.width
            Repeater {
                model: ["surface", "surface_container", "surface_container_high", "on_surface", "primary", "primary_container", "on_primary", "transparent"]
                delegate: Rectangle {
                    property bool hovered: false
                    width: textForeground.width + 16
                    height: textForeground.height + 8
                    radius: Variable.radius.small
                    color: "transparent"
                    Rectangle {
                        width: Config.options.bar.foreground === modelData ? parent.width : parent.hovered ? parent.width : 2
                        height: parent.height
                        radius: Variable.radius.smallest
                        anchors.verticalCenter: parent.verticalCenter
                        color: Config.options.bar.foreground === modelData ? Color.colors.primary : Color.colors.primary_container
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                        Behavior on width {
                            NumberAnimation {
                                duration: 200
                            }
                        }
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
                            Config.options.bar.foreground = modelData;
                        }
                    }
                    Text {
                        id: textForeground
                        text: modelData
                        anchors.centerIn: parent
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
                        color: Config.options.bar.foreground === modelData ? Color.colors.on_primary : Color.colors.on_surface
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
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
            spacing: 8
            Repeater {
                model: ["left", "top", "right", "bottom"]
                delegate: Rectangle {
                    property bool hovered: false
                    width: textPosition.width + 16
                    height: textPosition.height + 8
                    radius: Variable.radius.small
                    color: "transparent"
                    Rectangle {
                        width: Config.options.bar.position === modelData ? parent.width : parent.hovered ? parent.width : 2
                        height: parent.height
                        radius: Variable.radius.smallest
                        anchors.verticalCenter: parent.verticalCenter
                        color: Config.options.bar.position === modelData ? Color.colors.primary : Color.colors.primary_container
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                        Behavior on width {
                            NumberAnimation {
                                duration: 200
                            }
                        }
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
                            Config.options.bar.position = modelData;
                            WindowManagerUtils.setWM(100);
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                    LucideIcon {
                        id: textPosition
                        label: modelData
                        icon: modelData === "left" ? "arrow-left" : modelData === "right" ? "arrow-right" : modelData === "top" ? "arrow-up" : modelData === "bottom" ? "arrow-down" : ""
                        anchors.centerIn: parent
                        color: Config.options.bar.position === modelData ? Color.colors.on_primary : Color.colors.on_surface
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
                onCheckedChanged: {
                    Config.options.bar.fullWidth = checked;
                    WindowManagerUtils.setWM(100);
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
                onCheckedChanged: {
                    Config.options.bar.borderScreen = checked;
                    WindowManagerUtils.setWM(100);
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
                    WindowManagerUtils.setWM(100);
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
                    WindowManagerUtils.setWM(100);
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
                    WindowManagerUtils.setWM(100);
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
                    WindowManagerUtils.setWM(100);
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

        RowLayout {
            spacing: 8
            WidgetList {
                id: startWidgets
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                excludedWidgetList: ["CustomTrayMenu.qml", "DynamicLayout.qml", "SysTrayItem.qml"]
                items: Config.options.bar.startWidgets
                path: Directory.shell + "/modules/bar/widget"
                onItemsChanged: {
                    Config.options.bar.startWidgets = items;
                }
            }
            WidgetList {
                id: centerWidgets
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                excludedWidgetList: ["CustomTrayMenu.qml", "DynamicLayout.qml", "SysTrayItem.qml"]
                items: Config.options.bar.centerWidgets
                path: Directory.shell + "/modules/bar/widget"
                onItemsChanged: {
                    Config.options.bar.centerWidgets = items;
                }
            }
            WidgetList {
                id: endWidgets
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                items: Config.options.bar.endWidgets
                excludedWidgetList: ["CustomTrayMenu.qml", "DynamicLayout.qml", "SysTrayItem.qml"]
                path: Directory.shell + "/modules/bar/widget"
                onItemsChanged: {
                    Config.options.bar.endWidgets = items;
                }
            }
        }
    }
}
