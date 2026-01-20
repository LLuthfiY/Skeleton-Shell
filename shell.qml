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

ShellRoot {

    Component.onCompleted: {
        WindowManagerUtils.setWM();
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
}
