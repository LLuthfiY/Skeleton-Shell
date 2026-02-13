import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services

Scope {
    id: root
    // property var application: ScriptModel {
    //     values: AppSearch.fuzzyQuery(searchInput.text)
    //     // values: searchInput.text != "" ? DesktopEntries.applications.values.filter(app => app.name.toLowerCase().includes(searchInput.text.toLowerCase())).sort((a, b) => a.name.localeCompare(b.name)).sort((a, b) => a.name.toLowerCase().indexOf(searchInput.text.toLowerCase()) - b.name.toLowerCase().indexOf(searchInput.text.toLowerCase())) : DesktopEntries.applications.values.filter(a => true).sort((a, b) => a.name.toLowerCase().localeCompare(b.name.toLowerCase()))
    // }
    property var application: AppSearch.fuzzyQuery(searchInput.text)
    PanelWindow {
        id: launcherWindow
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null

        WlrLayershell.namespace: "quickshell:launcher"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        // WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: 0

        implicitWidth: 500 * Config.options.appearance.uiScale
        implicitHeight: 500 * Config.options.appearance.uiScale
        color: "transparent"

        // HyprlandFocusGrab {
        //     id: grab
        //     active: true
        //     windows: [launcherWindow]
        // }

        Rectangle {
            anchors.fill: parent
            color: Color.colors.surface
            radius: Variable.radius.small
        }
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Variable.margin.normal
            spacing: Variable.margin.small
            RowLayout {
                LucideIcon {
                    icon: "search"
                }
                TextField {
                    id: searchInput
                    Layout.fillWidth: true
                    height: 40 * Config.options.appearance.uiScale
                    width: parent.width
                    padding: Variable.margin.small
                    font.pixelSize: Variable.font.pixelSize.normal
                    font.family: Variable.font.family.main
                    font.weight: Font.Normal
                    focus: true
                    background: Rectangle {
                        color: Color.colors.surface
                        radius: Variable.radius.small
                    }
                    color: Color.colors.on_surface_variant

                    onAccepted: {
                        launcherList.currentItem.execute();
                        GlobalState.launcherOpen = false;
                    }
                    // onTextChanged: {
                    //     launcherList.currentIndex = 0;
                    // }
                    Keys.onPressed: {
                        if (event.key === Qt.Key_Escape) {
                            GlobalState.launcherOpen = false;
                        }
                        if (event.key === Qt.Key_Tab) {
                            if (launcherList.currentIndex + 1 >= launcherList.count) {
                                launcherList.currentIndex = 0;
                            } else {
                                launcherList.currentIndex += 1;
                            }
                        }
                        if (event.key === Qt.Key_Backtab) {
                            if (launcherList.currentIndex - 1 < 0) {
                                launcherList.currentIndex = launcherList.count - 1;
                            } else {
                                launcherList.currentIndex -= 1;
                            }
                        }
                    }
                }
            }
            ListView {
                id: launcherList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: root.application
                delegate: Rectangle {
                    id: appDelegate
                    required property DesktopEntry modelData
                    required property int index
                    color: "transparent"
                    height: row.height
                    width: parent?.parent.width ?? 0
                    radius: Variable.radius.small
                    function execute() {
                        GlobalState.launcherOpen = false;
                        if (modelData.runInTerminal) {
                            Quickshell.execDetached(["kitty", "-d", Directory.home.replace("file://"), "bash", "-c", modelData.execString]);
                        } else {
                            modelData.execute();
                        }
                    }
                    Rectangle {
                        anchors.left: parent.left
                        width: 2 * Config.options.appearance.uiScale
                        height: parent.height / 2
                        anchors.verticalCenter: parent.verticalCenter
                        color: launcherList.currentIndex === index || hoverHandler.hovered ? Color.colors.primary : "transparent"
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }
                    RowLayout {
                        id: row
                        spacing: 0
                        width: parent.width
                        height: Variable.size.huge

                        IconImage {
                            Layout.margins: Variable.margin.small
                            Layout.leftMargin: Variable.margin.normal
                            Layout.fillHeight: true
                            Layout.preferredWidth: Variable.size.larger
                            source: Quickshell.iconPath(appDelegate.modelData.icon, "image-missing")
                        }
                        Text {
                            text: appDelegate.modelData.name
                            Layout.fillWidth: true
                            Layout.leftMargin: Variable.margin.small
                            font.family: Variable.font.family.main
                            font.weight: Font.Normal
                            color: ListView.isCurrentItem ? Color.colors.on_primary : Color.colors.on_surface
                        }
                    }
                    TapHandler {
                        onTapped: {
                            appDelegate.execute();
                        }
                    }

                    HoverHandler {
                        id: hoverHandler
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }
            }
        }
    }
}
