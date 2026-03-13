pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    function reload() {
        let command = ["bash", "-c", "kill -SIGUSR1 $(pgrep kitty)"];
        Quickshell.execDetached(command);
    }
}
