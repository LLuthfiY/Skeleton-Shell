import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick.Controls

import qs.modules.common

Rectangle {
    id: trayItem
    required property SystemTrayItem modelData
    color: "#77" + Color.colors[Config.options.bar.foreground].substring(1)
    radius: 8
    width: 24
    height: 24

    IconImage {
        id: trayIcon
        visible: true
        source: modelData.icon
        anchors.fill: parent
        anchors.margins: 4
        width: parent.width
        height: parent.height
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                modelData.activate();
            } else if (mouse.button === Qt.RightButton) {
                let barPosition = Config.options.bar.position;
                let vertical = barPosition === "left" || barPosition === "right";

                let global = trayItem.mapToGlobal(mouse.x, mouse.y);
                let anchorX = barPosition === "left" ? 20 : barPosition === "right" ? -20 : 0;
                let anchorY = barPosition === "top" ? 20 : barPosition === "bottom" ? -20 : 0;
                let w = global.x + anchorX;
                let h = global.y + anchorY;

                // modelData.display(barWindow, w, h);

                // styledMenu.x = global.x;
                // styledMenu.y = global.y;
                styledMenu.anchor.rect = Qt.rect(w, h, 0, 0);
                styledMenu.open();
            }
        }
    }

    QsMenuAnchor {
        id: styledMenu
        anchor.window: barWindow
        menu: modelData.menu
    }
}
