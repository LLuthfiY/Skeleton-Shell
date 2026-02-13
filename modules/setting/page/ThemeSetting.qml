import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Quickshell
import Quickshell.Io

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

import Qt5Compat.GraphicalEffects

Flickable {
    id: flickable
    clip: true
    height: stackWrapper.height
    width: stackWrapper.width
    ScrollBar.vertical: ScrollBar {}
    contentWidth: root.width - 16 * Config.options.appearance.uiScale
    contentHeight: root.height
    ColumnLayout {
        id: root
        width: stackWrapper.width - 16 * Config.options.appearance.uiScale
        spacing: Variable.margin.small
        function setTheme() {
            let palette = Config.options.appearance.palette.type;
            let darkMode = Config.options.appearance.darkMode ? "dark" : "light";
            let wallpaperPath = Config.options.background.wallpaperPath.toString().replace("file://", "");
            Quickshell.execDetached(["matugen", "-t", palette, "-m", darkMode, "image", wallpaperPath]);
            Quickshell.execDetached(["gsettings", "set", "org.gnome.desktop.interface", "color-scheme", `prefer-${palette}`]);
            WindowManagerUtils.setWM();
        }
        LucideIcon {
            icon: "paint-roller"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.title
            font.weight: Font.Bold
            label: "Theme"
        }
        Rectangle {
            color: "transparent"
            radius: Variable.radius.normal
            width: 500 * Config.options.appearance.uiScale
            height: 250 * Config.options.appearance.uiScale
            Rectangle {
                id: wallpaperWrapper
                anchors.fill: parent
                color: Color.colors.surface_container
                radius: Variable.radius.normal
                clip: true
                Image {
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: wallpaperWrapper.width
                            height: wallpaperWrapper.height
                            radius: Variable.radius.normal
                            color: "black"
                        }
                    }
                    anchors.fill: parent
                    source: Config.options.background.wallpaperPath.toString().replace("file://", "")
                    fillMode: Image.PreserveAspectCrop
                }
                Rectangle {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: Variable.margin.small
                    radius: Variable.radius.small
                    width: selectWallpaperIcon.width + Variable.size.normal
                    height: selectWallpaperIcon.height + Variable.size.small
                    color: selectWallpaperHoverHandler.hovered ? Color.colors.primary : Color.colors.surface
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                    HoverHandler {
                        id: selectWallpaperHoverHandler
                    }
                    TapHandler {
                        onTapped: {
                            wallpaperDialog.open();
                        }
                    }
                    LucideIcon {
                        id: selectWallpaperIcon
                        icon: "image"
                        color: selectWallpaperHoverHandler.hovered ? Color.colors.on_primary : Color.colors.on_surface
                        anchors.centerIn: parent
                        font.weight: Font.Normal
                        font.family: Variable.font.family.main
                        font.pixelSize: Variable.font.pixelSize.normal
                        label: "Select Wallpaper"
                    }
                    FileDialog {
                        id: wallpaperDialog
                        title: "Select Wallpaper"
                        currentFolder: Directory.home
                        nameFilters: ["Images (*.png *.jpg *.jpeg)"]
                        onAccepted: {
                            Config.options.background.wallpaperPath = selectedFile;
                            root.setTheme();
                        }
                    }
                }
            }
        }
        RowLayout {
            spacing: Variable.margin.small
            Rectangle {
                id: lightModeButton
                width: lightModeIcon.width + Variable.size.normal
                height: lightModeIcon.height + Variable.size.small
                radius: Variable.radius.small
                color: "transparent"
                Rectangle {
                    width: !Config.options.appearance.darkMode ? parent.width : lightModeHoverHandler.hovered ? parent.width : 2
                    height: parent.height
                    radius: Variable.radius.smallest
                    anchors.verticalCenter: parent.verticalCenter
                    color: !Config.options.appearance.darkMode ? Color.colors.primary : Color.colors.primary_container
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
                LucideIcon {
                    id: lightModeIcon
                    icon: "sun"
                    color: !Config.options.appearance.darkMode ? Color.colors.on_primary : Color.colors.on_surface
                    anchors.centerIn: parent
                    label: "Light Mode"
                    font.weight: Font.Normal
                    font.family: Variable.font.family.main
                    font.pixelSize: Variable.font.pixelSize.normal
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                TapHandler {
                    onTapped: {
                        Config.options.appearance.darkMode = false;
                        root.setTheme();
                    }
                }
                HoverHandler {
                    id: lightModeHoverHandler
                }
            }
            Rectangle {
                id: darkModeButton
                property bool hovered: false
                width: darkModeIcon.width + Variable.size.normal
                height: darkModeIcon.height + Variable.size.small
                radius: Variable.radius.small
                color: "transparent"
                Rectangle {
                    width: Config.options.appearance.darkMode ? parent.width : darkModeHoverHandler.hovered ? parent.width : 2
                    height: parent.height
                    radius: Variable.radius.smallest
                    anchors.verticalCenter: parent.verticalCenter
                    color: Config.options.appearance.darkMode ? Color.colors.primary : Color.colors.primary_container
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
                LucideIcon {
                    id: darkModeIcon
                    icon: "moon"
                    color: Config.options.appearance.darkMode ? Color.colors.on_primary : Color.colors.on_surface
                    anchors.centerIn: parent
                    label: "Dark Mode"
                    font.weight: Font.Normal
                    font.family: Variable.font.family.main
                    font.pixelSize: Variable.font.pixelSize.normal
                }
                HoverHandler {
                    id: darkModeHoverHandler
                }
                TapHandler {
                    onTapped: {
                        Config.options.appearance.darkMode = !Config.options.appearance.darkMode;
                        root.setTheme();
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }
        }
        LucideIcon {
            icon: "palette"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.small
            font.weight: Font.DemiBold
            font.family: Variable.font.family.main
            label: "Palette"
        }
        Flow {
            Layout.preferredWidth: root.width
            spacing: 8
            Repeater {
                model: ["scheme-tonal-spot", "scheme-content", "scheme-expressive", "scheme-fruit-salad", "scheme-monochrome", "scheme-neutral", "scheme-rainbow"]
                delegate: Rectangle {
                    property bool hovered: false
                    width: text.width + Variable.size.normal
                    height: text.height + Variable.size.small
                    radius: Variable.radius.small
                    color: "transparent"
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                    TapHandler {
                        onTapped: {
                            Config.options.appearance.palette.type = modelData;
                            root.setTheme();
                        }
                    }
                    HoverHandler {
                        id: schemeHoverHandler
                    }
                    Rectangle {
                        width: Config.options.appearance.palette.type === modelData ? parent.width : schemeHoverHandler.hovered ? parent.width : 2
                        height: parent.height
                        radius: Variable.radius.smallest
                        anchors.verticalCenter: parent.verticalCenter
                        color: Config.options.appearance.palette.type === modelData ? Color.colors.primary : Color.colors.primary_container
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
                    Text {
                        id: text
                        text: modelData
                        anchors.centerIn: parent
                        font.family: Variable.font.family.main
                        font.weight: Font.Normal
                        font.pixelSize: Variable.font.pixelSize.normal
                        color: Config.options.appearance.palette.type === modelData ? Color.colors.on_primary : Color.colors.on_surface
                    }
                }
            }
        }
    }
}
