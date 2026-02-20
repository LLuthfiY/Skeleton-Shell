import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.services
import qs.modules.common
import qs.modules.common.widgets

Scope {
    id: root
    property list<string> providerList: ["ollama"]
    property string pv: Config.options.services.ai.provider
    property var provider: pv === "ollama" ? Ollama : null
    property bool flickable: false

    onFlickableChanged: {
        console.log(flickable);
    }

    property list<string> modelList: []
    PanelWindow {
        id: chatWindow
        visible: Config.ready && GlobalState.aiChatOpen
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null
        WlrLayershell.namespace: "quickshell:aiChat"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: 0
        exclusionMode: ExclusionMode.Ignore
        implicitWidth: Variable.size.aiChatWidth
        color: "transparent"

        anchors.top: true
        anchors.right: Config.options.dashboard.position === "right"
        anchors.left: Config.options.dashboard.position === "left"
        anchors.bottom: true

        Rectangle {
            anchors.fill: parent
            anchors.margins: Config.options.windowManager.gapsOut + Config.options.bar.margin
            color: Color.colors.surface
            radius: Variable.radius.normal
            Rectangle {
                anchors.fill: parent
                anchors.margins: Variable.margin.normal
                color: "transparent"
                clip: true
                ColumnLayout {
                    height: parent.height
                    width: parent.width
                    spacing: Variable.margin.small
                    RowLayout {
                        spacing: Variable.margin.normal
                        Rectangle {
                            border.color: providerHoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
                            border.width: Variable.uiScale(0)
                            radius: Variable.radius.small
                            width: providerIcon.width + Variable.margin.normal
                            height: providerIcon.height + Variable.margin.normal
                            color: providerHoverHandler.hovered ? Color.colors.primary : "transparent"
                            HoverHandler {
                                id: providerHoverHandler
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            LucideIcon {
                                id: providerIcon
                                icon: root.provider.active ? "brain" : "circle-slash"
                                color: providerHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                                label: Config.options.services.ai.provider
                                anchors.centerIn: parent
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                            }
                            TapHandler {
                                onTapped: {
                                    providerMenu.open();
                                }
                            }

                            Menu {
                                id: providerMenu
                                implicitWidth: Variable.uiScale(200)
                                padding: Variable.margin.small
                                background: Rectangle {
                                    id: backgroundMenu
                                    radius: Variable.radius.small
                                    color: Color.colors.surface_container
                                }
                                Instantiator {
                                    model: root.providerList
                                    onObjectAdded: function (index, item) {
                                        providerMenu.addItem(item);
                                    }
                                    onObjectRemoved: function (index, item) {
                                        providerMenu.removeItem(item);
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
                                            text: modelData
                                            font.family: Variable.font.family.main
                                            font.weight: Font.Normal
                                            font.pixelSize: Variable.font.pixelSize.smaller
                                            color: background.isHovered ? Color.colors.on_primary : Color.colors.on_surface
                                        }
                                        onTriggered: {
                                            Config.options.services.ai.provider = modelData;
                                        }
                                    }
                                }
                            }
                        }
                        Rectangle {
                            id: modelButton
                            border.color: modelHoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
                            border.width: Variable.uiScale(0)
                            radius: Variable.radius.small
                            width: modelIcon.width + Variable.margin.normal
                            height: modelIcon.height + Variable.margin.normal
                            color: modelHoverHandler.hovered ? Color.colors.primary : "transparent"
                            HoverHandler {
                                id: modelHoverHandler
                            }
                            TapHandler {
                                onTapped: {
                                    root.modelList = root.provider.models;
                                    modelMenu.open();
                                }
                            }
                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            LucideIcon {
                                id: modelIcon
                                icon: "package"
                                color: modelHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                                label: Config.options.services.ai[Config.options.services.ai.provider].model
                                anchors.centerIn: parent
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                            }
                            Menu {
                                id: modelMenu
                                implicitWidth: Variable.uiScale(200)
                                padding: Variable.margin.small
                                background: Rectangle {
                                    id: backgroundMenuModel
                                    radius: Variable.radius.small
                                    color: Color.colors.surface_container
                                }

                                Instantiator {
                                    model: root.modelList
                                    onObjectAdded: function (index, item) {
                                        modelMenu.addItem(item);
                                    }
                                    onObjectRemoved: function (index, item) {
                                        modelMenu.removeItem(item);
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
                                            text: modelData
                                            font.family: Variable.font.family.main
                                            font.weight: Font.Normal
                                            font.pixelSize: Variable.font.pixelSize.smaller
                                            color: background.isHovered ? Color.colors.on_primary : Color.colors.on_surface
                                        }
                                        onTriggered: {
                                            Config.options.services.ai[Config.options.services.ai.provider].model = modelData;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    ListView {
                        id: listView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: root.provider.chatHistory
                        spacing: Variable.margin.large
                        // Connections {
                        //     target: root.provider
                        //     onChatUpdated: {
                        //         Qt.callLater(listView.positionViewAtEnd);
                        //     }
                        // }
                        delegate: ChatBox {
                            text: modelData.text
                            isUser: modelData.isUser
                            isFlickable: root.flickable
                            isLoading: modelData.isLoading
                            model: modelData.model
                        }
                        Behavior on contentY {
                            NumberAnimation {
                                duration: 100
                            }
                        }
                        // function toDown() {
                        //     listView.contentY = Math.min(0, listView.contentY + listView.originY);
                        // }
                        //
                        // onCountChanged: {
                        //     // Qt.callLater(listView.positionViewAtEnd);
                        //     Qt.callLater(toDown);
                        // }
                        verticalLayoutDirection: ListView.BottomToTop

                        clip: true
                    }
                    Rectangle {
                        property bool active: false
                        border.color: active ? Color.colors.primary : Color.colors.primary_container
                        border.width: Variable.uiScale(2)
                        radius: Variable.radius.small
                        color: "transparent"
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: inputField.contentHeight + buttonLayout.height + Variable.margin.normal * 2
                        TextArea {
                            id: inputField
                            anchors.fill: parent
                            anchors.margins: Variable.margin.small
                            font.family: Variable.font.family.main
                            font.weight: Font.Normal
                            font.pixelSize: Variable.font.pixelSize.normal
                            color: Color.colors.on_surface
                            placeholderText: "Ask me anything..."
                            placeholderTextColor: "#888888"
                            selectByMouse: true
                            wrapMode: TextEdit.Wrap
                            focus: true
                            background: Rectangle {
                                color: Color.colors.surface
                                radius: Variable.radius.small
                            }
                            Keys.onReturnPressed: {
                                root.provider.sendMessage(inputField.text);
                                inputField.text = "";
                            }
                            Keys.onPressed: function (event) {
                                if (event.modifiers & Qt.ControlModifier) {
                                    root.flickable = true;
                                }
                            }
                            Keys.onReleased: function (event) {
                                if (event.modifiers & Qt.ControlModifier) {
                                    root.flickable = false;
                                }
                            }
                        }
                        RowLayout {
                            id: buttonLayout
                            spacing: Variable.margin.small
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.left: parent.left
                            anchors.margins: Variable.margin.small
                            Rectangle {
                                id: addItemButton
                                visible: false
                                width: addItemIcon.width + Variable.margin.normal
                                height: addItemIcon.height + Variable.margin.normal
                                color: addItemHoverHandler.hovered ? Color.colors.primary : "transparent"
                                radius: Variable.radius.small

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                                HoverHandler {
                                    id: addItemHoverHandler
                                    cursorShape: Qt.PointingHandCursor
                                }
                                LucideIcon {
                                    id: addItemIcon
                                    icon: "plus"
                                    color: addItemHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                                    anchors.centerIn: parent
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 200
                                        }
                                    }
                                }
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            Rectangle {
                                id: sendButton
                                width: sendIcon.width + Variable.margin.normal
                                height: sendIcon.height + Variable.margin.normal
                                color: sendHoverHandler.hovered ? Color.colors.primary : "transparent"
                                radius: Variable.radius.small
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                                HoverHandler {
                                    id: sendHoverHandler
                                    cursorShape: Qt.PointingHandCursor
                                }
                                LucideIcon {
                                    id: sendIcon
                                    icon: "send"
                                    color: sendHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                                    anchors.centerIn: parent
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 200
                                        }
                                    }
                                }

                                TapHandler {
                                    onTapped: {
                                        root.provider.sendMessage(inputField.text);
                                        inputField.text = "";
                                        listView.positionViewAtEnd();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
