pragma Singleton
pragma ComponentBehavior: Bound
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    id: root
    property bool barOpen: true
    property bool sidebarLeftOpen: false
    property bool sidebarRightOpen: false
    property bool osdBrightnessOpen: false
    property bool osdVolumeOpen: false
    property bool oskOpen: false
    property bool wallpaperSelectorOpen: false
    property bool screenLocked: false
    property bool screenLockContainsCharacters: false
    property bool screenUnlockFailed: false
    property bool sessionOpen: false
    property bool superDown: false
    property bool superReleaseMightTrigger: true
    property bool workspaceShowNumbers: false

    property bool overviewOpen: false
    property bool launcherOpen: false
    property bool dashboardOpen: false
    property bool settingsOpen: false
    property bool mediaControlsOpen: true
    property bool aiChatOpen: false

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
}
