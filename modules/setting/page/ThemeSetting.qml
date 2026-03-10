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

// ScrollView {
//     id: flickable
//     clip: true
//     height: stackWrapper.height
//     width: stackWrapper.width
//     // ScrollBar.vertical: ScrollBar {}
//     contentWidth: root.width - Variable.uiScale(16)
//     contentHeight: root.height + Variable.uiScale(16)
ColumnLayout {
    id: root
    width: stackWrapper.width - Variable.uiScale(32)
    spacing: Variable.margin.small
    LucideIcon {
        icon: "paint-roller"
        color: Color.colors.on_surface
        font.pixelSize: Variable.font.pixelSize.title
        font.weight: Font.Bold
        font.family: Variable.font.family.main
        label: "Theme"
    }
    Rectangle {
        color: "transparent"
        radius: Variable.radius.normal
        width: Variable.uiScale(500)
        height: Variable.uiScale(250)
        Rectangle {
            id: wallpaperWrapper
            anchors.fill: parent
            color: Color.colors.surface_container
            radius: Variable.radius.normal
            clip: true
            Image {
                id: wallpaperImage
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
                // source: Config.options.background.wallpaperPath.toString().replace("file://", "")
                source: GlobalState.wallapaperPath
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
                        Quickshell.execDetached(["cp", Directory.trimFileProtocol(selectedFile.toString()), Directory.trimFileProtocol(Directory.configFolder + "/wallpaper")]);
                        if (Config.options.appearance.colorFromWallpaper) {
                            Matugen.fromWallpaper();
                        }
                    }
                }
            }
        }
    }
    RowLayout {
        Layout.preferredWidth: root.width
        LucideIcon {
            icon: "palette"
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.small
            font.weight: Font.DemiBold
            font.family: Variable.font.family.main
            label: "Dynamic Colors"
        }
        Item {
            Layout.fillWidth: true
        }
        StyledSwitch {
            id: dynamicColors
            checked: Config.options.appearance.colorFromWallpaper
            onCheckedChanged: {
                Config.options.appearance.colorFromWallpaper = checked;
                if (checked) {
                    Matugen.fromWallpaper();
                } else {
                    Matugen.fromJsonFile();
                }
            }
        }
    }
    ColumnLayout {
        id: colorSelector
        spacing: Variable.margin.small
        visible: !Config.options.appearance.colorFromWallpaper
        FindCommand {
            id: findColor
            filter: ["*.json"]
            path: Directory.trimFileProtocol(Directory.shell) + "/colors"
        }
        FindCommand {
            id: findColorUser
            filter: ["*.json"]
            path: Directory.trimFileProtocol(Directory.shell) + "/colors/user"
        }
        property list<string> colors: findColor.items || []
        property list<string> colorsUser: findColorUser.items || []
        property list<string> colorsAll: [...colors, ...colorsUser]
        TextField {
            id: searchColor
            placeholderText: "Search Color ..."
            placeholderTextColor: ColorUtils.transparentize(Color.colors.on_surface, 0.5)
            Layout.fillWidth: true
            background: Rectangle {
                color: Color.colors.surface_container
                radius: Variable.radius.small
                border.color: searchColor.focus ? Color.colors.primary : Color.colors.surface_variant
                border.width: 1
            }
        }
        Repeater {
            model: ScriptModel {
                values: colorSelector.colorsAll.filter(item => item.split("/").pop().replace(".json", "").toLowerCase().includes(searchColor.text.toLowerCase()))
            }
            delegate: Rectangle {
                width: root.width
                height: colorName.height + Variable.size.small
                color: modelData === Config.options.appearance.colorPath ? Color.colors.surface_container : Color.colors.surface
                radius: Variable.radius.small
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                TapHandler {
                    onTapped: {
                        console.log(modelData);
                        Config.options.appearance.colorPath = modelData;
                        Matugen.fromJsonFile();
                    }
                }
                Text {
                    id: colorName
                    text: modelData.split("/").pop().replace(".json", "")
                    color: Color.colors.on_surface
                    font.pixelSize: Variable.font.pixelSize.small
                    font.weight: Font.Normal
                    font.family: Variable.font.family.main
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Variable.margin.small
                }
            }
        }
    }
    ColumnLayout {
        spacing: Variable.margin.small
        visible: Config.options.appearance.colorFromWallpaper
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
                        Matugen.fromWallpaper();
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
                        Matugen.fromWallpaper();
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
            spacing: Variable.margin.small
            Repeater {
                model: ["scheme-tonal-spot", "scheme-content", "scheme-expressive", "scheme-fruit-salad", "scheme-monochrome", "scheme-neutral", "scheme-rainbow"]
                delegate: ToggleButton {
                    toggled: Config.options.appearance.palette.type === modelData
                    label: modelData
                    font.pixelSize: Variable.font.pixelSize.small
                    font.weight: Font.Normal
                    font.family: Variable.font.family.main
                    toggleOpacity: true
                    TapHandler {
                        onTapped: {
                            Config.options.appearance.palette.type = modelData;
                            Matugen.fromWallpaper();
                        }
                    }
                }
            }
        }
    }
}
// }
