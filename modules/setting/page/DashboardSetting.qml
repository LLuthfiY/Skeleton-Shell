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
            icon: "layout-dashboard"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.title
            font.weight: Font.Bold
            label: "Dashboard"
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
                model: ["left", "right"]
                delegate: Rectangle {
                    width: textPosition.width + Variable.size.normal
                    height: textPosition.height + Variable.size.small
                    radius: Variable.radius.small
                    color: "transparent"
                    Rectangle {
                        width: Config.options.dashboard.position === modelData ? parent.width : hoverHandler.hovered ? parent.width : 2
                        height: parent.height
                        radius: Variable.radius.smallest
                        anchors.verticalCenter: parent.verticalCenter
                        color: Config.options.dashboard.position === modelData ? Color.colors.primary : Color.colors.primary_container
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
                    TapHandler {
                        onTapped: {
                            Config.options.dashboard.position = modelData;
                            dashboardWindow.close();
                        }
                    }
                    HoverHandler {
                        id: hoverHandler
                    }
                    Text {
                        id: textPosition
                        text: modelData
                        anchors.centerIn: parent
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
                        font.pixelSize: Variable.font.pixelSize.normal
                        color: Config.options.dashboard.position === modelData ? Color.colors.on_primary : Color.colors.on_surface
                    }
                }
            }
        }
        // WidgetListWithFill {
        //     id: widgets
        //     items: Config.options.dashboard.widgets
        //     path: Directory.shell + "/modules/dashboard/widget"
        //     Layout.preferredWidth: 300
        //     onItemsChanged: {
        //         Config.options.dashboard.widgets = items;
        //     }
        // }
        DragableListView {
            items: Config.options.dashboard.widgets
        }
    }
}
