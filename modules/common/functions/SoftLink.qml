pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root
    function create(source, target) {
        let command = ["ln", "-sfn", source, target];
        Quickshell.execDetached(command);
    }
}
