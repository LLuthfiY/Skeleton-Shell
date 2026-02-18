import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import Quickshell
import Quickshell.Io

import qs.services
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    property string text: ""
    property bool isUser: false
    implicitHeight: layout.height
    width: ListView.view.width
    color: "transparent"
    ColumnLayout {
        id: layout
        width: parent.width
        spacing: 0
        anchors.verticalCenter: parent.verticalCenter
        Text {
            id: message
            text: root.text
            Layout.maximumWidth: root.width - Variable.margin.normal * 4
            font.family: Variable.font.family.main
            font.weight: Font.Normal
            font.pixelSize: Variable.font.pixelSize.small
            color: root.text === "Thinking..." ? "#777777" : Color.colors.on_surface_variant
            textFormat: Text.MarkdownText
            wrapMode: Text.Wrap
            Layout.alignment: root.isUser ? Qt.AlignRight : Qt.AlignLeft
            Layout.margins: Variable.margin.normal
        }
        RowLayout {
            id: buttonRow
            spacing: Variable.margin.small
            Layout.alignment: root.isUser ? Qt.AlignRight : Qt.AlignLeft
            property var buttons: [
                {
                    "icon": "copy",
                    "onClicked": function () {
                        Clipboard.text = message.text;
                    }
                }
            ]
            Repeater {
                model: buttonRow.buttons
                delegate: Rectangle {
                    width: buttonIcon.width + Variable.margin.normal
                    height: buttonIcon.height + Variable.margin.normal
                    color: buttonHoverHandler.hovered ? Color.colors.primary : "transparent"
                    radius: Variable.radius.small
                    Layout.margins: Variable.margin.normal
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                    HoverHandler {
                        id: buttonHoverHandler
                    }
                    TapHandler {
                        onTapped: {
                            modelData.onClicked();
                        }
                    }
                    LucideIcon {
                        id: buttonIcon
                        icon: modelData.icon
                        color: buttonHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                        anchors.centerIn: parent
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }
                }
            }
        }
    }
    Rectangle {
        id: indicator
        anchors.right: root.isUser ? parent.right : undefined
        anchors.left: root.isUser ? undefined : parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: Variable.uiScale(2)
        height: parent.height / 2
        radius: width / 2
        color: Color.colors.primary_container
    }
}
