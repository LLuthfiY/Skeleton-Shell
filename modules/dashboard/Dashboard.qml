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
        implicitWidth: Variable.size.dashboardWidth
        anchors.top: true
        anchors.right: Config.options.dashboard.position === "right"
        anchors.left: Config.options.dashboard.position === "left"
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
                    width: parent.width
                    height: parent.height
                    spacing: 0
                    Repeater {
                        model: Config.options.dashboard.widgets
                        delegate: Loader {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            Layout.fillHeight: modelData.includes("--fill--")
                            property bool isFirst: index === 0
                            Layout.preferredHeight: ("active" in item) ? item.active ? (implicitHeight || height) : 0 : (implicitHeight || height)
                            Layout.topMargin: isFirst ? 0 : ("active" in item) ? item.active ? Variable.margin.normal : 0 : Variable.margin.normal
                            clip: true
                            property string folder: modelData.startsWith("user--") ? "widget/user/" : "widget/"
                            Behavior on Layout.preferredHeight {
                                NumberAnimation {
                                    duration: 200
                                }
                            }
                            Behavior on Layout.topMargin {
                                NumberAnimation {
                                    duration: 200
                                }
                            }
                            source: folder + modelData.replace("user--", "").replace("--fill--", "")
                        }
                    }
                }
            }
        }
    }
}
