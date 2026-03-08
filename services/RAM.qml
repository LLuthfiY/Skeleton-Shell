pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick

import Quickshell
import Quickshell.Io

import qs.modules.common

Singleton {
    id: root
    property int interval: Config.options.services.systemMonitor.interval
    property string ramUsage: "0"
    property string ramTotal: "0"
    property string ramUsed: "0"
    property string ramFree: "0"

    property var _lastStat: null

    signal ramUpdated

    Timer {
        id: ramTimer
        running: true
        interval: root.interval
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            ramDetailsProcess.running = true;
        }
    }

    Process {
        id: ramDetailsProcess
        command: ["cat", "/proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.split("\n");
                let ramTotal = lines.find(line => line.startsWith("MemTotal"));
                ramTotal = ramTotal.split(":")[1].trim().replace(" kB", "");
                let ramFree = lines.find(line => line.startsWith("MemAvailable"));
                ramFree = ramFree.split(":")[1].trim().replace(" kB", "");
                let ramUsed = ramTotal - ramFree;
                root.ramTotal = ramTotal;
                root.ramFree = ramFree;
                root.ramUsed = ramUsed;
                root.ramUsage = (100 * (ramUsed / ramTotal)).toFixed(1);
                root.ramUpdated();
            }
        }
    }
}
