import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import Quickshell.Widgets

import qs.modules.common
import qs.modules.common.widgets

Scope {
    id: root

    // Bind the pipewire node so its volume will be tracked
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }

        function onMutedChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    property bool shouldShowOsd: false
    property int percentage: Math.round(Pipewire.defaultAudioSink?.audio.volume * 100)
    property bool muted: Pipewire.defaultAudioSink?.audio.muted

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }

    // The OSD window will be created and destroyed based on shouldShowOsd.
    // PanelWindow.visible could be set instead of using a loader, but using
    // a loader will reduce the memory overhead when the window isn't open.
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            // Since the panel's screen is unset, it will be picked by the compositor
            // when the window is created. Most compositors pick the current active monitor.

            anchors.bottom: true
            margins.bottom: 24
            exclusiveZone: 0

            implicitWidth: 150
            implicitHeight: 150

            color: "transparent"
            Rectangle {
                anchors.fill: parent
                radius: 24
                color: Color.colors.surface
            }
            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            CircularProgress {
                anchors.centerIn: parent
                anchors.margins: 24
                lineWidth: 8
                implicitSize: 100
                value: Pipewire.defaultAudioSink?.audio.volume ?? 0
                inside: Text {
                    text: root.muted ? "" : root.percentage > 50 ? "" : root.percentage > 0 ? "" : ""
                    font.pixelSize: 48
                    color: Color.colors.primary
                }
            }
        }
    }
}
