pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string wallapaperPath: Directory.configFolder + "/wallpaper.png"

    property bool overviewOpen: false
    property bool launcherOpen: false
    property bool dashboardOpen: false
    property bool settingsOpen: false
    property bool mediaControlsOpen: true
    property bool aiChatOpen: false
    property bool screenLocked: false
    property bool barMenuOpen: false

    function themeReload() {
        themeReloader.running = true;
    }

    IpcHandler {
        target: "screenLock"

        function actived() {
            screenLocked = true;
        }
    }

    IpcHandler {
        target: "launcher"

        function toggle() {
            launcherOpen = !launcherOpen;
        }
    }

    IpcHandler {
        target: "dashboard"

        function toggle() {
            dashboardOpen = !dashboardOpen;
            aiChatOpen = false;
        }
    }

    IpcHandler {
        target: "settings"

        function toggle() {
            settingsOpen = !settingsOpen;
        }
    }

    IpcHandler {
        target: "overview"

        function toggle() {
            overviewOpen = !overviewOpen;
        }
    }

    IpcHandler {
        target: "setupWindowManager"

        function setup() {
            WindowManagerUtils.setWM();
        }
    }

    IpcHandler {
        target: "aiChat"

        function toggle() {
            aiChatOpen = !aiChatOpen;
            dashboardOpen = false;
        }
    }

    IpcHandler {
        target: "wallpaper"
        function update() {
            // const temp = wallapaperPath;
            // wallapaperPath = "";
            // wallapaperPath = temp;
            // Kitty.reload();
            themeReloader.running = true;
        }
    }

    Timer {
        id: themeReloader
        interval: 200
        onTriggered: {
            const temp = wallapaperPath;
            wallapaperPath = "";
            wallapaperPath = temp;
            Kitty.reload();
        }
    }
}
