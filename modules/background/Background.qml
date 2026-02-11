import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import QtMultimedia

import qs.modules.common

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: backgroundRoot
    Variants {
        model: Quickshell.screens

        // const screens = Quickshell.screens;
        // const list = Config.options.bar.screenList;
        // if (!list || list.length === 0)
        //     return screens;
        // return screens.filter(screen => list.includes(screen.name));

        LazyLoader {
            id: barLoader
            active: true
            required property ShellScreen modelData
            component: PanelWindow {
                id: wallpaper
                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }
                color: Color.colors.background
                Component {
                    id: image
                    Image {
                        anchors.fill: parent
                        source: Config.options.background.wallpaperPath
                        fillMode: Image.PreserveAspectCrop
                    }
                }
                Component {
                    id: liveWallpaper
                    Video {
                        property bool isPlaying: !Hyprland.focusedWorkspace.hasFullscreen
                        anchors.fill: parent
                        source: Config.options.background.liveWallpaperPath
                        fillMode: VideoOutput.PreserveAspectCrop
                        autoPlay: true
                        muted: Config.options.background.mute
                        loops: MediaPlayer.Infinite
                        onIsPlayingChanged: {
                            if (isPlaying) {
                                play();
                            } else {
                                pause();
                            }
                        }
                    }
                }
                Loader {
                    id: wallpaperLoader
                    anchors.fill: parent
                    active: true
                    sourceComponent: Config.options.background.liveWallpaper ? liveWallpaper : image
                }
                WlrLayershell.layer: WlrLayer.Background
                exclusionMode: ExclusionMode.Ignore
            }
        }
    }
}
