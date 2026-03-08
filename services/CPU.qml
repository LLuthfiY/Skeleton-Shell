pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick

import Quickshell
import Quickshell.Io

import qs.modules.common

Singleton {
    id: root
    property int interval: Config.options.services.systemMonitor.interval
    property string cpuUsage: "0"
    property string cpuTemp: "0"
    property string cpuFreq: "0"
    property string cpuCores: "0"
    property string cpuModel: "0"
    property string cpuVendor: "0"

    property var _lastStat: null

    signal cpuUpdated

    Timer {
        id: cpuTimer
        running: true
        interval: root.interval
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuUsageProcess.running = true;
            cpuTempProcess.running = true;
            cpuDetailsProcess.running = true;
        }
    }
    Process {
        id: cpuUsageProcess
        command: ["cat", "/proc/stat"]
        stdout: StdioCollector {
            onStreamFinished: {
                let stat = this.text;
                let parts = stat.split("\n")[0].split(/\s+/).slice(1).map(Number);
                let idle = parts[3] + parts[4];
                let total = parts.reduce((a, b) => a + b, 0);

                if (_lastStat) {
                    let usage = 100 * (1 - (idle - _lastStat.idle) / (total - _lastStat.total));
                    cpuUsage = usage.toFixed(1);
                    root.cpuUpdated();
                }

                _lastStat = {
                    idle,
                    total
                };
            }
        }
    }
    Process {
        id: cpuTempProcess
        command: ["cat", "/sys/class/thermal/thermal_zone0/temp"]
        stdout: StdioCollector {
            onStreamFinished: {
                cpuTemp = `${this.text / 1000}`;
            }
        }
    }
    Process {
        id: cpuDetailsProcess
        command: ["cat", "/proc/cpuinfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.split("\n");
                let cpuModel = lines.find(line => line.startsWith("model name"));
                cpuModel = cpuModel.split(":")[1].trim();
                let cpuVendor = lines.find(line => line.startsWith("vendor_id"));
                cpuVendor = cpuVendor.split(":")[1].trim();
                let cpuCores = lines.find(line => line.startsWith("cpu cores"));
                cpuCores = cpuCores.split(":")[1].trim();
                let cpuFreq = lines.find(line => line.startsWith("cpu MHz"));
                cpuFreq = cpuFreq.split(":")[1].trim();
                root.cpuModel = cpuModel;
                root.cpuVendor = cpuVendor;
                root.cpuCores = cpuCores;
                root.cpuFreq = cpuFreq;
            }
        }
    }
}
