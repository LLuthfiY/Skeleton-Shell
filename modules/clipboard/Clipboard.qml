import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services

Scope {
    id: root
    property var clipboards: []
    PanelWindow {
        id: launcherWindow

        WlrLayershell.namespace: "quickshell:launcher"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        // WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: 0

        implicitWidth: Variable.uiScale(800)
        implicitHeight: Variable.uiScale(500)
        color: "transparent"

        Timer {
            id: clipboardTimer
            running: true
            repeat: true
            triggeredOnStart: true
            interval: 3000
            onTriggered: {
                clipboardProcess.running = true;
            }
        }

        Process {
            id: clipboardProcess
            command: ["cliphist", "list"]
            stdout: StdioCollector {
                onStreamFinished: {
                    let output = this.text.split("\n");
                    root.clipboards = output.filter(a => a.length > 0);
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Color.colors.surface
            radius: Config.options.windowManager.windowBorderRadius
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
                    height: Variable.uiScale(40)
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
                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            GlobalState.clipboardOpen = false;
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
                model: root.clipboards.filter(a => a.toLowerCase().includes(searchInput.text.toLowerCase()))
                delegate: Rectangle {
                    id: appDelegate
                    required property var modelData
                    required property int index
                    color: "transparent"
                    height: row.height
                    width: parent?.parent.width ?? 0
                    radius: Variable.radius.small
                    function execute() {
                        Quickshell.execDetached(["bash", "-c", `echo "${modelData}" | cliphist decode | wl-copy`]);
                        GlobalState.clipboardOpen = false;
                    }
                    Rectangle {
                        anchors.left: parent.left
                        width: Variable.uiScale(2)
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

                        Text {
                            text: appDelegate.modelData
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
