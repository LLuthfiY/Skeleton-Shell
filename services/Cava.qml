pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import qs.modules.common

Singleton {
    id: root

    property var values: Array(barsCount).fill(0)
    property int barsCount: 16

    Process {
        id: process
        stdinEnabled: false
        running: Mpris.players.values.some(p => p.isPlaying)
        command: ["cava", "-p", Quickshell.shellPath("scripts/cava/config.txt")]
        onExited: {
            stdinEnabled = true;
            values = Array(barsCount).fill(0);
        }
        onStarted: {
            values = Array(barsCount).fill(0);
        }
        stdout: SplitParser {
            onRead: data => {
                root.values = data.slice(0, -1).split(";").map(v => parseInt(v, 10) / 100);
            }
        }
    }
}
