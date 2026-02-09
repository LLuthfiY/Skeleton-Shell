import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

Scope {
    PanelWindow {
        id: root
        visible: (Notification.popupList.length > 0) && !GlobalState.screenLocked && !GlobalState.dashboardOpen
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null

        WlrLayershell.namespace: "quickshell:notificationPopup"
        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: 0
        property string position: Config.options.notification.position.toLowerCase()

        anchors {
            top: true
            bottom: true
            left: position.includes("left")
            right: position.includes("right")
        }

        margins {
            top: WindowManagerUtils.topMargin
            bottom: WindowManagerUtils.bottomMargin
            left: WindowManagerUtils.leftMargin
            right: WindowManagerUtils.rightMargin
        }

        mask: Region {
            item: listview.contentItem
        }

        color: "transparent"
        implicitWidth: Variable.size.notificationPopupWidth

        ListView {
            id: listview
            spacing: 8
            anchors.fill: parent
            anchors.margins: 0

            model: ScriptModel {
                values: Notification.popupList
            }
            delegate: NotificationItem {
                notificationObject: modelData
            }
        }
    }
}
