import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

import qs.services

import Qt5Compat.GraphicalEffects

Scope {
    id: overviewRoot
    property int targetWorkspace: -1
    PanelWindow {
        id: overviewWindow

        property real scale: 0.15
        property HyprlandMonitor monitor: Hyprland.focusedMonitor

        WlrLayershell.namespace: "quickshell:overview"
        WlrLayershell.layer: WlrLayer.Overlay
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        anchors.top: true
        margins {
            top: 64
        }

        implicitWidth: overviewGrid.implicitWidth + 32
        implicitHeight: overviewGrid.implicitHeight + 32
        Rectangle {
            anchors.fill: parent

            color: Color.colors.surface
            radius: 24
        }

        GridLayout {
            id: overviewGrid
            anchors.centerIn: parent
            rowSpacing: 8
            columnSpacing: 8
            columns: Math.ceil(Config.options.windowManager.workspaces / 2)

            Repeater {
                model: Config.options.windowManager.workspaces

                delegate: Rectangle {
                    width: overviewWindow.monitor.width * overviewWindow.scale
                    height: overviewWindow.monitor.height * overviewWindow.scale
                    color: Color.colors.surface_container
                    radius: 16
                    Text {
                        anchors.centerIn: parent
                        text: index + 1
                        font.pixelSize: 32
                        font.weight: 900
                        font.family: Appearance.font.family.main
                        color: Color.colors.on_surface_variant
                    }
                    DropArea {
                        anchors.fill: parent
                        onEntered: overviewRoot.targetWorkspace = index + 1
                    }
                }
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 16
            Repeater {
                model: Hyprland.toplevels
                delegate: Rectangle {
                    id: window
                    opacity: 0.7
                    property bool pressed: false
                    property int row: Math.floor((modelData.workspace.id - 1) / overviewGrid.columns)
                    property int col: (modelData.workspace.id - 1) % overviewGrid.columns
                    property string address: `0x${modelData.address}`
                    property var windowData: HyprlandData.windowByAddress[address]

                    visible: modelData.workspace.id > -1 && modelData.workspace.id < Config.options.windowManager.workspaces + 1
                    property double initX: col * overviewWindow.monitor.width * overviewWindow.scale + col * 8 + windowData.at[0] * overviewWindow.scale
                    property double initY: row * overviewWindow.monitor.height * overviewWindow.scale + row * 8 + windowData.at[1] * overviewWindow.scale
                    x: initX
                    y: initY

                    onWindowDataChanged: {
                        x = col * overviewWindow.monitor.width * overviewWindow.scale + col * 8 + windowData.at[0] * overviewWindow.scale;
                        y = row * overviewWindow.monitor.height * overviewWindow.scale + row * 8 + windowData.at[1] * overviewWindow.scale;
                    }

                    width: windowData.size[0] * overviewWindow.scale
                    height: windowData.size[1] * overviewWindow.scale
                    color: "transparent"
                    Behavior on x {
                        enabled: true
                        SmoothedAnimation {
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }
                    Behavior on y {
                        enabled: true
                        SmoothedAnimation {
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }
                    ScreencopyView {
                        captureSource: modelData.wayland
                        constraintSize: Qt.size(window.width, window.height)
                        anchors.fill: parent
                        live: true
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: window.width
                                height: window.height
                                radius: 8
                            }
                        }
                    }
                    Timer {
                        id: updateWindowPosition
                        interval: 50
                        repeat: false
                        running: false
                        onTriggered: {
                            window.x = col * overviewWindow.monitor.width * overviewWindow.scale + col * 8 + windowData.at[0] * overviewWindow.scale;
                            window.y = row * overviewWindow.monitor.height * overviewWindow.scale + row * 8 + windowData.at[1] * overviewWindow.scale;
                        }
                    }
                    MouseArea {
                        id: dragArea
                        anchors.fill: parent
                        hoverEnabled: true
                        // onEntered: hovered = true // For hover color change
                        // onExited: hovered = false // For hover color change
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                        drag.target: parent
                        onPressed: mouse => {
                            if (mouse.button === Qt.RightButton) {
                                Hyprland.dispatch(`workspace ${windowData?.workspace.id}`);
                            }
                            window.pressed = true;
                            window.Drag.active = true;
                            window.Drag.source = window;
                            window.Drag.hotSpot.x = mouse.x;
                            window.Drag.hotSpot.y = mouse.y;
                        // console.log(`[OverviewWindow] Dragging window ${windowData?.address} from position (${window.x}, ${window.y})`)
                        }
                        onReleased: mouse => {
                            // const xOffset = Math.floor(mouse.x / ((overviewWindow.monitor.width * overviewWindow.scale) + overviewGrid.rowSpacing));
                            // const yOffset = Math.floor(mouse.y / ((overviewWindow.monitor.height * overviewWindow.scale) + overviewGrid.columnSpacing));
                            // const targetWorkspace = xOffset + (yOffset ? Math.ceil(Config.options.windowManager.workspaces / 2) : 0);
                            //
                            // console.log(mouse.x, mouse.y, xOffset, yOffset, targetWorkspace);
                            // console.log(mouse.toItem(window));
                            window.pressed = false;
                            window.Drag.active = false;
                            if (overviewRoot.targetWorkspace !== -1 && overviewRoot.targetWorkspace !== windowData?.workspace.id) {
                                Hyprland.dispatch(`movetoworkspacesilent ${overviewRoot.targetWorkspace}, address:${window.address}`);
                                updateWindowPosition.restart();
                                HyprlandData.updateWindowList();
                            } else {
                                window.x = window.initX;
                                window.y = window.initY;
                            }
                        }
                    }
                }
            }
        }
    }
}
