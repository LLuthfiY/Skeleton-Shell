import QtQuick
import QtQuick.Controls
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
    property string model: "Gemma3:1b"
    property bool isLoading: false
    property bool isDummy: false
    implicitHeight: isDummy ? 0 : layout.height
    width: ListView.view.width
    color: "transparent"
    property bool isFlickable: false
    ColumnLayout {
        id: layout
        visible: !root.isDummy
        width: parent.width
        spacing: Variable.margin.smallest
        anchors.verticalCenter: parent.verticalCenter
        Flickable {
            id: scrollView
            Layout.fillWidth: true
            Layout.preferredHeight: message.height
            flickableDirection: Flickable.HorizontalAndVerticalFlick
            interactive: root.isFlickable
            Text {
                id: message
                text: root.text
                width: layout.width - Variable.margin.normal * 2
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                font.pixelSize: Variable.font.pixelSize.smaller
                color: root.text === "Thinking..." ? "#777777" : Color.colors.on_surface_variant
                textFormat: Text.MarkdownText
                wrapMode: Text.Wrap
            }
        }
        RowLayout {
            id: infoRow
            spacing: 0
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                radius: Variable.radius.small
                border.width: 1
                border.color: Color.colors.primary_container
                clip: true
            }
            RowLayout {
                id: buttonRow
                spacing: Variable.margin.small
                Layout.fillWidth: true
                property var buttons: [
                    {
                        "icon": "copy",
                        "onClicked": function () {
                            textEdit.selectAll();
                            textEdit.copy();
                        }
                    }
                ]
                TextEdit {
                    id: textEdit
                    visible: false
                    text: root.text
                }
                Repeater {
                    model: buttonRow.buttons
                    delegate: Rectangle {
                        width: buttonIcon.width + Variable.margin.normal
                        height: buttonIcon.height + Variable.margin.normal
                        color: buttonHoverHandler.hovered ? Color.colors.primary : "transparent"
                        radius: Variable.radius.small
                        clip: true
                        Layout.margins: Variable.margin.smallest
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
                        // PointBackground {
                        //     anchors.fill: parent
                        //     dotRadius: 1
                        //     dotSpacing: 4
                        //     color: "transparent"
                        // }
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
            Text {
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                font.pixelSize: Variable.font.pixelSize.smaller
                text: root.isUser ? "by: You " : "by: " + root.model
                color: Color.colors.on_surface_variant
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                visible: root.isLoading
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                font.pixelSize: Variable.font.pixelSize.smaller
                text: "Thinking..."
                color: "#777777"
                Layout.rightMargin: Variable.margin.normal
            }
        }
    }
    // Rectangle {
    //     id: indicator
    //     anchors.right: root.isUser ? parent.right : undefined
    //     anchors.left: root.isUser ? undefined : parent.left
    //     anchors.verticalCenter: parent.verticalCenter
    //     width: Variable.uiScale(2)
    //     height: parent.height / 2
    //     radius: width / 2
    //     color: Color.colors.primary_container
    // }
}
