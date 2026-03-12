pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

import qs.modules.common

Singleton {
    id: root
    Process {
        id: readJson
        command: ["cat", Config.options.appearance.colorPath]
        stdout: StdioCollector {
            onStreamFinished: {
                const json = JSON.parse(this.text.trim());
                root.applyJson(json);
            }
        }
    }
    function fromWallpaper() {
        let palette = Config.options.appearance.palette.type;
        let darkMode = Config.options.appearance.darkMode ? "dark" : "light";
        let wallpaperPath = Config.options.background.wallpaperPath.toString().replace("file://", "");
        const matugenPath = Directory.trimFileProtocol(Directory.cache + "/Skeleton-Shell/ConfigFolder/matugen/config.toml");
        matugenProcess.command = ["matugen", "-c", matugenPath, "-t", palette, "-m", darkMode, "image", wallpaperPath];
        matugenProcess.running = true;
        Quickshell.execDetached(["gsettings", "set", "org.gnome.desktop.interface", "color-scheme", `prefer-${darkMode}`]);
        WindowManagerUtils.setWM();
    }
    function fromJsonFile() {
        readJson.running = true;
    }
    function applyJson(json) {
        let colors = {};
        const isDark = ColorUtils.isHexDark(json["surface"]);
        for (let key in json) {
            if (json[key][0] === "#" && json[key].length !== 7) {
                continue;
            }
            const rgb = ColorUtils.hexToRgb(json[key]);
            const hsl = ColorUtils.hexToHsl(json[key]);
            const inverted = ColorUtils.invertHex(json[key]);
            const invertedRgb = ColorUtils.hexToRgb(inverted);
            const invertedHsl = ColorUtils.hexToHsl(inverted);
            const defaultColor = {
                hex: json[key],
                hex_stripped: json[key].replace("#", ""),
                hex_alpha: json[key] + "ff",
                hex_alpha_stripped: json[key].replace("#", "") + "ff",
                alpha_hex: json[key].replace("#", "#ff"),
                alpha_hex_stripped: json[key].replace("#", "ff"),
                rgb: `rgb(${rgb.r}, ${rgb.g}, ${rgb.b})`,
                hsl: `hsl(${hsl.h * 360}, ${hsl.s * 100}%, ${hsl.l * 100}%)`,
                hsla: `hsla(${hsl.h * 360}, ${hsl.s * 100}%, ${hsl.l * 100}%, 1.0)`,
                rgba: `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 1.0)`,
                red: rgb.r,
                green: rgb.g,
                blue: rgb.b,
                hue: hsl.h,
                saturation: (hsl.s * 100) + "%",
                lightness: (hsl.l * 100) + "%",
                alpha: 1.0
            };
            const invertedValue = {
                hex: inverted,
                hex_stripped: inverted.replace("#", ""),
                hex_alpha: inverted + "ff",
                hex_alpha_stripped: inverted.replace("#", "") + "ff",
                alpha_hex: inverted.replace("#", "#ff"),
                alpha_hex_stripped: inverted.replace("#", "ff"),
                rgb: `rgb(${invertedRgb.r}, ${invertedRgb.g}, ${invertedRgb.b})`,
                hsl: `hsl(${invertedHsl.h * 360}, ${invertedHsl.s * 100}%, ${invertedHsl.l * 100}%)`,
                hsla: `hsla(${invertedHsl.h * 360}, ${invertedHsl.s * 100}%, ${invertedHsl.l * 100}%, 1.0)`,
                rgba: `rgba(${invertedRgb.r}, ${invertedRgb.g}, ${invertedRgb.b}, 1.0)`,
                red: invertedRgb.r,
                green: invertedRgb.g,
                blue: invertedRgb.b,
                hue: invertedHsl.h,
                saturation: (invertedHsl.s * 100) + "%",
                lightness: (invertedHsl.l * 100) + "%",
                alpha: 1.0
            };
            let value = {
                dark: isDark ? invertedValue : defaultColor,
                light: isDark ? defaultColor : invertedValue,
                default: defaultColor
            };
            colors[key] = value;
        }
        colors["image"] = Directory.trimFileProtocol(Config.options.background.wallpaperPath);
        const matugenValue = {
            colors: colors
        };
        const jsonString = JSON.stringify(matugenValue, null, 4);
        const matugenPath = Directory.trimFileProtocol(Directory.cache + "/Skeleton-Shell/ConfigFolder/matugen/config.toml");
        const matugenColorFormatPath = Directory.trimFileProtocol(Directory.cache + "/Skeleton-Shell/ConfigFolder/colorMatugenFormat.json");
        matugenProcess.command = ["bash", "-c", `echo '${jsonString}' > ${matugenColorFormatPath}`];
        matugenProcess.running = true;
        matugenProcess.command = ["bash", "-c", `matugen -c ${matugenPath} json ${matugenColorFormatPath}`];
        matugenProcess.running = true;
        console.log(ColorUtils.isHexDark(colors["surface"].default.hex));
        Quickshell.execDetached(["gsettings", "set", "org.gnome.desktop.interface", "color-scheme", `prefer-${ColorUtils.isHexDark(colors["surface"].default.hex) ? "dark" : "light"}`]);
        WindowManagerUtils.setWM();
    }
    Process {
        id: matugenProcess
    }
}
