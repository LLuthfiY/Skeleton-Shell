import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Io

import qs.modules.common
import qs.modules.common.widgets

RowLayout {
    id: root
    spacing: Variable.margin.small
    property string uptime: "uptime"
    RowLayout {
        spacing: Variable.margin.small

        Rectangle {
            id: powerButton
            implicitWidth: Variable.size.larger
            implicitHeight: Variable.size.larger
            border.width: 2 * Config.options.appearance.uiScale
            border.color: powerHoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
            radius: Variable.radius.small
            color: powerHoverHandler.hovered ? Color.colors.primary : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            HoverHandler {
                id: powerHoverHandler
            }
            TapHandler {
                onTapped: {
                    powerMenu.open();
                }
            }
            Behavior on border.color {
                ColorAnimation {
                    duration: 200
                }
            }
            LucideIcon {
                id: powerIcon
                anchors.centerIn: parent
                icon: "power"
                color: powerHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
            }
            Menu {
                id: powerMenu
                padding: Variable.margin.small
                implicitWidth: 200 * Config.options.appearance.uiScale
                background: Rectangle {
                    id: backgroundMenu
                    radius: Variable.radius.normal
                    color: Color.colors.surface_container
                }

                Instantiator {
                    model: [
                        {
                            "icon": "power",
                            "text": "Power Off",
                            "action": function () {
                                Quickshell.execDetached(["systemctl", "poweroff"]);
                            }
                        },
                        {
                            "icon": "rotate-ccw",
                            "text": "Restart",
                            "action": function () {
                                Quickshell.execDetached(["systemctl", "reboot"]);
                            }
                        },
                        {
                            "icon": "moon",
                            "text": "Suspend",
                            "action": function () {
                                Quickshell.execDetached(["systemctl", "suspend"]);
                            }
                        },
                        {
                            "icon": "log-out",
                            "text": "Logout",
                            "action": function () {
                                Quickshell.execDetached(["hyprctl", "dispatch", "exit"]);
                            }
                        },
                        {
                            "icon": "lock",
                            "text": "Lock",
                            "action": function () {
                                Quickshell.execDetached(["hyprlock"]);
                            }
                        }
                    ].reverse()

                    onObjectAdded: function (index, item) {
                        powerMenu.addItem(item);
                    }

                    onObjectRemoved: function (index, item) {
                        powerMenu.removeItem(item);
                    }

                    delegate: MenuItem {
                        background: Rectangle {
                            radius: Variable.radius.small
                            color: menuHoverHandler.hovered ? Color.colors.primary : "transparent"
                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            TapHandler {
                                onTapped: modelData.action()
                            }

                            HoverHandler {
                                id: menuHoverHandler
                            }
                        }
                        contentItem: RowLayout {
                            LucideIcon {
                                Layout.fillWidth: true
                                icon: modelData.icon
                                label: modelData.text
                                color: menuHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                            }
                        }
                        onTriggered: modelData.action()
                    }
                }
            }
        }
        Rectangle {
            id: settingsButton
            implicitWidth: Variable.size.larger
            implicitHeight: Variable.size.larger

            radius: Variable.radius.small
            color: settingsHoverHandler.hovered ? Color.colors.primary : "transparent"
            border.color: settingsHoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
            border.width: 2 * Config.options.appearance.uiScale
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            Behavior on border.color {
                ColorAnimation {
                    duration: 200
                }
            }
            LucideIcon {
                id: settingsIcon
                anchors.centerIn: parent
                icon: "settings"
                color: settingsHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
            }
            TapHandler {
                onTapped: {
                    GlobalState.settingsOpen = true;
                    GlobalState.dashboardOpen = false;
                }
            }
            HoverHandler {
                id: settingsHoverHandler
            }
        }
        Item {
            Layout.fillWidth: true
        }
        Text {
            id: timeText
            // text: Qt.formatTime(systemClock.date, "hh:mm  ")
            text: root.uptime
            color: Color.colors.on_surface ?? "#FFFFFF"
            Layout.alignment: Qt.AlignRight
            horizontalAlignment: Text.AlignRight
            font.weight: Font.Bold
            font.pixelSize: Variable.font.pixelSize.small
        }

        SystemClock {
            id: systemClock
            precision: SystemClock.Minutes
        }

        Timer {
            id: uptimeTimer
            running: true
            interval: 30000
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                uptimeProcess.running = true;
            }
        }
        Process {
            id: uptimeProcess
            command: ["uptime", "-p"]
            stdout: StdioCollector {
                onStreamFinished: {
                    root.uptime = this.text.replace("up", "").replace(",", "").replace(" day", "d").replace(" hour", "h").replace(" minute", "m").trim() + "  ";
                }
            }
        }
    }
}
