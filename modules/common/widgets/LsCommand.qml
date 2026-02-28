import QtQuick

import Quickshell
import Quickshell.Io

Item {
    id: root
    property string path
    property list<string> items: []
    property string filter: ""
    property int interval: 3000

    Process {
        id: listFiles
        command: ["bash", "-c", `ls -1 ${root.path}${root.path.endsWith("/") ? "" : "/"}${root.filter}`]
        stdout: StdioCollector {
            onStreamFinished: {
                let ls = this.text.split("\n").map(item => item.split("/").pop());
                ls = ls.filter(item => item !== "");
                if (ls !== root.items) {
                    root.items = ls;
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
            listFiles.running = true;
        }
    }
}
