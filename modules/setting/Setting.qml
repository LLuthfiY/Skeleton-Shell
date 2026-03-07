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

        FindCommand {
            id: userPageList
            path: Directory.trimFileProtocol(Directory.shell + "/modules/setting/page/user")
            searchFolder: false
            filter: ["*.qml"]
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
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: reloadIcon.implicitHeight + Variable.margin.normal
                            HoverHandler {
                                id: reloadHoverHandler
                                cursorShape: Qt.PointingHandCursor
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            TapHandler {
                                onTapped: {
                                    Quickshell.execDetached(["hyprctl", "reload"]);
                                    Quickshell.reload(true);
                                }
                            }
                            radius: Variable.radius.small
                            color: reloadHoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface_container
                            LucideIcon {
                                id: reloadIcon
                                anchors.centerIn: parent
                                icon: "rotate-ccw"
                                label: "Reload"
                                color: Color.colors.on_surface
                                font.pixelSize: Variable.font.pixelSize.normal
                                font.weight: Font.Bold
                                font.family: Variable.font.family.main
                                Layout.alignment: Qt.AlignVCenter
                                Layout.rightMargin: Variable.margin.small
                            }
                        }
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
                                {
                                    icon: "download",
                                    text: "Import Config"
                                },
                                ...userPageList.items.map(item => {
                                    item = item.split("/").pop();
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
                        model: [themeComponent, barComponent, dashboardComponent, windowManagerComponent, modulesComponent, userPageComponent]
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
                                source: "page/user/" + modelData.split("/").pop()
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
                Component {
                    id: userPageComponent
                    ImportConfig {}
                }
            }
        }
    }
}
