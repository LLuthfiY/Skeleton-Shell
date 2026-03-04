import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Effects
import QtQuick.Layouts

import Qt5Compat.GraphicalEffects

import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import Quickshell.Services.Mpris

import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.modules.bar.widget

Scope {
    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
    LockContext {
        id: lockContext
        onUnlocked: {
            GlobalState.screenLocked = false;
        }
    }
    WlSessionLock {
        id: lock
        locked: GlobalState.screenLocked && Config.options.modules.lockscreen

        WlSessionLockSurface {
            Rectangle {
                color: Color.colors.surface
                anchors.fill: parent
                Image {
                    asynchronous: true
                    source: Directory.trimFileProtocol(Directory.configFolder + "/wallpaper")
                }
                Rectangle {
                    id: background
                    anchors.fill: parent
                    color: ColorUtils.transparentize(Color.colors.background, Config.options.appearance.darkMode ? 0.90 : 0.85)

                    layer.enabled: true

                    layer.effect: MultiEffect {
                        maskInverted: true
                        maskEnabled: true
                        maskSource: holeMaskSource
                        source: background
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1
                    }
                }
                Item {
                    id: holeMaskSource
                    anchors.fill: parent

                    layer.enabled: true
                    visible: false
                    // Black rectangle — this defines the "hole" area
                    ColumnLayout {
                        anchors.centerIn: parent
                        Text {
                            color: Color.colors.on_surface
                            text: Qt.formatTime(systemClock.date, "hh:mm")
                            font.weight: Font.Bold
                            font.pixelSize: Variable.uiScale(120)
                            font.family: Variable.font.family.main
                            Layout.alignment: Qt.AlignHCenter
                        }
                        TextField {
                            id: password
                            Layout.alignment: Qt.AlignHCenter
                            implicitWidth: Variable.uiScale(500)
                            font.pixelSize: Variable.font.pixelSize.large
                            padding: 16
                            focus: true
                            enabled: !lockContext.unlockInProgress
                            echoMode: TextInput.Password
                            placeholderText: "Password"
                            horizontalAlignment: Text.AlignHCenter
                            onAccepted: {
                                lockContext.tryUnlock();
                            }
                            onTextChanged: {
                                lockContext.currentText = text;
                            }
                            Connections {
                                target: lockContext
                                function onCurrentTextChanged() {
                                    password.text = lockContext.currentText;
                                }
                            }
                            background: Rectangle {
                                color: "transparent"
                            }
                        }
                        Spectrum {
                            id: spectrum
                            Layout.alignment: Qt.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width
                            implicitHeight: 100
                            vertical: false
                            scale: 8
                        }
                    }
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Variable.margin.normal
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: mediaPlayer.height
                    width: mediaPlayer.width
                    color: "transparent"
                    clip: true
                    radius: Variable.radius.normal
                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                    Behavior on height {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                    SwipeView {
                        id: mediaPlayer
                        anchors.centerIn: parent
                        padding: Variable.margin.normal
                        property int activePlayer: Mpris.players.values.reduce((a, b, i) => b.isPlaying ? i : a, 0)
                        property int lastPlayer: activePlayer
                        currentIndex: lastPlayer
                        onActivePlayerChanged: {
                            if (activePlayer === 0) {
                                if (Mpris.players.values[0].isPlaying) {
                                    lastPlayer = 0;
                                }
                            } else {
                                lastPlayer = activePlayer;
                            }
                        }
                        Repeater {
                            model: ScriptModel {
                                values: Mpris.players.values
                            }
                            delegate: ColumnLayout {
                                opacity: mediaPlayer.currentIndex == index ? 1 : 0
                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    width: art.width
                                    height: art.height
                                    radius: Variable.radius.normal
                                    clip: true
                                    color: "transparent"
                                    Image {
                                        id: art
                                        width: Variable.uiScale(128)
                                        height: Variable.uiScale(128)
                                        source: modelData.trackArtUrl
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }
                                Text {
                                    text: modelData.trackTitle
                                    font.pixelSize: Variable.font.pixelSize.large
                                    Layout.alignment: Qt.AlignHCenter
                                    font.family: Variable.font.family.main
                                    color: Color.colors.on_surface
                                }
                                Text {
                                    text: modelData.trackArtist
                                    font.pixelSize: Variable.font.pixelSize.small
                                    Layout.alignment: Qt.AlignHCenter
                                    font.family: Variable.font.family.main
                                    color: Color.colors.on_surface
                                }
                                RowLayout {
                                    spacing: Variable.margin.small

                                    Layout.alignment: Qt.AlignHCenter
                                    Rectangle {
                                        id: playButton
                                        implicitWidth: Variable.size.larger
                                        implicitHeight: Variable.size.larger
                                        visible: modelData.canPlay
                                        radius: Variable.radius.small
                                        color: playHoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 200
                                            }
                                        }
                                        LucideIcon {
                                            id: playIcon
                                            anchors.centerIn: parent
                                            icon: modelData.isPlaying ? "pause" : "play"
                                            color: playHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                                        }
                                        TapHandler {
                                            onTapped: {
                                                modelData.togglePlaying();
                                            }
                                        }
                                        HoverHandler {
                                            id: playHoverHandler
                                        }
                                    }
                                    Rectangle {
                                        id: previousButton
                                        implicitWidth: Variable.size.large
                                        implicitHeight: Variable.size.large
                                        visible: modelData.canGoPrevious
                                        radius: Variable.radius.small
                                        color: "transparent"
                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 200
                                            }
                                        }
                                        TapHandler {
                                            onTapped: {
                                                modelData.previous();
                                                modelData.position = 0;
                                            }
                                        }
                                        HoverHandler {
                                            id: previousHoverHandler
                                        }
                                        LucideIcon {
                                            id: previousIcon
                                            anchors.centerIn: parent
                                            icon: "skip-back"
                                            color: previousHoverHandler.hovered ? Color.colors.on_surface_variant : Color.colors.on_surface
                                        }
                                    }
                                    Rectangle {
                                        id: nextButton
                                        implicitWidth: Variable.size.large
                                        implicitHeight: Variable.size.large

                                        visible: modelData.canGoNext
                                        radius: Variable.radius.small
                                        color: "transparent"
                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 200
                                            }
                                        }
                                        LucideIcon {
                                            id: nextIcon
                                            anchors.centerIn: parent
                                            icon: "skip-forward"
                                            color: nextHoverHandler.hovered ? Color.colors.on_surface_variant : Color.colors.on_surface
                                        }
                                        HoverHandler {
                                            id: nextHoverHandler
                                        }
                                        TapHandler {
                                            onTapped: {
                                                modelData.next();
                                                modelData.position = 0;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: powerButton
                    implicitWidth: Variable.size.larger
                    implicitHeight: Variable.size.larger
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.bottomMargin: Variable.margin.normal
                    anchors.leftMargin: Variable.margin.normal

                    // border.width: Variable.uiScale(2)
                    // border.color: powerHoverHandler.hovered ? Color.colors.primary : Color.colors.primary_container
                    radius: Variable.radius.small
                    color: powerHoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface
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
                    // Behavior on border.color {
                    //     ColorAnimation {
                    //         duration: 200
                    //     }
                    // }
                    LucideIcon {
                        id: powerIcon
                        anchors.centerIn: parent
                        icon: "power"
                        // color: powerHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                        color: Color.colors.primary
                    }
                    Menu {
                        id: powerMenu
                        padding: Variable.margin.small
                        implicitWidth: Variable.uiScale(200)
                        y: -Variable.margin.small - powerMenu.height
                        background: Rectangle {
                            id: backgroundMenu
                            radius: Variable.radius.normal
                            color: Color.colors.surface
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
                                    color: menuHoverHandler.hovered ? Color.colors.surface_container : Color.colors.surface
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
                                        color: Color.colors.on_surface
                                    }
                                }
                                onTriggered: modelData.action()
                            }
                        }
                    }
                }
            }
        }
    }
}
