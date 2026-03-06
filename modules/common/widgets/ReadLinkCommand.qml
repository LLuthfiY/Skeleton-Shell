import QtQuick

import Quickshell.Io

Item {
    id: root
    property string path
    property string link: ""
    property int interval: 3000

    Process {
        id: readLink
        command: ["bash", "-c", `readlink -f ${root.path}`]
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text !== root.link) {
                    root.link = this.text;
                }
            }
        }
    }

    Timer {
        id: timer
        interval: root.interval
        triggeredOnStart: true
        repeat: true
        running: true
        onTriggered: {
            readLink.running = true;
        }
    }
}
