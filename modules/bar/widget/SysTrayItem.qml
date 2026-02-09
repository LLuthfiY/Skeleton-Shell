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
    radius: Variable.radius.small
    width: Variable.size.large
    height: Variable.size.large

    IconImage {
        id: trayIcon
        visible: true
        source: modelData.icon
        anchors.fill: parent
        anchors.margins: Variable.size.large * 0.1
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
                let anchorX = barPosition === "left" ? Variable.margin.large : barPosition === "right" ? -Variable.margin.large : 0;
                let anchorY = barPosition === "top" ? Variable.margin.large : barPosition === "bottom" ? -Variable.margin.large : 0;
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
