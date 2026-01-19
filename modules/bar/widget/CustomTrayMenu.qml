import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

Menu {
    id: styledMenu
    parent: Overlay.overlay

    // The tray item we mirror from
    required property SystemTrayItem item

    // Track dynamic objects to destroy them safely
    property var dynamicItems: []

    background: Rectangle {
        color: "#222"
        radius: 8
        border.color: "#555"
    }

    // ====== Build menu from trayItem ======
    function rebuild() {
        // Clean up old
        for (let i = 0; i < dynamicItems.length; i++) {
            let obj = dynamicItems[i];
            if (obj && obj.destroy)
                obj.destroy();
        }
        dynamicItems = [];

        if (!trayItem || !trayItem.menu || !trayItem.menu.entries) {
            console.log("CustomTrayMenu: no menu available");
            return;
        }

        let entries = trayItem.menu.entries;
        // Some environments expose as QML List, some as Array
        let len = entries.length !== undefined ? entries.length : 0;

        for (let i = 0; i < len; i++) {
            addEntry(entries[i], styledMenu);
        }
    }

    // ====== Add an entry ======
    function addEntry(entry, parentMenu) {
        var obj = null;

        if (entry.type === "item") {
            obj = Qt.createQmlObject(`
                import QtQuick
                import QtQuick.Controls
                MenuItem {
                    text: ${JSON.stringify(entry.text)}
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 14
                    }
                    onTriggered: entry.activate()
                }
            `, parentMenu, "DynamicMenuItem");
            parentMenu.addItem(obj);
        } else if (entry.type === "separator") {
            obj = Qt.createQmlObject(`
                import QtQuick
                import QtQuick.Controls
                MenuSeparator {
                    contentItem: Rectangle {
                        height: 1
                        color: "#666"
                    }
                }
            `, parentMenu, "DynamicSeparator");
            parentMenu.addItem(obj);
        } else if (entry.type === "submenu") {
            obj = Qt.createQmlObject(`
                import QtQuick
                import QtQuick.Controls
                Menu {
                    title: ${JSON.stringify(entry.text)}
                    background: Rectangle {
                        color: "#333"
                        radius: 6
                        border.color: "#444"
                    }
                }
            `, parentMenu, "DynamicSubmenu");
            parentMenu.addMenu(obj);

            if (entry.menu && entry.menu.entries) {
                let subentries = entry.menu.entries;
                let len = subentries.length !== undefined ? subentries.length : 0;
                for (let i = 0; i < len; i++) {
                    addEntry(subentries[i], obj);
                }
            }
        }

        if (obj) {
            dynamicItems = dynamicItems.concat([obj]);
        }
    }
}
