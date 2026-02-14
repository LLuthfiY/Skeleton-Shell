import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell

import qs.modules.common
import qs.modules.common.widgets

ListView {
    id: root
    width: parent.width
    spacing: 0
    height: contentHeight
    clip: true
    DropArea {
        anchors.fill: root
    }
    signal itemsUpdated
    property bool fill: false
    property var tempItems: []
    function addItem(item) {
        model.push(item);
        itemsUpdated();
    }
    function moveItem(from, to) {
        if (from === to) {
            itemsUpdated();
            return;
        }
        model.splice(to, 0, model.splice(from, 1)[0]);
        itemsUpdated();
    }
    function removeItem(index) {
        model.splice(index, 1);
        itemsUpdated();
    }
    function changeFill(index, fill) {
        if (fill) {
            model[index] = model[index] + "--fill--";
        } else {
            model[index] = model[index].replace("--fill--", "");
        }
        itemsUpdated();
    }
    delegate: Rectangle {
        id: itemRoot
        required property var modelData
        required property int index
        property int newIndex: 0
        color: Color.colors.surface
        height: text.height + Variable.uiScale(16)
        width: parent?.parent.width ?? 0
        border.width: Variable.uiScale(2)
        border.color: Color.colors.surface
        radius: Variable.radius.smallest
        Behavior on border.color {
            ColorAnimation {
                duration: 200
            }
        }
        Rectangle {
            width: Variable.uiScale(2)
            height: parent.height * 0.6
            radius: Variable.radius.smallest
            anchors.verticalCenter: parent.verticalCenter
            color: Color.colors.primary_container
            anchors.left: parent.left
            anchors.leftMargin: Variable.margin.small
        }
        Rectangle {
            id: wrapper
            anchors.fill: parent
            anchors.leftMargin: Variable.margin.normal
            anchors.rightMargin: Variable.margin.normal
            color: "transparent"
            RowLayout {
                anchors.fill: wrapper
                anchors.leftMargin: Variable.uiScale(16)
                spacing: Variable.uiScale(8)
                Rectangle {
                    height: text.implicitHeight + Variable.uiScale(16)
                    width: text.implicitHeight + Variable.uiScale(16)
                    color: "transparent"
                    DragHandler {
                        target: itemRoot
                        xAxis.enabled: false
                        onActiveChanged: {
                            if (active) {
                                itemRoot.z = 99999;
                                itemRoot.border.color = Color.colors.primary;
                            } else {
                                itemRoot.z = 0;
                                itemRoot.border.color = Color.colors.surface;
                                root.moveItem(itemRoot.index, itemRoot.newIndex);
                            }
                        }
                        onTranslationChanged: {
                            let centerY = itemRoot.y + itemRoot.height / 2;
                            itemRoot.newIndex = Math.floor(centerY / itemRoot.height);
                        }
                    }
                    LucideIcon {
                        icon: "grip-vertical"
                        color: Color.colors.on_surface
                        font.pixelSize: Variable.font.pixelSize.small
                        anchors.centerIn: parent
                        anchors.margins: Variable.margin.normal
                    }
                }
                Text {
                    id: text
                    text: modelData.replace("user--", "").replace("--fill--", "")
                    font.family: Variable.font.family.main
                    font.weight: Font.Normal
                    color: Color.colors.on_surface
                    font.pixelSize: Variable.font.pixelSize.small
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    visible: root.fill
                    text: "fill"
                    font.family: Variable.font.family.main
                    font.weight: Font.Normal
                    color: Color.colors.on_surface
                    font.pixelSize: Variable.font.pixelSize.small
                }
                StyledSwitch {
                    visible: root.fill
                    checked: modelData.includes("--fill--")
                    onClicked: {
                        root.changeFill(index, checked);
                    }
                }
                Rectangle {
                    height: text.implicitHeight + Variable.uiScale(8)
                    width: text.implicitHeight + Variable.uiScale(8)
                    color: removeButtonHoverHandler.hovered ? Color.colors.error : Color.colors.surface
                    radius: Variable.radius.small

                    LucideIcon {
                        id: removeButton
                        icon: "trash"
                        color: removeButtonHoverHandler.hovered ? Color.colors.on_error : Color.colors.error
                        font.pixelSize: Variable.font.pixelSize.small
                        anchors.centerIn: parent
                        anchors.margins: Variable.margin.normal
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }

                    HoverHandler {
                        id: removeButtonHoverHandler
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        onTapped: {
                            root.removeItem(index);
                        }
                    }
                }
            }
        }
    }
}
