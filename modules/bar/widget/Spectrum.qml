import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

import qs.services
import qs.modules.common

Item {
    id: spectrumRoot
    property int barsCount: 16
    property bool vertical: Config.options.bar.position === "left" || Config.options.bar.position === "right"
    property list<var> values: Cava.values
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    implicitWidth: spectrumLoader.implicitWidth
    implicitHeight: spectrumLoader.implicitHeight
    visible: Mpris.players.values.some(p => p.isPlaying)
    Loader {
        id: spectrumLoader
        anchors.centerIn: parent
        sourceComponent: vertical ? verticalSpectrum : horizontalSpectrum
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Config.options.mediaPlayer.enable = !Config.options.mediaPlayer.enable;
        }
    }

    Component {
        id: horizontalSpectrum
        RowLayout {
            anchors.centerIn: parent
            spacing: Variable.margin.smallest
            Repeater {
                model: values
                Rectangle {
                    width: Variable.size.smallest / 2
                    height: modelData * 2
                    Layout.alignment: Qt.AlignVCenter
                    radius: Variable.radius.smallest
                    color: Color.colors[Config.options.bar.foreground]
                }
            }
        }
    }

    Component {
        id: verticalSpectrum
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Variable.margin.smallest
            Repeater {
                model: values
                Rectangle {
                    width: modelData * 2
                    height: Variable.size.smallest / 2
                    Layout.alignment: Qt.AlignHCenter
                    radius: Variable.radius.smallest
                    color: Color.colors[Config.options.bar.foreground]
                }
            }
        }
    }
}
