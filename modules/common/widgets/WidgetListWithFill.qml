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
    property bool fill: false
    Layout.fillWidth: true
    width: parent.width

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
            width: addIcon.width + Variable.uiScale(16)
            height: addIcon.height + Variable.uiScale(8)
            color: "transparent"
            Rectangle {
                width: addHoverHandler.hovered ? parent.width : Variable.uiScale(2)
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
            Layout.minimumWidth: Variable.uiScale(150)
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
                implicitWidth: Variable.uiScale(200)
                padding: Variable.margin.small
                background: Rectangle {
                    id: backgroundMenu
                    radius: Variable.radius.small
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
                            text: modelData.replace("user--", "")
                            font.family: Variable.font.family.main
                            font.weight: Font.Normal
                            font.pixelSize: Variable.font.pixelSize.smaller
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
        DraggableListView {
            id: list
            model: root.items
            Layout.fillWidth: true
            Layout.preferredHeight: list.contentHeight
            fill: root.fill
            onItemsUpdated: {
                root.items = list.model;
            }
        }
    }
}
