import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import qs.modules.common

Item {
    id: root

    property bool vertical: Config.options.bar.position === "left" || Config.options.bar.position === "right"
    property list<int> workspaces: Array.from({
        length: Config.options.windowManager.workspaces
    }, (x, i) => i + 1)
    Loader {
        id: workspaceLoader
        sourceComponent: root.vertical ? verticalComp : horizontalComp
    }

    implicitWidth: workspaceLoader.item ? workspaceLoader.item.implicitWidth + root.anchors.margins * 2 : 0 + root.anchors.margins * 2
    implicitHeight: workspaceLoader.item ? workspaceLoader.item.implicitHeight + root.anchors.margins * 2 : 0 + root.anchors.margins * 2

    Component {
        id: horizontalComp
        RowLayout {
            spacing: Variable.margin.smallest
            Repeater {
                model: root.workspaces
                Rectangle {
                    id: buttonWorkspace
                    property bool occupied: Hyprland.toplevels.values.some(toplevel => toplevel.workspace ? toplevel.workspace.id === modelData : false)
                    color: occupied ? "#77" + Color.colors[Config.options.bar.foreground].substring(1) : "transparent"
                    implicitWidth: Variable.size.large
                    implicitHeight: Variable.size.large
                    radius: Config.options.bar.borderRadius

                    Rectangle {
                        property bool active: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === modelData : false
                        anchors.centerIn: parent
                        color: Color.colors[Config.options.bar.foreground]
                        implicitWidth: active ? Variable.size.normal : Variable.size.smallest
                        implicitHeight: active ? Variable.size.normal : Variable.size.smallest
                        radius: Config.options.bar.borderRadius

                        Behavior on implicitWidth {
                            NumberAnimation {
                                duration: 200
                            }
                        }

                        Behavior on implicitHeight {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + modelData)
                    }
                }
            }
        }
    }

    Component {
        id: verticalComp
        ColumnLayout {
            Repeater {
                model: root.workspaces
                Rectangle {
                    id: buttonWorkspace
                    property bool occupied: Hyprland.toplevels.values.some(toplevel => toplevel.workspace ? toplevel.workspace.id === modelData : false)
                    color: occupied ? "#77" + Color.colors[Config.options.bar.foreground].substring(1) : "transparent"
                    implicitWidth: 24 * Config.options.appearance.uiScale
                    implicitHeight: 24 * Config.options.appearance.uiScale
                    radius: Config.options.bar.borderRadius

                    Rectangle {
                        property bool active: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === modelData : false
                        anchors.centerIn: parent
                        color: Color.colors[Config.options.bar.foreground]
                        implicitWidth: active ? 14 * Config.options.appearance.uiScale : 6 * Config.options.appearance.uiScale
                        implicitHeight: active ? 14 * Config.options.appearance.uiScale : 6 * Config.options.appearance.uiScale
                        radius: Config.options.bar.borderRadius

                        Behavior on implicitWidth {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                        Behavior on implicitHeight {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + modelData)
                    }
                }
            }
        }
    }
}
