pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import qs.modules.common
import qs.modules.bar.widget

import qs.services

import Qt5Compat.GraphicalEffects

Scope {
    id: bar
    Variants {
        model: {
            const screens = Quickshell.screens;
            const list = Config.options.bar.screenList;
            if (!list || list.length === 0)
                return screens;
            return screens.filter(screen => list.includes(screen.name));
        }
        LazyLoader {
            id: barLoader
            active: true
            required property ShellScreen modelData
            component: PanelWindow {
                id: barWindow
                screen: barLoader.modelData
                property string pos: Config.options.bar.position
                property int barW: Config.options.bar.width
                property int mg: Config.options.bar.margin
                property int br: Config.options.bar.borderRadius
                property int spacing: 8
                property bool fw: Config.options.bar.fullWidth
                property int bw: Config.options.bar.border
                property bool borderScreen: Config.options.bar.borderScreen
                property bool ver: pos === "left" || pos === "right"
                property bool is_attached: mg == 0 && !fw

                WlrLayershell.namespace: "quickshell:bar"

                anchors {
                    top: pos === "top" || ((fw || borderScreen) && ver)
                    bottom: pos === "bottom" || ((fw || borderScreen) && ver)
                    left: pos === "left" || ((fw || borderScreen) && !ver)
                    right: pos === "right" || ((fw || borderScreen) && !ver)
                }

                margins {
                    top: pos == "bottom" || borderScreen ? 0 : mg
                    bottom: pos == "top" || borderScreen ? 0 : mg
                    left: pos == "right" || borderScreen ? 0 : mg
                    right: pos == "left" || borderScreen ? 0 : mg
                }

                color: "transparent"

                implicitWidth: (!ver ? Math.max(barW, centerBox.implicitWidth) : centerBox.implicitWidth) + barWindow.bw * 2
                implicitHeight: (ver ? Math.max(barW, centerBox.implicitHeight) : centerBox.implicitHeight) + barWindow.bw * 2

                Rectangle {
                    id: contentBorder
                    anchors.fill: parent
                    color: Color.colors[Config.options.bar.foreground]
                    visible: barWindow.bw > 0

                    topLeftRadius: barWindow.is_attached && (barWindow.pos === "top" || barWindow.pos === "left") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0) ? 0 : barWindow.br + barWindow.bw

                    topRightRadius: barWindow.is_attached && (barWindow.pos === "top" || barWindow.pos === "right") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0) ? 0 : barWindow.br + barWindow.bw

                    bottomLeftRadius: barWindow.is_attached && (barWindow.pos === "bottom" || barWindow.pos === "left") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0) ? 0 : barWindow.br + barWindow.bw

                    bottomRightRadius: barWindow.is_attached && (barWindow.pos === "bottom" || barWindow.pos === "right") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0) ? 0 : barWindow.br + barWindow.bw

                    layer.enabled: true

                    layer.effect: MultiEffect {
                        maskInverted: true
                        maskEnabled: true
                        maskSource: testRect
                        source: contentBorder
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1
                    }
                }

                Item {
                    id: testRect
                    layer.enabled: true
                    visible: false
                    anchors.fill: parent
                    Rectangle {

                        anchors.fill: parent
                        radius: 9999

                        topLeftRadius: barWindow.is_attached && (barWindow.pos === "top" || barWindow.pos === "left") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0) ? 0 : barWindow.br
                        topRightRadius: barWindow.is_attached && (barWindow.pos === "top" || barWindow.pos === "right") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0) ? 0 : barWindow.br
                        bottomLeftRadius: barWindow.is_attached && (barWindow.pos === "bottom" || barWindow.pos === "left") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0) ? 0 : barWindow.br
                        bottomRightRadius: barWindow.is_attached && (barWindow.pos === "bottom" || barWindow.pos === "right") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0) ? 0 : barWindow.br
                        anchors.topMargin: (barWindow.is_attached && barWindow.pos === "top") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0 && (barWindow.pos === "top" || barWindow.ver)) ? 0 : barWindow.bw
                        anchors.leftMargin: (barWindow.is_attached && barWindow.pos === "left") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0 && (barWindow.pos === "left" || !barWindow.ver)) ? 0 : barWindow.bw
                        anchors.rightMargin: (barWindow.is_attached && barWindow.pos === "right") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0 && (barWindow.pos === "right" || !barWindow.ver)) ? 0 : barWindow.bw
                        anchors.bottomMargin: (barWindow.is_attached && barWindow.pos === "bottom") || barWindow.borderScreen || (barWindow.fw && barWindow.mg === 0 && (barWindow.pos === "bottom" || barWindow.ver)) ? 0 : barWindow.bw
                    }
                }

                Loader {
                    id: centerBox
                    anchors.fill: parent
                    anchors.margins: barWindow.bw
                    sourceComponent: barWindow.ver ? verticalComp : horizontalComp
                }

                Component {
                    id: horizontalComp
                    CenterBox {
                        anchors.fill: parent
                        anchors.margins: 8
                        vertical: barWindow.ver
                        startItem: RowLayout {
                            id: startWidgets
                            spacing: barWindow.spacing
                            // vertical: barWindow.vertical
                            // flow: horizontal ? Flow.LeftToRight : Flow.TopToBottom
                            Repeater {
                                model: Config.options.bar.startWidgets
                                //
                                Loader {
                                    Layout.alignment: barWindow.ver ? Qt.AlignHCenter : Qt.AlignVCenter
                                    required property string modelData
                                    property string folder: modelData.startsWith("user--") ? "widget/user/" : "widget/"
                                    source: folder + modelData.replace("user--", "")
                                }
                            }
                        }
                        centerItem: RowLayout {
                            id: centerWidgets
                            spacing: barWindow.spacing
                            // vertical: barWindow.vertical
                            // flow: horizontal ? Flow.LeftToRight : Flow.TopToBottom
                            Repeater {
                                model: Config.options.bar.centerWidgets
                                //
                                Loader {
                                    Layout.alignment: barWindow.ver ? Qt.AlignHCenter : Qt.AlignVCenter
                                    required property string modelData
                                    property string folder: modelData.startsWith("user--") ? "widget/user/" : "widget/"
                                    source: folder + modelData.replace("user--", "")
                                }
                            }
                        }
                        endItem: RowLayout {
                            id: endWidgets
                            spacing: barWindow.spacing
                            // vertical: barWindow.vertical
                            // flow: horizontal ? Flow.LeftToRight : Flow.TopToBottom
                            Repeater {
                                model: Config.options.bar.endWidgets
                                //
                                Loader {
                                    Layout.alignment: barWindow.ver ? Qt.AlignHCenter : Qt.AlignVCenter
                                    required property string modelData
                                    property string folder: modelData.startsWith("user--") ? "widget/user/" : "widget/"
                                    source: folder + modelData.replace("user--", "")
                                }
                            }
                        }
                    }
                }

                Component {
                    id: verticalComp
                    CenterBox {
                        anchors.fill: parent
                        anchors.margins: 8
                        vertical: barWindow.ver
                        startItem: ColumnLayout {
                            id: startWidgets
                            spacing: barWindow.spacing
                            // vertical: barWindow.vertical
                            // flow: horizontal ? Flow.LeftToRight : Flow.TopToBottom
                            Repeater {
                                model: Config.options.bar.startWidgets
                                //
                                Loader {
                                    Layout.alignment: barWindow.ver ? Qt.AlignHCenter : Qt.AlignVCenter
                                    required property string modelData
                                    property string folder: modelData.startsWith("user--") ? "widget/user/" : "widget/"
                                    source: folder + modelData.replace("user--", "")
                                }
                            }
                        }
                        centerItem: ColumnLayout {
                            id: centerWidgets
                            spacing: barWindow.spacing
                            // vertical: barWindow.vertical
                            // flow: horizontal ? Flow.LeftToRight : Flow.TopToBottom
                            Repeater {
                                model: Config.options.bar.centerWidgets
                                //
                                Loader {
                                    Layout.alignment: barWindow.ver ? Qt.AlignHCenter : Qt.AlignVCenter
                                    required property string modelData
                                    property string folder: modelData.startsWith("user--") ? "widget/user/" : "widget/"
                                    source: folder + modelData.replace("user--", "")
                                }
                            }
                        }
                        endItem: ColumnLayout {
                            id: endWidgets
                            spacing: barWindow.spacing
                            // vertical: barWindow.vertical
                            // flow: horizontal ? Flow.LeftToRight : Flow.TopToBottom
                            Repeater {
                                model: Config.options.bar.endWidgets
                                //
                                Loader {
                                    Layout.alignment: barWindow.ver ? Qt.AlignHCenter : Qt.AlignVCenter
                                    required property string modelData
                                    property string folder: modelData.startsWith("user--") ? "widget/user/" : "widget/"
                                    source: folder + modelData.replace("user--", "")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
