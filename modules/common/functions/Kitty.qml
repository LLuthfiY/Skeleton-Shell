pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    function reload() {
        let command = ["bash", "-c", "kill -SIGUSR1 $(pgrep kitty)"];
        // Quickshell.execDetached(command);
        kittyProcess.command = command;
        timer.running = true;
    }

    Timer {
        id: timer
        interval: 100
        onTriggered: {
            kittyProcess.running = true;
        }
    }
    Process {
        id: kittyProcess
        stdout: StdioCollector {
            onStreamFinished: {
                console.log(this.text);
            }
        }
    }
}
