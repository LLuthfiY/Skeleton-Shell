pragma Singleton
import Quickshell
import QtQuick

import qs.services
import qs.modules.common

Singleton {
    id: root

    property var hyprlandFocusedMonitor: HyprlandData.monitors.find(m => m.focused)
    property var hyprlandFocusedMonitorBar: HyprlandData.layers[hyprlandFocusedMonitor.name].levels["2"].find(l => l.namespace === "quickshell:bar")

    property var barWindow: null
    property var barMenuWindow: null
    property var item: null

    property var position: getPosition()

    component Margins: QtObject {
        property int left: 0
        property int top: 0
        property int right: 0
        property int bottom: 0
    }

    component Anchors: QtObject {
        property bool top: false
        property bool left: false
        property bool right: false
        property bool bottom: false
    }

    property var barMenuComponent: null
    property Margins margins: Margins {
        left: 0
        top: 0
        right: minimalMargins.right
        bottom: minimalMargins.bottom
    }
    property Margins minimalMargins: Margins {
        left: (position.left ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut
        top: (position.top ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut
        right: (position.right ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut
        bottom: (position.bottom ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut
    }

    function getAnchor() {
        let leftAnchor = barWindow.anchors.left;
        let rightAnchor = barWindow.anchors.right;
        let topAnchor = barWindow.anchors.top;
        let bottomAnchor = barWindow.anchors.bottom;

        return {
            top: !(bottomAnchor && !(leftAnchor ^ rightAnchor)),
            left: !(rightAnchor && !(topAnchor ^ bottomAnchor)),
            right: (rightAnchor && !(topAnchor ^ bottomAnchor)),
            bottom: (bottomAnchor && !(leftAnchor ^ rightAnchor))
        };
    }

    function getPosition() {
        let leftAnchor = barWindow.anchors.left;
        let rightAnchor = barWindow.anchors.right;
        let topAnchor = barWindow.anchors.top;
        let bottomAnchor = barWindow.anchors.bottom;

        return {
            top: (topAnchor && !(leftAnchor ^ rightAnchor)),
            left: (leftAnchor && !(topAnchor ^ bottomAnchor)),
            right: (rightAnchor && !(topAnchor ^ bottomAnchor)),
            bottom: (bottomAnchor && !(leftAnchor ^ rightAnchor))
        };
    }

    function getMargins() {
        let pos = getPosition();
        let global = item.mapToGlobal(item.width / 2, item.height / 2);
        let anchorX = pos.top || pos.bottom ? Math.max(global.x + root.hyprlandFocusedMonitorBar.x - barMenuWindow.width / 2, minimalMargins.left) : minimalMargins.left;
        let anchorY = pos.left || pos.right ? Math.max(global.y + root.hyprlandFocusedMonitorBar.y - barMenuWindow.height / 2, minimalMargins.top) : minimalMargins.top;
        console.log(anchorY, hyprlandFocusedMonitor.height - barMenuWindow.height - minimalMargins.bottom, Config.options.bar.margin, Config.options.windowManager.gapsOut);
        return {
            "left": Math.min(anchorX, hyprlandFocusedMonitor.width - barMenuWindow.width - minimalMargins.right),
            "top": Math.min(anchorY, hyprlandFocusedMonitor.height - barMenuWindow.height - minimalMargins.bottom),
            "right": minimalMargins.right,
            "bottom": minimalMargins.bottom
        };
    }
}
