import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import Quickshell
import Quickshell.Io

import qs.modules.common

ColumnLayout {
    id: root
    required property var items
    required property string path
    property list<string> widgetList: []
    property list<string> excludedWidgetList: []

    Process {
        id: getWidgets
        command: ["bash", "-c", "ls " + Directory.trimFileProtocol(root.path) + "/*.qml"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.widgetList = [];
                let wl = this.text.split("\n");
                wl = wl.filter(item => item !== "");
                wl = wl.map(item => {
                    const filename = item.split("/").pop();
                    return filename;
                });
                wl = wl.filter(item => {
                    return !(root.excludedWidgetList.includes(item));
                });
                root.widgetList = wl;
                getUserWidgets.running = true;
            }
        }
    }
    Process {
        id: getUserWidgets
        command: ["bash", "-c", "ls " + Directory.trimFileProtocol(root.path) + "/user/*.qml"]
        stdout: StdioCollector {
            onStreamFinished: {
                let wl = this.text.split("\n");
                wl = wl.filter(item => item !== "");
                wl = wl.forEach(item => {
                    const filename = item.split("/").pop();
                    root.widgetList.push("user--" + filename);
                });
                wlm.open();
            }
        }
    }
    ColumnLayout {
        id: column
        spacing: Variable.margin.smallest
        Layout.margins: Variable.margin.smallest
        Rectangle {
            id: addButton
            HoverHandler {
                id: addHoverHandler
            }
            TapHandler {
                onTapped: {
                    getWidgets.running = true;
                }
            }
            radius: Variable.radius.small
            width: addIcon.width + 16 * Config.options.appearance.uiScale
            height: addIcon.height + 8 * Config.options.appearance.uiScale
            color: "transparent"
            Rectangle {
                width: addHoverHandler.hovered ? parent.width : 2
                height: parent.height
                radius: Variable.radius.smallest
                anchors.verticalCenter: parent.verticalCenter
                color: addHoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                Behavior on width {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }
            Layout.minimumWidth: 150 * Config.options.appearance.uiScale
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            LucideIcon {
                id: addIcon
                icon: "plus"
                color: addHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.small
                font.weight: Font.DemiBold
                font.family: Variable.font.family.main
                label: "Add Widget"
                anchors.centerIn: parent
            }
            Menu {
                id: wlm
                padding: Variable.margin.small
                width: 200 * Config.options.appearance.uiScale
                background: Rectangle {
                    id: backgroundMenu
                    radius: Variable.radius.normal
                    color: Color.colors.surface_container
                }
                Instantiator {
                    model: root.widgetList
                    onObjectAdded: function (index, item) {
                        wlm.addItem(item);
                    }
                    onObjectRemoved: function (index, item) {
                        wlm.removeItem(item);
                    }
                    delegate: MenuItem {
                        background: Rectangle {
                            radius: Variable.radius.small
                            property bool isHovered: false
                            color: isHovered ? Color.colors.primary : "transparent"
                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    background.isHovered = true;
                                }
                                onExited: {
                                    background.isHovered = false;
                                }
                            }
                        }
                        contentItem: Text {
                            Layout.fillWidth: true
                            font.family: Variable.font.family.main
                            font.weight: Font.Normal
                            font.pixelSize: Variable.font.pixelSize.smaller
                            text: modelData.replace("user--", "")
                            color: background.isHovered ? Color.colors.on_primary : Color.colors.on_surface
                        }

                        onTriggered: {
                            root.items.push(modelData);
                            root.itemsChanged();
                        }
                    }
                }
            }
        }
        ColumnLayout {
            id: list
            spacing: Variable.margin.small
            Repeater {
                model: root.items
                delegate: Rectangle {
                    id: itemRoot
                    Layout.minimumWidth: 150 * Config.options.appearance.uiScale
                    Layout.fillWidth: true
                    Layout.preferredHeight: text.height + 8 * Config.options.appearance.uiScale
                    radius: Variable.radius.small
                    property bool hovered: false
                    clip: true
                    color: "transparent"
                    Rectangle {
                        width: parent.width
                        height: 1
                        radius: Variable.radius.smallest
                        anchors.bottom: parent.bottom
                        color: Color.colors.surface_container_high
                    }
                    HoverHandler {
                        id: itemRootHoverHandler
                    }
                    Text {
                        id: text
                        text: modelData.replace("user--", "")
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
                        color: Color.colors.on_surface
                        font.pixelSize: Variable.font.pixelSize.smaller
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 8 * Config.options.appearance.uiScale
                    }
                    Rectangle {
                        opacity: itemRootHoverHandler.hovered ? 1 : 0
                        anchors.fill: parent
                        color: "transparent"
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                        Rectangle {
                            width: 22 * Config.options.appearance.uiScale
                            height: 22 * Config.options.appearance.uiScale
                            LucideIcon {
                                icon: "x"
                                color: closeHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                                font.pixelSize: Variable.font.pixelSize.small
                                anchors.centerIn: parent
                            }
                            anchors.right: parent.right
                            color: closeHoverHandler.hovered ? Color.colors.primary : Color.colors.surface
                            radius: Variable.radius.small
                            anchors.verticalCenter: parent.verticalCenter
                            HoverHandler {
                                id: closeHoverHandler
                            }
                            TapHandler {
                                onTapped: {
                                    root.items.splice(index, 1);
                                    root.itemsChanged();
                                }
                            }
                        }
                        Rectangle {
                            width: 22 * Config.options.appearance.uiScale
                            height: 22 * Config.options.appearance.uiScale
                            LucideIcon {
                                icon: "chevron-down"
                                color: downHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                                font.pixelSize: Variable.font.pixelSize.small
                                anchors.centerIn: parent
                            }
                            anchors.right: parent.right
                            anchors.rightMargin: 28 * Config.options.appearance.uiScale
                            color: downHoverHandler.hovered ? Color.colors.primary : Color.colors.surface
                            radius: Variable.radius.small
                            anchors.verticalCenter: parent.verticalCenter
                            HoverHandler {
                                id: downHoverHandler
                            }
                            TapHandler {
                                onTapped: {
                                    // TODO: switch to the next widget
                                    if (index < root.items.length - 1) {
                                        let temp = root.items[index + 1];
                                        let temp2 = root.items[index];
                                        root.items[index + 1] = temp2;
                                        root.items[index] = temp;
                                    }
                                    root.itemsChanged();
                                }
                            }
                        }
                        Rectangle {
                            width: 22 * Config.options.appearance.uiScale
                            height: 22 * Config.options.appearance.uiScale
                            LucideIcon {
                                icon: "chevron-up"
                                color: upHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                                font.pixelSize: Variable.font.pixelSize.small
                                anchors.centerIn: parent
                            }
                            anchors.right: parent.right
                            anchors.rightMargin: 56 * Config.options.appearance.uiScale
                            color: upHoverHandler.hovered ? Color.colors.primary : Color.colors.surface
                            radius: Variable.radius.small
                            anchors.verticalCenter: parent.verticalCenter
                            HoverHandler {
                                id: upHoverHandler
                            }
                            TapHandler {
                                onTapped: {
                                    // TODO: switch to the previous widget
                                    if (index > 0) {
                                        let temp = root.items[index - 1];
                                        let temp2 = root.items[index];
                                        root.items[index - 1] = temp2;
                                        root.items[index] = temp;
                                    }
                                    root.itemsChanged();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
