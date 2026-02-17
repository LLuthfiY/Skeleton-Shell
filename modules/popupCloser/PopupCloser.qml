import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.modules.common

Scope {
    id: root
    PanelWindow {
        id: panelWindow
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "popupCloser"
        color: "transparent"
        TapHandler {
            onTapped: {
                GlobalState.launcherOpen = false;
                GlobalState.dashboardOpen = false;
                GlobalState.overviewOpen = false;
                GlobalState.aiChatOpen = false;
            }
        }
    }
}
