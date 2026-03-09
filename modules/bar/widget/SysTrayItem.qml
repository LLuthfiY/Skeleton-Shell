import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Layouts

import qs.modules.common
import qs.modules.common.widgets

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
            console.log(w, h);
            //
            // styledMenu.anchor.rect = Qt.rect(w, h, 0, 0);
            // styledMenu.open();
            menuOpener.menu = modelData.menu;
            GlobalState.barMenuComponent = menuComponent;
            GlobalState.barMenuOpen = true;
        }
    }

    QsMenuOpener {
        id: menuOpener
        menu: modelData.menu
    }

    Component {
        id: menuComponent
        ColumnLayout {
            id: col
            spacing: 0
            Repeater {
                model: menuOpener.children
                delegate: Rectangle {
                    height: modelData.isSeparator ? 2 : row.height + Variable.margin.small
                    width: row.width + Variable.margin.small
                    Layout.fillWidth: true
                    Layout.margins: modelData.isSeparator ? Variable.margin.small : 0
                    HoverHandler {
                        id: menuItemHover
                    }
                    color: modelData.isSeparator ? Color.colors.surface_container_high : menuItemHover.hovered ? Color.colors.surface_container : Color.colors.surface
                    radius: Variable.radius.small
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                    TapHandler {
                        enabled: modelData.enabled
                        onTapped: {
                            if (modelData.hasChildren) {
                                menuOpener.menu = modelData.menu;
                            } else {
                                modelData.triggered();
                            }
                            GlobalState.barMenuOpen = false;
                        }
                    }
                    RowLayout {
                        id: row
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle {
                            height: Variable.size.large
                            width: Variable.size.large
                            color: "transparent"
                            Image {
                                source: modelData.icon
                                // To get the best image quality, set the image source size to the same size
                                // as the rendered image.
                                sourceSize.width: width
                                sourceSize.height: height
                                anchors.centerIn: parent
                            }
                        }
                        Text {
                            text: modelData.text
                            color: Color.colors.on_surface
                            font.pixelSize: Variable.font.pixelSize.small
                            font.family: Variable.font.family.main
                            font.weight: Font.Normal
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        LucideIcon {
                            property int state: modelData.checkState
                            property var type: modelData.buttonType
                            icon: {
                                if (type === QsMenuButtonType.CheckBox) {
                                    if (state === 0) {
                                        return "square";
                                    }
                                    if (state === 1) {
                                        return "square-slash";
                                    }
                                    return "square-check";
                                }
                                if (type === QsMenuButtonType.RadioButton) {
                                    if (state === 0) {
                                        return "circle";
                                    }
                                    if (state === 1) {
                                        return "circle-slash";
                                    }
                                    return "circle-check";
                                }
                                return "";
                            }
                        }
                    }
                }
            }
        }
    }

    // QsMenuAnchor {
    //     id: styledMenu
    //     anchor.window: barWindow
    //     menu: modelData.menu
    // }
}
