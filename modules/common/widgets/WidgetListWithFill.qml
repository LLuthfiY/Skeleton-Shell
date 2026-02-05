import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell
import Quickshell.Io

import qs.modules.common

ColumnLayout {
    id: root
    required property var items
    required property string path
    property list<string> widgetList: []
    Rectangle {
        color: Color.colors.surface_container
        anchors.fill: parent.fill
        radius: Variable.radius.small
    }

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
                    console.log(item, item !== "CustomTrayMenu.qml" && item !== "DynamicLayout.qml");
                    return item !== "CustomTrayMenu.qml" && item !== "DynamicLayout.qml";
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
                    root.widgetList.push("user---" + filename);
                });
                wlm.open();
            }
        }
    }
    ColumnLayout {
        id: column
        spacing: 4
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
            color: addHoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface_container
            radius: Variable.radius.small
            width: addIcon.width + 16
            height: addIcon.height + 8
            Layout.minimumWidth: 150
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            LucideIcon {
                id: addIcon
                icon: "plus"
                color: Color.colors.on_surface
                font.pixelSize: Variable.font.pixelSize.small
                font.weight: Font.DemiBold
                font.family: Variable.font.family.main
                label: "Add Widget"
                anchors.centerIn: parent
            }
            Menu {
                id: wlm
                implicitWidth: 200
                background: Rectangle {
                    id: backgroundMenu
                    radius: 12
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
                            radius: 8
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
                        contentItem: RowLayout {
                            Text {
                                Layout.fillWidth: true
                                text: modelData.replace("user--", "")
                                color: background.isHovered ? Color.colors.on_primary : Color.colors.primary
                            }
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
            spacing: 4
            Repeater {
                model: ScriptModel {
                    values: root.items
                }
                delegate: Rectangle {
                    id: itemRoot
                    Layout.minimumWidth: 150
                    Layout.fillWidth: true
                    Layout.preferredHeight: text.height + 8
                    color: Color.colors.surface_container_high
                    radius: Variable.radius.small
                    property bool hovered: false
                    clip: true
                    HoverHandler {
                        id: itemRootHoverHandler
                    }
                    Text {
                        id: text
                        text: modelData.replace("user--", "").replace("--fill--", "")
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
                        color: Color.colors.on_surface
                        font.pixelSize: Variable.font.pixelSize.smaller
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 8
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
                            width: 24
                            height: 24
                            LucideIcon {
                                icon: "x"
                                color: Color.colors.on_surface
                                font.pixelSize: Variable.font.pixelSize.small
                                anchors.centerIn: parent
                            }
                            anchors.right: parent.right
                            color: closeHoverHandler.hovered ? Color.colors.surface : Color.colors.surface_container_high
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
                            width: 24
                            height: 24
                            LucideIcon {
                                icon: "chevron-down"
                                color: Color.colors.on_surface
                                font.pixelSize: Variable.font.pixelSize.small
                                anchors.centerIn: parent
                            }
                            anchors.right: parent.right
                            anchors.rightMargin: 28
                            color: downHoverHandler.hovered ? Color.colors.surface : Color.colors.surface_container_high
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
                            width: 24
                            height: 24
                            LucideIcon {
                                icon: "chevron-up"
                                color: Color.colors.on_surface
                                font.pixelSize: Variable.font.pixelSize.small
                                anchors.centerIn: parent
                            }
                            anchors.right: parent.right
                            anchors.rightMargin: 56
                            color: upHoverHandler.hovered ? Color.colors.surface : Color.colors.surface_container_high
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
                        StyledSwitch {
                            checked: modelData.includes("--fill--")
                            anchors.right: parent.right
                            anchors.rightMargin: 80
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                if (modelData.includes("--fill--")) {
                                    root.items[index] = modelData.replace("--fill--", "");
                                } else {
                                    root.items[index] = modelData + "--fill--";
                                }
                                root.itemsChanged();
                            }
                        }

                        Text {
                            text: "Fill"
                            font.family: Variable.font.family.main
                            font.weight: Font.Normal
                            color: Color.colors.on_surface
                            font.pixelSize: Variable.font.pixelSize.smaller
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 124
                        }
                    }
                }
            }
        }
    }
}
