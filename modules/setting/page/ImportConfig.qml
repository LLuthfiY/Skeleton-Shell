import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic

import Quickshell
import Quickshell.Io

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

ColumnLayout {
    id: root
    spacing: Variable.margin.small
    width: stackWrapper.width - 24
    FindCommand {
        id: findCommand
        path: Directory.trimFileProtocol(Directory.repos)
        minDepth: 3
        maxDepth: 3
    }
    LucideIcon {
        icon: "download"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.title
        font.weight: Font.Bold
        font.family: Variable.font.family.main
        label: "Import Config"
    }
    LucideIcon {
        icon: "package"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.small
        font.weight: Font.DemiBold
        font.family: Variable.font.family.main
        label: "Import Config"
    }
    RowLayout {
        TextField {
            id: importConfigTextField
            Layout.fillWidth: true
            background: Rectangle {
                color: Color.colors.surface
                radius: Variable.radius.small
                border.color: importConfigTextField.focus ? Color.colors.primary : Color.colors.surface_container
                border.width: 2
            }
        }
        Rectangle {
            Layout.preferredHeight: importConfigButtonIcon.implicitHeight + Variable.margin.small
            Layout.preferredWidth: importConfigButtonIcon.implicitWidth + Variable.margin.normal
            color: importConfigButtonHoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface
            radius: Variable.radius.small
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            HoverHandler {
                id: importConfigButtonHoverHandler
                cursorShape: Git.onProgress ? Qt.BusyCursor : Qt.PointingHandCursor
            }
            LucideIcon {
                id: importConfigButtonIcon
                anchors.centerIn: parent
                font.family: Variable.font.family.main
                font.weight: Font.Normal
                font.pixelSize: Variable.font.pixelSize.small
                color: Color.colors.on_surface
                icon: "download"
                label: "Import"
            }
            TapHandler {
                enabled: !Git.onProgress
                onTapped: {
                    Git.cloneRepo(importConfigTextField.text);
                }
            }
        }
    }
    ColumnLayout {
        spacing: Variable.margin.small
        ReadLinkCommand {
            id: readLinkCommand
            path: Directory.trimFileProtocol(Directory.configFolder)
        }
        Rectangle {
            id: itemLocal
            Layout.fillWidth: true
            Layout.preferredHeight: columnLayoutLocal.implicitHeight + Variable.margin.small * 2
            color: Color.colors.surface_container
            radius: Variable.radius.small
            ColumnLayout {
                id: columnLayoutLocal
                anchors.fill: parent
                anchors.margins: Variable.margin.small
                spacing: Variable.margin.small
                RowLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0
                    LucideIcon {
                        icon: "folder"
                        color: Color.colors.on_surface
                        font.pixelSize: Variable.font.pixelSize.normal
                        font.weight: Font.Bold
                        font.family: Variable.font.family.main
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: Variable.margin.small
                    }
                    Text {
                        id: textLocal
                        text: Directory.trimFileProtocol(Directory.config) + "/Skeleton-Shell"
                        color: Color.colors.on_surface_variant
                        font.pixelSize: Variable.font.pixelSize.smaller
                        font.weight: Font.Normal
                        font.family: Variable.font.family.main
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
                RowLayout {
                    spacing: 0
                    Rectangle {
                        HoverHandler {
                            id: applyHoverHandlerLocal
                            cursorShape: Qt.PointingHandCursor
                        }
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                        radius: Variable.radius.small
                        Layout.preferredHeight: applyIconLocal.implicitHeight + Variable.margin.small
                        Layout.preferredWidth: applyIconLocal.implicitWidth + Variable.margin.normal
                        color: applyHoverHandlerLocal.hovered ? Color.colors.surface_container_high : Color.colors.surface_container
                        LucideIcon {
                            id: applyIconLocal
                            anchors.centerIn: parent
                            icon: "check"
                            label: MasterConfig.options.defaultConfig ? "Applied" : "Apply"
                            color: Color.colors.primary
                            font.pixelSize: Variable.font.pixelSize.small
                            font.weight: Font.DemiBold
                            font.family: Variable.font.family.main
                            Layout.alignment: Qt.AlignVCenter
                        }
                        TapHandler {
                            onTapped: {
                                MasterConfig.options.defaultConfig = true;
                                SoftLink.create(Directory.trimFileProtocol(Directory.config + "/Skeleton-Shell"), Directory.trimFileProtocol(Directory.configFolder));
                                WindowManagerUtils.reloadWM();
                                Quickshell.reload(true);
                            }
                        }
                    }
                }
            }
        }
        Repeater {
            model: findCommand.items
            delegate: Rectangle {
                id: item
                Layout.fillWidth: true
                Layout.preferredHeight: columnLayout.implicitHeight + Variable.margin.small * 2
                color: Color.colors.surface_container
                radius: Variable.radius.small
                property list<string> splittedData: modelData.split("/")
                ColumnLayout {
                    id: columnLayout
                    anchors.fill: parent
                    anchors.margins: Variable.margin.small
                    spacing: Variable.margin.small
                    RowLayout {
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 0
                        LucideIcon {
                            icon: modelData.includes("github.com") ? "github" : modelData.includes("gitlab.com") ? "gitlab" : "git-branch"
                            color: Color.colors.on_surface
                            font.pixelSize: Variable.font.pixelSize.normal
                            font.weight: Font.Bold
                            font.family: Variable.font.family.main
                            Layout.alignment: Qt.AlignVCenter
                            Layout.rightMargin: Variable.margin.small
                        }
                        Text {
                            text: splittedData[splittedData.length - 2] + "/"
                            color: Color.colors.on_surface_variant
                            font.pixelSize: Variable.font.pixelSize.smaller
                            font.weight: Font.Normal
                            font.family: Variable.font.family.main
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Text {
                            text: splittedData[splittedData.length - 1]
                            color: Color.colors.on_surface
                            font.pixelSize: Variable.font.pixelSize.smaller
                            font.weight: Font.Bold
                            font.family: Variable.font.family.main
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Text {
                            text: splittedData[splittedData.length - 3]
                            color: Color.colors.on_surface_variant
                            font.pixelSize: Variable.font.pixelSize.smaller
                            font.weight: Font.Normal
                            font.family: Variable.font.family.main
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                    RowLayout {
                        spacing: 0
                        Rectangle {
                            HoverHandler {
                                id: applyHoverHandler
                                cursorShape: Qt.PointingHandCursor
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            radius: Variable.radius.small
                            Layout.preferredHeight: applyIcon.implicitHeight + Variable.margin.small
                            Layout.preferredWidth: applyIcon.implicitWidth + Variable.margin.small * 2
                            color: applyHoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface_container
                            LucideIcon {
                                id: applyIcon
                                anchors.centerIn: parent
                                icon: "check"
                                label: modelData === readLinkCommand.link ? "Applied" : "Apply"
                                color: Color.colors.primary
                                font.pixelSize: Variable.font.pixelSize.small
                                font.weight: Font.DemiBold
                                font.family: Variable.font.family.main
                                Layout.alignment: Qt.AlignVCenter
                            }
                            TapHandler {
                                onTapped: {
                                    MasterConfig.options.defaultConfig = false;
                                    SoftLink.create(modelData, Directory.trimFileProtocol(Directory.configFolder));
                                    WindowManagerUtils.reloadWM();
                                    Quickshell.reload(true);
                                }
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Rectangle {
                            id: deleteButton
                            Layout.preferredHeight: applyIcon.implicitHeight + Variable.margin.small
                            Layout.preferredWidth: applyIcon.implicitWidth + Variable.margin.small * 2
                            color: deleteButtonHoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface_container
                            radius: Variable.radius.small
                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            HoverHandler {
                                id: deleteButtonHoverHandler
                                cursorShape: Qt.PointingHandCursor
                            }

                            LucideIcon {
                                id: deleteIcon
                                anchors.centerIn: parent
                                icon: "trash"
                                label: "Delete"
                                color: Color.colors.error
                                font.pixelSize: Variable.font.pixelSize.small
                                font.weight: Font.DemiBold
                                font.family: Variable.font.family.main
                                Layout.alignment: Qt.AlignVCenter
                            }
                            TapHandler {
                                enabled: modelData !== readLinkCommand.link
                                onTapped: {
                                    Quickshell.execDetached(["rm", "-rf", modelData]);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
