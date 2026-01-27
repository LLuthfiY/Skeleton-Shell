import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.modules.notification
import qs.services

Scope {
    id: root
    PanelWindow {
        id: dashboardWindow
        visible: Config.ready && GlobalState.dashboardOpen
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null
        WlrLayershell.namespace: "quickshell:dashboard"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        WlrLayershell.layer: WlrLayer.Overlay
        // exclusiveZone: 0
        exclusionMode: ExclusionMode.Ignore
        implicitWidth: Variable.sizes.dashboardWidth
        anchors.top: true
        anchors.right: true
        anchors.bottom: true
        color: "transparent"
        Rectangle {
            anchors.fill: parent
            anchors.margins: Config.options.windowManager.gapsOut + Config.options.bar.margin
            color: Color.colors.surface
            radius: Variable.radius.normal
            Rectangle {
                anchors.fill: parent
                anchors.margins: Variable.margin.normal
                color: "transparent"
                clip: true
                ColumnLayout {
                    spacing: Variable.margin.normal
                    width: parent.width
                    height: parent.height
                    Repeater {
                        model: Config.options.dashboard.widgets
                        delegate: Loader {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            Layout.fillHeight: modelData.includes("--fill--")
                            property string folder: modelData.startsWith("user--") ? "widget/user/" : "widget/"
                            source: folder + modelData.replace("user--", "").replace("--fill--", "")
                        }
                    }
                }
            }
        }
    }
}
