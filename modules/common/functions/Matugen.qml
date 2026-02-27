pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

import qs.modules.common

Singleton {
    id: root
    function setTheme() {
        let palette = Config.options.appearance.palette.type;
        let darkMode = Config.options.appearance.darkMode ? "dark" : "light";
        let wallpaperPath = Config.options.background.wallpaperPath.toString().replace("file://", "");
        const matugenPath = Directory.trimFileProtocol(Directory.cache + "/Skeleton-Shell/ConfigFolder/matugen/config.toml");
        console.log(matugenPath);
        Quickshell.execDetached(["matugen", "-c", matugenPath, "-t", palette, "-m", darkMode, "image", wallpaperPath]);
        Quickshell.execDetached(["gsettings", "set", "org.gnome.desktop.interface", "color-scheme", `prefer-${palette}`]);
        WindowManagerUtils.setWM();
    }
}
