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
                    property bool hovered: false
                    width: textPosition.width + 16
                    height: textPosition.height + 8
                    radius: Variable.radius.small
                    color: Config.options.dashboard.position === modelData ? Color.colors.primary : hovered ? Color.colors.surface_container_high : Color.colors.surface_container
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
                            Config.options.dashboard.position = modelData;
                            dashboardWindow.close();
                        }
                    }
                    Text {
                        id: textPosition
                        text: modelData
                        anchors.centerIn: parent
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
                        color: Config.options.dashboard.position === modelData ? Color.colors.on_primary : Color.colors.on_surface
                    }
                }
            }
        }
        WidgetListWithFill {
            id: widgets
            items: Config.options.dashboard.widgets
            path: Directory.shell + "/modules/dashboard/widget"
            Layout.preferredWidth: 300
            onItemsChanged: {
                Config.options.dashboard.widgets = items;
                console.log(items);
            }
        }
    }
}
