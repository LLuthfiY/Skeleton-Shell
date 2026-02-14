import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell

import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    width: parent.width
    height: root.height
    property var items: []
    color: "transparent"
    ListView {
        id: listView
        width: parent.width
        height: contentHeight
        spacing: 8
        DropArea {
            anchors.fill: listView.fill
        }
        model: ScriptModel {
            values: root.items
        }
        delegate: Rectangle {
            id: itemRoot
            required property var modelData
            required property int index
            color: Color.colors.surface
            height: text.height + uiScale(16)
            width: parent?.parent.width ?? 0
            border.width: uiScale(2)
            border.color: Color.colors.surface
            radius: Variable.radius.smallest
            Behavior on border.color {
                ColorAnimation {
                    duration: 200
                }
            }
            Rectangle {
                width: uiScale(2)
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
                    anchors.leftMargin: uiScale(16)
                    spacing: uiScale(8)
                    Rectangle {
                        height: text.implicitHeight + uiScale(16)
                        width: text.implicitHeight + uiScale(16)
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
                                }
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
                        text: "fill"
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
                        color: Color.colors.on_surface
                        font.pixelSize: Variable.font.pixelSize.small
                    }
                    StyledSwitch {}
                    Rectangle {
                        height: text.implicitHeight
                        width: text.implicitHeight
                        color: removeButtonHoverHandler.hovered ? Color.colors.primary : Color.colors.on_surface
                        radius: Variable.radius.smallest
                        anchors.verticalCenter: parent.verticalCenter

                        LucideIcon {
                            id: removeButton
                            icon: "trash"
                            color: Color.colors.on_surface
                            font.pixelSize: Variable.font.pixelSize.small
                            anchors.centerIn: parent
                            anchors.margins: Variable.margin.normal
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
                                listView.model.remove(index);
                            }
                        }
                    }
                }
            }
        }
    }
}
