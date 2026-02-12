pragma Singleton
import Quickshell
import QtQuick

import Quickshell.Wayland

import Quickshell.Io

import qs.modules.common

Singleton {
    property var monitorsWithoutBar: Config.options.bar.screenList.length > 0 ? Quickshell.screens.filter(screen => !Config.options.bar.screenList.includes(screen.name)) : []
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

    onMonitorsWithoutBarChanged: {
        setWM();
    }

    FileView {
        id: wmFile
        path: Directory.hyprlandConfig
    }

    function setWM() {
        let gaps_out = `${topMargin + defaultMargin},${rightMargin + defaultMargin},${bottomMargin + defaultMargin},${leftMargin + defaultMargin}`;
        if (!(borderScreen & Config.options.modules.bar)) {
            gaps_out = `${defaultMargin},${defaultMargin},${defaultMargin},${defaultMargin}`;
        }
        let config = `
      general {
        border_size = ${Config.options.windowManager.windowBorderSize}
        gaps_in = ${Config.options.windowManager.gapsIn}
        gaps_out = ${gaps_out}
      }
      decoration {
        rounding = ${Config.options.windowManager.windowBorderRadius}
        active_opacity = ${Config.options.windowManager.activeOpacity}
        inactive_opacity = ${Config.options.windowManager.inactiveOpacity}
      }

      `;

        monitorsWithoutBar.forEach(screen => {
            config += `workspace = m[${screen.name}], gapsout:${defaultMargin}`;
        });

        wmFile.setText(config);
    }
}
