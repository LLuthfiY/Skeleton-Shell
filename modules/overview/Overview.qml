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
    id: root
    property int targetWorkspace: -1
    property HyprlandMonitor monitor: Hyprland.focusedMonitor
    property real scale: 0.15
    PanelWindow {
        id: overviewWindow

        visible: Config.options.windowManager.layout !== "scrolling"

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
                    width: root.monitor.width * root.scale
                    height: root.monitor.height * root.scale
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
                        onEntered: root.targetWorkspace = index + 1
                    }
                }
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 16
            Repeater {
                model: ScriptModel {
                    values: Hyprland.toplevels.values
                }
                delegate: Rectangle {
                    id: window
                    opacity: 0.7
                    property bool pressed: false
                    property int row: Math.floor((modelData.workspace.id - 1) / overviewGrid.columns)
                    property int col: (modelData.workspace.id - 1) % overviewGrid.columns
                    property string address: `0x${modelData.address}`
                    property var windowData: HyprlandData.windowByAddress[address]

                    visible: modelData.workspace.id > -1 && modelData.workspace.id < Config.options.windowManager.workspaces + 1
                    property double initX: col * root.monitor.width * root.scale + col * 8 + windowData.at[0] * root.scale
                    property double initY: row * root.monitor.height * root.scale + row * 8 + windowData.at[1] * root.scale
                    x: initX
                    y: initY

                    onWindowDataChanged: {
                        x = col * root.monitor.width * root.scale + col * 8 + windowData.at[0] * root.scale;
                        y = row * root.monitor.height * root.scale + row * 8 + windowData.at[1] * root.scale;
                    }

                    width: windowData.size[0] * root.scale
                    height: windowData.size[1] * root.scale
                    color: "transparent"
                    Behavior on x {
                        enabled: true
                        SmoothedAnimation {
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                    }
                    Behavior on y {
                        enabled: true
                        SmoothedAnimation {
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                    }
                    Behavior on width {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                    }

                    Behavior on height {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                    }

                    ScreencopyView {
                        id: screencopy
                        captureSource: (modelData && modelData.wayland) ? modelData.wayland : null
                        // constraintSize: Qt.size(window.width, window.height)
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
                        onStopped: {
                            modelData.wayland.close();
                        }
                        onCaptureSourceChanged: {
                            if (!captureSource) {
                                modelData.wayland.close();
                            }
                        }
                    }
                    Timer {
                        id: updateWindowPosition
                        interval: 50
                        repeat: false
                        running: false
                        onTriggered: {
                            window.x = col * root.monitor.width * root.scale + col * 8 + windowData.at[0] * root.scale;
                            window.y = row * root.monitor.height * root.scale + row * 8 + windowData.at[1] * root.scale;
                        }
                    }
                    TapHandler {
                        acceptedButtons: Qt.RightButton
                        onTapped: {
                            screencopy.captureSource = null;
                        }
                    }
                    TapHandler {
                        acceptedButtons: Qt.LeftButton
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
                                if (root.targetWorkspace !== -1 && root.targetWorkspace !== windowData?.workspace.id) {
                                    Hyprland.dispatch(`movetoworkspacesilent ${root.targetWorkspace}, address:${window.address}`);
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
    PanelWindow {
        id: overviewWindowScrolling

        visible: Config.options.windowManager.layout === "scrolling"

        anchors.top: true
        anchors.left: true
        anchors.right: true
        anchors.bottom: true

        property var windowMargin: Margin.windowMargin()

        margins {
            top: windowMargin.top
            bottom: windowMargin.bottom
            left: windowMargin.left
            right: windowMargin.right
        }

        color: "transparent"
        Rectangle {
            anchors.fill: parent
            color: Color.colors.surface
            radius: Variable.radius.normal
        }
        Rectangle {
            id: wrapper
            anchors.fill: parent
            anchors.margins: Variable.margin.normal
            color: "transparent"
            clip: true
            property int monitorHeight: wrapper.height / Config.options.windowManager.workspaces
            property int monitorWidth: monitorHeight * root.monitor.width / root.monitor.height
            Column {
                spacing: 0
                Repeater {
                    model: Config.options.windowManager.workspaces
                    delegate: Rectangle {
                        width: wrapper.width
                        height: wrapper.height / Config.options.windowManager.workspaces
                        color: "transparent"
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
                            onEntered: root.targetWorkspace = index + 1
                        }
                    }
                }
            }
            Item {
                height: wrapper.height
                width: wrapper.width
                Repeater {
                    model: ScriptModel {
                        values: Hyprland.toplevels.values
                    }
                    delegate: Rectangle {
                        id: window
                        opacity: 0.7
                        property bool pressed: false
                        property string address: `0x${modelData.address}`
                        property var windowData: HyprlandData.windowByAddress[address]
                        property int workskpace: (modelData.workspace.id - 1)
                        color: "transparent"

                        height: windowData.size[1] / root.monitor.height * wrapper.monitorHeight
                        width: windowData.size[0] / root.monitor.width * wrapper.monitorWidth
                        x: windowData.at[0] / root.monitor.width * wrapper.monitorWidth + wrapper.width / 2 - wrapper.monitorWidth / 2
                        y: windowData.at[1] / root.monitor.height * wrapper.monitorHeight + wrapper.monitorHeight * workskpace

                        visible: modelData.workspace.id > -1 && modelData.workspace.id < Config.options.windowManager.workspaces + 1
                        ScreencopyView {
                            captureSource: (modelData && modelData.wayland) ? modelData.wayland : null
                            // constraintSize: Qt.size(window.width, window.height)
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
                            onStopped: {
                                modelData.wayland.close();
                            }
                            onCaptureSourceChanged: {
                                if (!captureSource) {
                                    modelData.wayland.close();
                                }
                            }
                        }
                        TapHandler {
                            acceptedButtons: Qt.RightButton
                            onTapped: {
                                screencopy.captureSource = null;
                            }
                        }
                        TapHandler {
                            acceptedButtons: Qt.LeftButton
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
                                    if (root.targetWorkspace !== -1 && root.targetWorkspace !== windowData?.workspace.id) {
                                        Hyprland.dispatch(`movetoworkspacesilent ${root.targetWorkspace}, address:${window.address}`);
                                        updateWindowPositionScrolling.restart();
                                        HyprlandData.updateWindowList();
                                    } else {
                                        updateWindowPositionScrolling.restart();
                                        HyprlandData.updateWindowList();
                                    }
                                }
                            }
                        }
                        Timer {
                            id: updateWindowPositionScrolling
                            interval: 100
                            repeat: false
                            running: false
                            onTriggered: {
                                window.x = windowData.at[0] / root.monitor.width * wrapper.monitorWidth + wrapper.width / 2 - wrapper.monitorWidth / 2;
                                window.y = windowData.at[1] / root.monitor.height * wrapper.monitorHeight + wrapper.monitorHeight * workskpace;
                            }
                        }
                        Behavior on x {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }

                        Behavior on y {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                        Behavior on width {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                        }
                        Behavior on height {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
            }
        }
    }
}
