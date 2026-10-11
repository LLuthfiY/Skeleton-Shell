pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    function reload() {
        let command = ["bash", "-c", "kill -SIGUSR2 $(pgrep ghostty)"];
        Quickshell.execDetached(command);
    }
}
