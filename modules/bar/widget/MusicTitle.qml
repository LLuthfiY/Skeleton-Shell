import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Services.Mpris

import qs.modules.common

Loader {
    id: musicTitle
    // Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    visible: Mpris.players.values.length > 0
    property bool vertical: Config.options.bar.position === "left" || Config.options.bar.position === "right"
    sourceComponent: vertical ? verticalComp : horizontalComp
    TapHandler {
        onTapped: {
            Config.options.mediaPlayer.enable = !Config.options.mediaPlayer.enable;
        }
    }

    Component {
        id: horizontalComp
        ColumnLayout {
            spacing: Variable.margin.smallest
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Repeater {
                model: Mpris.players
                Text {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    required property MprisPlayer modelData
                    text: modelData.trackTitle.length > 35 ? modelData.trackTitle.substring(0, 32) + "..." : modelData.trackTitle
                    font.pixelSize: Variable.font.pixelSize.small
                    font.weight: Font.Medium
                    color: Color.colors[Config.options.bar.foreground]
                    visible: modelData.isPlaying
                }
            }
        }
    }

    Component {
        id: verticalComp
        RowLayout {
            spacing: Variable.margin.smallest
            implicitHeight: musicTitleRepeater.item ? musicTitleRepeater.item.height : 0
            implicitWidth: musicTitleRepeater.item ? musicTitleRepeater.item.width : 0
            Repeater {
                id: musicTitleRepeater
                model: Mpris.players
                Item {
                    id: textContainer
                    // Use a dynamic size to correctly enclose the rotated text
                    width: textItem.paintedHeight
                    height: textItem.paintedWidth
                    visible: modelData.isPlaying

                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        id: textItem
                        text: modelData.trackTitle.length > 35 ? modelData.trackTitle.trim().substring(0, 32) + "..." : modelData.trackTitle.trim()
                        font.pixelSize: Variable.font.pixelSize.small

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.centerIn: parent
                        font.weight: Font.Medium
                        color: Color.colors[Config.options.bar.foreground]
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                        // The rotation property rotates around the center by default
                        // so we don't need a separate Rotation transform unless
                        // we want to customize the origin.
                        rotation: Config.options.bar.position === "left" ? -90 : 90

                        onTextChanged: {
                            parent.implicitHeight = textItem.paintedWidth;
                            parent.implicitWidth = textItem.paintedHeight;
                        }
                    }
                }
            }
        }
    }
}
