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
            spacing: 0
            Repeater {
                model: root.workspaces
                Loader {
                    sourceComponent: buttonWorkspace
                    onLoaded: {
                        item.ind = modelData;
                    }
                }
            }
        }
    }

    Component {
        id: verticalComp
        ColumnLayout {
            spacing: 0
            Repeater {
                model: root.workspaces
                Loader {
                    sourceComponent: buttonWorkspace
                    onLoaded: {
                        item.ind = modelData;
                    }
                }
            }
        }
    }
    Component {
        id: buttonWorkspace

        Rectangle {
            id: buttonWorkspace
            property int ind: -1
            property bool active: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === ind : false
            property bool occupied: Hyprland.toplevels.values.some(toplevel => toplevel.workspace ? toplevel.workspace.id === ind : false)
            color: "transparent"
            implicitWidth: Variable.size.large
            implicitHeight: implicitWidth
            radius: 999

            Rectangle {
                property bool active: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === ind : false
                anchors.centerIn: parent
                color: occupied ? "#80" + Color.colors[Config.options.bar.foreground].substring(1) : Color.colors[Config.options.bar.background]
                implicitWidth: active ? Variable.uiScale(24) : Variable.uiScale(12)
                implicitHeight: active ? Variable.uiScale(24) : Variable.uiScale(12)
                radius: 999
                border.width: Variable.uiScale(2)
                border.color: Color.colors[Config.options.bar.foreground]

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

            TapHandler {
                onTapped: {
                    Hyprland.dispatch("workspace " + ind);
                }
            }
        }
    }
}
