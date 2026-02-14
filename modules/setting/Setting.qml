import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell

import qs.modules.setting.page
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

Scope {
    Window {
        id: root
        property int section: 0
        minimumWidth: 800
        minimumHeight: 500
        visible: GlobalState.settingsOpen
        title: "Settings"

        onClosing: {
            GlobalState.settingsOpen = false;
        }

        Rectangle {
            anchors.fill: parent
            color: Color.colors.surface
        }

        RowLayout {
            anchors.fill: parent
            spacing: Variable.margin.small
            anchors.margins: Variable.margin.normal

            Rectangle {
                implicitWidth: Variable.uiScale(200)
                Layout.fillHeight: true
                color: Color.colors.surface
                radius: Variable.radius.small
                ColumnLayout {
                    spacing: Variable.margin.small
                    anchors.fill: parent
                    anchors.margins: Variable.margin.small
                    Repeater {
                        model: [
                            {
                                icon: "paint-roller",
                                text: "Theme"
                            },
                            {
                                icon: "layout-panel-left",
                                text: "Bar"
                            },
                            {
                                icon: "layout-dashboard",
                                text: "Dashboard"
                            },
                            {
                                icon: "app-window",
                                text: "Window Manager"
                            },
                        ]

                        delegate: Rectangle {
                            Layout.preferredHeight: Variable.size.larger
                            Layout.preferredWidth: Variable.uiScale(200)
                            Layout.fillWidth: true
                            color: "transparent"
                            Rectangle {
                                anchors.left: parent.left
                                width: root.section === index ? parent.width : hoverHandler.hovered ? parent.width : 2
                                color: root.section === index ? Color.colors.primary : Color.colors.primary_container
                                height: parent.height
                                radius: Variable.radius.smallest
                                Behavior on width {
                                    NumberAnimation {
                                        duration: 200
                                    }
                                }
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                            }

                            LucideIcon {
                                icon: modelData.icon
                                color: root.section === index ? Color.colors.on_primary : Color.colors.on_surface
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.margins: Variable.margin.small
                                label: modelData.text
                                font.weight: Font.Normal
                                font.family: Variable.font.family.main
                                font.pixelSize: Variable.font.pixelSize.normal
                            }
                            TapHandler {
                                onTapped: {
                                    root.section = index;
                                }
                            }
                            HoverHandler {
                                id: hoverHandler
                            }
                        }
                    }
                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
            Rectangle {
                color: Color.colors.surface_container_high
                width: 1
                Layout.fillHeight: true
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                StackLayout {
                    id: stackWrapper
                    anchors.fill: parent
                    anchors.margins: Variable.margin.normal
                    currentIndex: root.section
                    ThemeSetting {}
                    BarSetting {}
                    DashboardSetting {}
                    WindowManagerSetting {}
                }
            }
        }
    }
}
