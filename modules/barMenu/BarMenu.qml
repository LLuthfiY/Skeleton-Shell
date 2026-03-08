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
    PanelWindow {

        property string barPosition: Config.options.bar.position
        property int barMargin: Config.options.bar.margin
        property int gapsOut: Config.options.windowManager.gapsOut
        property bool borderScreen: Config.options.bar.borderScreen
        property string barMenuPosition: GlobalState.barMenuPosition

        implicitWidth: barMenu.width
        implicitHeight: barMenu.height

        WlrLayershell.namespace: "quickshell:barMenu"
        WlrLayershell.layer: WlrLayer.Overlay
        color: "transparent"
        exclusionMode: ExclusionMode.Normal

        anchors {
            top: barPosition === "top" || ((barPosition === "left" || barPosition === "right") && barMenuPosition === "start")
            left: barPosition === "left" || ((barPosition === "top" || barPosition === "bottom") && barMenuPosition === "start")
            right: barPosition === "right" || ((barPosition === "top" || barPosition === "bottom") && barMenuPosition === "end")
            bottom: barPosition === "bottom" || ((barPosition === "left" || barPosition === "right") && barMenuPosition === "end")
        }

        margins {
            top: barPosition === "top" ? gapsOut : borderScreen ? barMargin + gapsOut : gapsOut
            bottom: barPosition === "bottom" ? gapsOut : borderScreen ? barMargin + gapsOut : gapsOut
            left: barPosition === "left" ? gapsOut : borderScreen ? barMargin + gapsOut : gapsOut
            right: barPosition === "right" ? gapsOut : borderScreen ? barMargin + gapsOut : gapsOut
        }

        Rectangle {
            anchors.fill: parent

            color: Color.colors.surface
            radius: Variable.radius.small
        }
        ColumnLayout {
            id: barMenu
            Loader {
                Layout.margins: Variable.margin.small
                sourceComponent: GlobalState.barMenuComponent
            }
        }
    }
}
