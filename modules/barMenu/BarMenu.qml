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
        id: barMenuWindow
        visible: GlobalState.barMenuOpen
        property bool ready: init()
        property string barPosition: Config.options.bar.position
        property int barMargin: Config.options.bar.margin
        property int gapsOut: Config.options.windowManager.gapsOut
        property bool borderScreen: Config.options.bar.borderScreen

        implicitWidth: barMenu.width
        implicitHeight: barMenu.height

        function init() {
            BarMenuUtils.barMenuWindow = barMenuWindow;
            true;
        }

        WlrLayershell.namespace: "quickshell:barMenu"
        WlrLayershell.layer: WlrLayer.Overlay
        color: "transparent"
        exclusionMode: ExclusionMode.Normal

        anchors: BarMenuUtils.getAnchor()
        property var tempMargins: BarMenuUtils.getMargins()
        margins {
            top: tempMargins.top
            bottom: tempMargins.bottom
            left: tempMargins.left
            right: tempMargins.right
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
                sourceComponent: BarMenuUtils.barMenuComponent
            }
        }
    }
}
