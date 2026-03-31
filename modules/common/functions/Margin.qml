pragma Singleton
import Quickshell

import qs.modules.common

Singleton {
    id: root
    function windowMargin() {
        return {
            top: (Config.options.bar.position === "top" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0),
            bottom: (Config.options.bar.position === "bottom" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0),
            left: (Config.options.bar.position === "left" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0),
            right: (Config.options.bar.position === "right" || !Config.options.bar.borderScreen ? 0 : Config.options.bar.margin) + Config.options.windowManager.gapsOut + (Config.options.bar.borderScreen ? Config.options.bar.border : 0)
        };
    }
}
