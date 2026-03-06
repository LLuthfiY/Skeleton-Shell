import QtQuick

import Quickshell.Io

Item {
    id: root
    property string path
    property list<string> items: []
    property list<string> filter: []
    property bool caseSensitive: false
    property bool searchFile: true
    property bool searchFolder: true
    property int maxDepth: 1
    property int minDepth: 1
    property int interval: 3000

    Process {
        id: listFiles
        stdout: StdioCollector {
            onStreamFinished: {
                let ls = this.text.split("\n");
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
            const filter = root.filter.length !== 0 ? '\\( ' + root.filter.map(item => `-${root.caseSensitive ? "" : "i"}name "${item}"`).join(" -o ") + ' \\)' : "";
            const type = ["", "-type d", "-type f", ""][root.searchFolder + (2 * root.searchFile)];
            listFiles.command = ["bash", "-c", `find ${root.path}${root.path.endsWith("/") ? "" : "/"} -mindepth ${root.minDepth} -maxdepth ${root.maxDepth} ${type} ${filter}`];
            listFiles.running = true;
        }
    }
}
