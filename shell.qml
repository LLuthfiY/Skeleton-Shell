//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

import qs.modules.bar
import qs.modules.background
import qs.modules.notification
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.modules.osd
import qs.modules.overview
import qs.modules.mediaPlayer
import qs.modules.popupCloser
import qs.modules.dashboard
import qs.modules.setting
import qs.modules.launcher
import qs.modules.ai
import qs.modules.lockscreen
import qs.modules.barMenu

import qs.modules.common.functions

ShellRoot {
    id: root

    LazyLoader {
        active: Config.ready
        component: Item {
            Component.onCompleted: {
                if (Config.options.appearance.colorFromWallpaper) {
                    Matugen.fromWallpaper();
                } else {
                    Matugen.fromJsonFile();
                }
            }
        }
    }

    LazyLoader {
        active: Config.ready && Config.options.modules.bar
        component: Bar {}
    }

    LazyLoader {
        active: Config.ready && Config.options.modules.barMenu
        component: BarMenu {}
    }

    LazyLoader {
        active: Config.ready && Config.options.bar.borderScreen && Config.options.modules.bar
        component: Border {}
    }

    LazyLoader {
        active: Config.ready && Config.options.modules.lockscreen && GlobalState.screenLocked
        component: Lockscreen {}
    }

    LazyLoader {
        active: Config.ready && Config.options.modules.background
        component: Background {}
    }

    LazyLoader {
        active: Config.ready && Config.options.modules.osd
        component: VolumeOsd {}
    }

    LazyLoader {
        active: Config.ready && Config.options.modules.notification
        component: Notification {}
    }

    LazyLoader {
        active: Config.ready && GlobalState.overviewOpen && Config.options.modules.overview
        component: Overview {}
    }

    LazyLoader {
        active: Config.ready && Config.options.mediaPlayer.enable && Config.options.modules.mediaPlayer
        component: MediaPlayer {}
    }

    LazyLoader {
        active: Config.ready && GlobalState.dashboardOpen && Config.options.modules.dashboard
        component: Dashboard {}
    }

    LazyLoader {
        active: Config.ready && (GlobalState.launcherOpen || GlobalState.dashboardOpen || (GlobalState.overviewOpen && Config.options.windowManager.layout !== "scrolling") || GlobalState.aiChatOpen || GlobalState.barMenuOpen) && Config.options.modules.popupCloser
        component: PopupCloser {}
    }

    LazyLoader {
        active: Config.ready && GlobalState.settingsOpen && Config.options.modules.settings
        component: Setting {}
    }

    LazyLoader {
        active: Config.ready && GlobalState.launcherOpen && Config.options.modules.launcher
        component: Launcher {}
    }

    LazyLoader {
        active: Config.ready && GlobalState.aiChatOpen && Config.options.modules.aiChat
        component: AIChat {}
    }

    Item {
        Repeater {
            model: Config.options.modules.enabled || []

            delegate: Item {
                LazyLoader {
                    active: Config.ready
                    source: Qt.resolvedUrl("./modules/user/" + modelData)
                }
            }
        }
    }
}
