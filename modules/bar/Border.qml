pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import Quickshell.Wayland
import Qt5Compat.GraphicalEffects

import qs.modules.common

Scope {
    id: border
    Variants {
        model: {
            const screens = Quickshell.screens;
            const list = Config.options.bar.screenList;
            if (!list || list.length === 0)
                return screens;
            return screens.filter(screen => list.includes(screen.name));
        }

        LazyLoader {
            id: borderLoader
            active: Config.options.bar.borderScreen
            required property ShellScreen modelData
            component: PanelWindow {
                id: borderWindow
                screen: borderLoader.modelData
                property string position: Config.options.bar.position
                property int margin: Config.options.bar.margin
                property int borderWidth: Config.options.bar.border
                property int borderRadius: Config.options.bar.borderRadius
                property bool borderScreen: Config.options.bar.borderScreen

                property int defaultMargin: 16

                property int topMargin: position === "top" ? 0 : margin
                property int rightMargin: position === "right" ? 0 : margin
                property int bottomMargin: position === "bottom" ? 0 : margin
                property int leftMargin: position === "left" ? 0 : margin

                // function setGaps() {
                //     let gaps_out = `${topMargin + defaultMargin},${rightMargin + defaultMargin},${bottomMargin + defaultMargin},${leftMargin + defaultMargin}`;
                //     if (!borderScreen) {
                //         gaps_out = `${defaultMargin},${defaultMargin},${defaultMargin},${defaultMargin}`;
                //     }
                //     console.log(borderScreen, margin, position)
                //     Quickshell.execDetached(["hyprctl", "keyword", "general:gaps_out", gaps_out]);
                // }
                //
                // Timer {
                //     id: gapsTimer
                //     interval: 500
                //     repeat: false
                //     onTriggered: setGaps()
                // }
                //
                // onPositionChanged: gapsTimer.running = true
                //
                // onMarginChanged: gapsTimer.running = true
                //
                // onBorderScreenChanged: gapsTimer.running = true
                //
                // Component.onCompleted: gapsTimer.running = true

                WlrLayershell.layer: WlrLayer.Top
                mask: Region {}
                color: "#00000000"

                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }
                Item {
                    anchors.fill: parent

                    Rectangle {
                        id: backgroundContent
                        anchors.fill: parent
                        color: Color.colors[Config.options.bar.background]

                        layer.enabled: true

                        layer.effect: MultiEffect {
                            maskInverted: true
                            maskEnabled: true
                            maskSource: holeMaskSource
                            source: backgroundContent
                            maskThresholdMin: 0.5
                            maskSpreadAtMin: 1
                        }
                        Rectangle {
                            anchors.fill: parent
                            color: Color.colors[Config.options.bar.foreground]
                            radius: borderWindow.borderRadius + borderWidth
                            anchors.topMargin: borderWindow.topMargin
                            anchors.bottomMargin: borderWindow.bottomMargin
                            anchors.leftMargin: borderWindow.leftMargin
                            anchors.rightMargin: borderWindow.rightMargin
                            //
                            // layer.enabled: true
                            //
                            // layer.effect: MultiEffect {
                            //     maskInverted: true
                            //     maskEnabled: true
                            //     maskSource: holeMaskSource
                            //     source: backgroundContent
                            //     maskThresholdMin: 0.5
                            //     maskSpreadAtMin: 1
                            //   }
                        }
                    }

                    Item {
                        id: holeMaskSource
                        anchors.fill: parent

                        layer.enabled: true
                        visible: false
                        // Black rectangle — this defines the "hole" area
                        Rectangle {
                            anchors.fill: parent
                            anchors.topMargin: borderWindow.topMargin + borderWidth
                            anchors.bottomMargin: borderWindow.bottomMargin + borderWidth
                            anchors.leftMargin: borderWindow.leftMargin + borderWidth
                            anchors.rightMargin: borderWindow.rightMargin + borderWidth
                            radius: borderWindow.borderRadius
                        }
                    }
                }
            }
        }
    }
}
