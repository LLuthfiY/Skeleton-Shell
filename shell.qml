import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

import qs.modules.bar
import qs.modules.common
import qs.modules.common.functions

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
}
