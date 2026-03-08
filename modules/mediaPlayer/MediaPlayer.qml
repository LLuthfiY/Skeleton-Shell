import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Wayland

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

import qs.services

import Qt5Compat.GraphicalEffects

Scope {
    id: mediaPlayerRoot
    property var players: Mpris.players.values
    PanelWindow {
        id: root

        color: "transparent"
        implicitWidth: Variable.uiScale(476)
        implicitHeight: Variable.uiScale(112)
        WlrLayershell.namespace: "quickshell:mediaPlayer"
        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: 0
        visible: Config.ready && Config.options.mediaPlayer.enable && Mpris.players.values.length > 0

        anchors {
            top: false
            bottom: true
            left: true
            right: false
        }

        margins {
            top: (Config.options.bar.position === "top" ? 0 : Config.options.bar.margin) + Variable.margin.normal
            bottom: (Config.options.bar.position === "bottom" ? 0 : Config.options.bar.margin) + Variable.margin.normal
            left: (Config.options.bar.position === "left" ? 0 : Config.options.bar.margin) + Variable.margin.normal
            right: (Config.options.bar.position === "right" ? 0 : Config.options.bar.margin) + Variable.margin.normal
        }
        Rectangle {
            anchors.fill: parent
            color: Color.colors.surface
            radius: Config.options.bar.borderRadius
            // Loader {
            //     active: Config.options.mediaPlayer.enable
            //     anchors.fill: parent
            //     LineChart {
            //         color: Color.colors.primary
            //         anchors.fill: parent
            //         points: Cava.values
            //         drawBottomLine: true
            //         fill: true
            //         maxValue: 10
            //         fillColor: "#55" + Color.colors.primary.replace("#", "")
            //     }
            // }
        }
        SwipeView {
            id: controls
            anchors.centerIn: parent
            // currentIndex: Mpris.players.values.reduce((a, b, i) => b.isPlaying ? i : a, 0)
            currentIndex: Mpris.players.values.reduce((a, b, i) => b.isPlaying ? i : a, 0)
            // currentIndex: 0
            Repeater {
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: ScriptModel {
                    values: Mpris.players.values
                }
                delegate: RowLayout {
                    opacity: controls.currentIndex == index ? 1 : 0.2
                    property bool needUpdate: false
                    property bool afterOpen: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.rightMargin: Variable.margin.normal
                    property real pos: 0
                    spacing: Variable.margin.large
                    Rectangle {
                        id: art
                        width: Variable.uiScale(92)
                        height: Variable.uiScale(92)

                        radius: Variable.radius.normal
                        Image {
                            anchors.fill: parent
                            source: modelData.trackArtUrl
                            fillMode: Image.PreserveAspectCrop
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: Rectangle {
                                    width: art.width
                                    height: art.height
                                    radius: Variable.radius.normal
                                }
                            }
                            Rectangle {
                                anchors.fill: parent
                                color: artHoverHandler.hovered ? ColorUtils.transparentize(Color.colors.surface, 0.5) : "transparent"
                                radius: Variable.radius.normal
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                                TapHandler {
                                    onTapped: {
                                        Config.options.mediaPlayer.enable = false;
                                    }
                                }
                                HoverHandler {
                                    id: artHoverHandler
                                }

                                LucideIcon {
                                    id: artIcon
                                    anchors.centerIn: parent
                                    icon: "x"
                                    font.pixelSize: Variable.uiScale(48)
                                    color: Color.colors.on_surface
                                    visible: artHoverHandler.hovered
                                }
                            }
                        }
                    }
                    ColumnLayout {
                        Layout.minimumWidth: Variable.uiScale(340)
                        Layout.maximumWidth: Variable.uiScale(340)
                        spacing: Variable.margin.small
                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: modelData.trackTitle
                            elide: Text.ElideRight
                            font.pixelSize: Variable.font.pixelSize.normal
                            Layout.maximumWidth: Variable.uiScale(340)

                            font.family: Variable.font.family.main
                            font.weight: Font.Medium
                            color: Color.colors.on_surface
                            onTextChanged: {
                                if (!afterOpen) {
                                    needUpdate = true;
                                }
                                afterOpen = false;
                            }
                        }
                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: modelData.trackArtist
                            elide: Text.ElideRight
                            font.pixelSize: Variable.font.pixelSize.small
                            font.family: Variable.font.family.main
                            Layout.maximumWidth: Variable.uiScale(340)

                            font.weight: Font.Medium
                            color: Color.colors.on_surface
                        }
                        RowLayout {
                            spacing: Variable.margin.small
                            Rectangle {
                                id: playButton
                                implicitWidth: Variable.size.larger
                                implicitHeight: Variable.size.larger
                                visible: modelData.canPlay
                                radius: Variable.radius.small
                                color: playHoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                                LucideIcon {
                                    id: playIcon
                                    anchors.centerIn: parent
                                    icon: modelData.isPlaying ? "pause" : "play"
                                    color: playHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                                }
                                TapHandler {
                                    onTapped: {
                                        if (modelData.isPlaying) {
                                            console.log(modelData.isPlaying);
                                            const activePlayers = Mpris.players.values.reduce((a, b, i) => {
                                                if (i === index) {
                                                    return a;
                                                } else {
                                                    return a + b.isPlaying ? 1 : 0;
                                                }
                                            }, 0);
                                            const lastActivePlayer = Mpris.players.values.reduce((a, b, i) => {
                                                if (i === index) {
                                                    return a;
                                                } else {
                                                    return b.isPlaying ? i : a;
                                                }
                                            }, 0);
                                            if (activePlayers !== 0) {
                                                controls.currentIndex = lastActivePlayer;
                                            }
                                        }
                                        controls.currentIndex = controls.currentIndex;
                                        modelData.togglePlaying();
                                    }
                                }
                                HoverHandler {
                                    id: playHoverHandler
                                }
                            }
                            Rectangle {
                                id: previousButton
                                implicitWidth: Variable.size.large
                                implicitHeight: Variable.size.large
                                visible: modelData.canGoPrevious
                                radius: Variable.radius.small
                                color: "transparent"
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                                TapHandler {
                                    onTapped: {
                                        modelData.previous();
                                        modelData.position = 0;
                                    }
                                }
                                HoverHandler {
                                    id: previousHoverHandler
                                }
                                LucideIcon {
                                    id: previousIcon
                                    anchors.centerIn: parent
                                    icon: "skip-back"
                                    color: previousHoverHandler.hovered ? Color.colors.on_surface_variant : Color.colors.on_surface
                                }
                            }
                            Rectangle {
                                id: nextButton
                                implicitWidth: Variable.size.large
                                implicitHeight: Variable.size.large

                                visible: modelData.canGoNext
                                radius: Variable.radius.small
                                color: "transparent"
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                                LucideIcon {
                                    id: nextIcon
                                    anchors.centerIn: parent
                                    icon: "skip-forward"
                                    color: nextHoverHandler.hovered ? Color.colors.on_surface_variant : Color.colors.on_surface
                                }
                                HoverHandler {
                                    id: nextHoverHandler
                                }
                                TapHandler {
                                    onTapped: {
                                        modelData.next();
                                        modelData.position = 0;
                                    }
                                }
                            }
                        }
                        // Slider {
                        //     id: slider
                        //     visible: modelData.canSeek
                        //     Layout.alignment: Qt.AlignVCenter
                        //     from: 0
                        //     Layout.fillWidth: true
                        //     stepSize: 1
                        //     onMoved: {
                        //         modelData.position = value;
                        //     }
                        //     // onVisibleChanged: {
                        //     //     if (!mediaPlayerRoot.afterOpen) {
                        //     //         modelData.position = 0;
                        //     //     }
                        //     //
                        //     //     mediaPlayerRoot.afterOpen = false;
                        //     // }
                        //
                        //     background: Rectangle {
                        //         color: "transparent"
                        //         height: 4
                        //         radius: Variable.radius.normal
                        //         anchors.verticalCenter: parent.verticalCenter
                        //
                        //         Rectangle {
                        //             id: activeProgress
                        //             color: Color.colors.primary
                        //             width: modelData.position / modelData.length * parent.width - 10
                        //             height: 8
                        //             radius: 4
                        //             anchors.verticalCenter: parent.verticalCenter
                        //         }
                        //
                        //         Rectangle {
                        //             id: inactiveProgress
                        //             color: Color.colors.primary_container
                        //             width: parent.width - activeProgress.width - 20
                        //             height: 4
                        //             radius: Variable.radius.normal
                        //             anchors.verticalCenter: parent.verticalCenter
                        //             anchors.right: parent.right
                        //         }
                        //     }
                        //     handle: Rectangle {
                        //         color: Color.colors.primary
                        //         radius: 4
                        //         width: 4
                        //         height: 16
                        //         anchors.verticalCenter: parent.verticalCenter
                        //         x: modelData.position / modelData.length * parent.width - width / 2
                        //     }
                        //     // Component.onCompleted: {
                        //     //     modelData.position = 0;
                        //     // }
                        // }
                        // Timer {
                        //     interval: 1000
                        //     running: modelData.isPlaying
                        //     repeat: true
                        //     triggeredOnStart: true
                        //     onTriggered: {
                        //         modelData.positionChanged();
                        //         slider.value = modelData.position;
                        //         if (slider.to != modelData.length) {
                        //             slider.to = modelData.length;
                        //         }
                        //         if (needUpdate) {
                        //             needUpdate = false;
                        //             // modelData.position = 0;
                        //         }
                        //     }
                        // }
                        // Timer {
                        //     interval: 100
                        //     running: modelData.isPlaying && needUpdate
                        //     triggeredOnStart: true
                        //     repeat: true
                        //     onTriggered: {
                        //         modelData.positionChanged();
                        //         slider.value = modelData.position;
                        //         if (slider.to != modelData.length) {
                        //             slider.to = modelData.length;
                        //         }
                        //
                        //         needUpdate = false;
                        //         modelData.position = 0;
                        //     }
                        // }
                    }
                }
            }
        }
    }
}
