pragma Singleton
import Quickshell
import QtQuick

import Quickshell.Wayland

import Quickshell.Io

import qs.modules.common

Singleton {
    property string windowManager: Config.options.windowManager.windowManager
    property var provider: windowManager === "hyprland" ? HyprlandUtils : null
    function setWM() {
        provider.setWM();
    }
    function reloadWM() {
        provider.reloadWM();
    }
}
