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

    TapHandler {
        onTapped: {
            modelData.activate();
        }
    }
    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: mouse => {
            let barPosition = Config.options.bar.position;
            let vertical = barPosition === "left" || barPosition === "right";
            console.log(mouse);
            let global = trayItem.mapToGlobal(mouse.globalPosition.x, mouse.globalPosition.y);
            let anchorX = barPosition === "left" ? Variable.margin.large : barPosition === "right" ? -Variable.margin.large : 0;
            let anchorY = barPosition === "top" ? Variable.margin.large : barPosition === "bottom" ? -Variable.margin.large : 0;
            let w = global.x + anchorX;
            let h = global.y + anchorY;

            // modelData.display(barWindow, w, h);
            console.log(global.x, global.y, anchorX, anchorY);
            styledMenu.anchor.rect = Qt.rect(w, h, 0, 0);
            styledMenu.open();
        }
    }

    QsMenuAnchor {
        id: styledMenu
        anchor.window: barWindow
        menu: modelData.menu
    }
}
