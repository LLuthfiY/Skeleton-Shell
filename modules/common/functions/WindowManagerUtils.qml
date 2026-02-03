pragma Singleton
import Quickshell
import QtQuick

import qs.modules.common

Singleton {

    property string position: Config.options.bar.position
    property int margin: Config.options.bar.margin
    property bool borderScreen: Config.options.bar.borderScreen
    property int defaultMargin: Config.options.windowManager.gapsOut + ((borderScreen && Config.options.modules.bar) ? Config.options.bar.border : 0)
    property real activeOpacity: Config.options.windowManager.activeOpacity
    property real inactiveOpacity: Config.options.windowManager.inactiveOpacity
    property real gapsIn: Config.options.windowManager.gapsIn

    property int topMargin: position === "top" ? 0 : margin
    property int rightMargin: position === "right" ? 0 : margin
    property int bottomMargin: position === "bottom" ? 0 : margin
    property int leftMargin: position === "left" ? 0 : margin

    function setBatch() {
        let gaps_out = `${topMargin + defaultMargin},${rightMargin + defaultMargin},${bottomMargin + defaultMargin},${leftMargin + defaultMargin}`;
        if (!(borderScreen & Config.options.modules.bar)) {
            gaps_out = `${defaultMargin},${defaultMargin},${defaultMargin},${defaultMargin}`;
        }
        let gaps_batch = `keyword general:gaps_out ${gaps_out}; keyword general:gaps_in ${Config.options.windowManager.gapsIn};`;
        let opacity_batch = `keyword decoration:active_opacity ${Config.options.windowManager.activeOpacity}; keyword decoration:inactive_opacity ${Config.options.windowManager.inactiveOpacity};`;
        let border_batch = `keyword general:border_size ${Config.options.windowManager.windowBorderSize}; keyword decoration:rounding ${Config.options.windowManager.windowBorderRadius};`;

        Quickshell.execDetached(["hyprctl", "--batch", gaps_batch + opacity_batch + border_batch]);
    }

    Timer {
        id: wmTimer
        interval: Config.options.windowManager.applyConfigDelay
        repeat: false
        onTriggered: {
            setBatch();
        }
    }

    function setWM(delay = 99000) {
        delay = Math.min(delay, Config.options.windowManager.applyConfigDelay);
        wmTimer.interval = delay;
        wmTimer.running = true;
    }
}
