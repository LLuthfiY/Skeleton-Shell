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

ShellRoot {

    Component.onCompleted: {
        WindowManagerUtils.setWM();
        let app = DesktopEntries.applications;
    }

    LazyLoader {
        active: Config.ready
        component: Bar {}
    }

    LazyLoader {
        active: Config.ready && Config.options.bar.borderScreen
        component: Border {}
    }

    LazyLoader {
        active: Config.ready
        component: Background {}
    }

    LazyLoader {
        active: Config.ready
        component: VolumeOsd {}
    }

    LazyLoader {
        active: Config.ready
        component: Notification {}
    }

    LazyLoader {
        active: Config.ready && GlobalState.overviewOpen
        component: Overview {}
    }

    LazyLoader {
        active: Config.ready && Config.options.mediaPlayer.enable
        component: MediaPlayer {}
    }

    LazyLoader {
        active: Config.ready && GlobalState.dashboardOpen
        component: Dashboard {}
    }

    LazyLoader {
        active: Config.ready && (GlobalState.launcherOpen || GlobalState.dashboardOpen || GlobalState.overviewOpen || GlobalState.aiChatOpen)
        component: PopupCloser {}
    }

    LazyLoader {
        active: Config.ready && GlobalState.settingsOpen
        component: Setting {}
    }

    LazyLoader {
        active: Config.ready && GlobalState.launcherOpen
        component: Launcher {}
    }

    LazyLoader {
        active: Config.ready && GlobalState.aiChatOpen
        component: AIChat {}
    }
}
