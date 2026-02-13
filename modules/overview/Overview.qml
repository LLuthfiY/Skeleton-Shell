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
                        font.family: Variable.font.family.main
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

                    Component.onCompleted: {
                        console.log(windowData);
                    }
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
                    TapHandler {
                        acceptedButtons: Qt.RightButton
                        onTapped: Hyprland.dispatch(`workspace ${windowData?.workspace.id}`)
                    }
                    Drag.active: dragHandler.active
                    Drag.hotSpot.x: width / 2
                    Drag.hotSpot.y: height / 2

                    DragHandler {
                        id: dragHandler
                        target: parent
                        onActiveChanged: {
                            if (!active) {
                                if (overviewRoot.targetWorkspace !== -1 && overviewRoot.targetWorkspace !== windowData?.workspace.id) {
                                    Hyprland.dispatch(`movetoworkspacesilent ${overviewRoot.targetWorkspace}, address:${window.address}`);
                                    updateWindowPosition.restart();
                                    HyprlandData.updateWindowList();
                                } else {
                                    updateWindowPosition.restart();
                                    HyprlandData.updateWindowList();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
