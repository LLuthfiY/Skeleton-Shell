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
        minimumWidth: Variable.uiScale(800)
        minimumHeight: Variable.uiScale(600)
        visible: GlobalState.settingsOpen
        title: "Settings"

        LsCommand {
            id: userPageList
            path: Directory.trimFileProtocol(Directory.shell + "/modules/setting/page/user")
            filter: "*.qml"
            interval: 3000
        }

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
                ScrollView {
                    clip: true
                    anchors.fill: parent
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
                                {
                                    icon: "component",
                                    text: "Modules"
                                },
                                ...userPageList.items.map(item => {
                                    let match = item.match(/\+\+(.+?)\+\+/);
                                    let icon = match ? match[1] : "package";
                                    let text = item.replace(/\+\+(.+?)\+\+/, "").replace("_", " ").replace(".qml", "");
                                    return {
                                        icon: icon,
                                        text: text
                                    };
                                })]
                            delegate: SidebarButton {}
                        }
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

                    Repeater {
                        model: [themeComponent, barComponent, dashboardComponent, windowManagerComponent, modulesComponent]
                        // model: [ThemeSetting, BarSetting, DashboardSetting, WindowManagerSetting, ModulesSetting]

                        // delegate: Loader {
                        //     Layout.fillWidth: true
                        //     Layout.fillHeight: true
                        //
                        //     sourceComponent: modelData
                        // }
                        delegate: ScrollView {
                            height: stackWrapper.height
                            width: parent.width
                            Loader {
                                sourceComponent: modelData
                            }
                        }
                    }
                    Repeater {
                        model: userPageList.items
                        delegate: ScrollView {
                            height: stackWrapper.height
                            width: parent.width
                            Loader {
                                source: "page/user/" + modelData
                            }
                        }
                    }
                }

                Component {
                    id: themeComponent
                    ThemeSetting {}
                }
                Component {
                    id: barComponent
                    BarSetting {}
                }
                Component {
                    id: dashboardComponent
                    DashboardSetting {}
                }
                Component {
                    id: windowManagerComponent
                    WindowManagerSetting {}
                }
                Component {
                    id: modulesComponent
                    ModulesSetting {}
                }
            }
        }
    }
}
