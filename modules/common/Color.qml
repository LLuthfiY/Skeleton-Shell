pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool ready: false
    property string colorFile: Directory.colorFile
    property alias colors: colorJsonAdapter

    function setNestedValue(nestedKey, value) {
        let keys = nestedKey.split(".");
        let obj = root.colors;
        let parents = [obj];

        // Traverse and collect parent objects
        for (let i = 0; i < keys.length - 1; ++i) {
            if (!obj[keys[i]] || typeof obj[keys[i]] !== "object") {
                obj[keys[i]] = {};
            }
            obj = obj[keys[i]];
            parents.push(obj);
        }

        // Convert value to correct type using JSON.parse when safe
        let convertedValue = value;
        if (typeof value === "string") {
            let trimmed = value.trim();
            if (trimmed === "true" || trimmed === "false" || !isNaN(Number(trimmed))) {
                try {
                    convertedValue = JSON.parse(trimmed);
                } catch (e) {
                    convertedValue = value;
                }
            }
        }

        obj[keys[keys.length - 1]] = convertedValue;
    }

    FileView {
        path: root.colorFile
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: colorJsonAdapter

            property string background: "#121318"
            property string error: "#ffb4ab"
            property string error_container: "#93000a"
            property string inverse_on_surface: "#2f3036"
            property string inverse_primary: "#4d5c92"
            property string inverse_surface: "#e3e1e9"
            property string on_background: "#e3e1e9"
            property string on_error: "#690005"
            property string on_error_container: "#ffdad6"
            property string on_primary: "#1d2d61"
            property string on_primary_container: "#dce1ff"
            property string on_primary_fixed: "#03174b"
            property string on_primary_fixed_variant: "#354479"
            property string on_secondary: "#2b3042"
            property string on_secondary_container: "#dee1f9"
            property string on_secondary_fixed: "#161b2c"
            property string on_secondary_fixed_variant: "#424659"
            property string on_surface: "#e3e1e9"
            property string on_surface_variant: "#c6c6d0"
            property string on_tertiary: "#432740"
            property string on_tertiary_container: "#ffd7f6"
            property string on_tertiary_fixed: "#2c122a"
            property string on_tertiary_fixed_variant: "#5b3d57"
            property string outline: "#90909a"
            property string outline_variant: "#45464f"
            property string primary: "#b6c4ff"
            property string primary_container: "#354479"
            property string primary_fixed: "#dce1ff"
            property string primary_fixed_dim: "#b6c4ff"
            property string scrim: "#000000"
            property string secondary: "#c2c5dd"
            property string secondary_container: "#424659"
            property string secondary_fixed: "#dee1f9"
            property string secondary_fixed_dim: "#c2c5dd"
            property string shadow: "#000000"
            property string source_color: "#5c627c"
            property string surface: "#121318"
            property string surface_bright: "#38393f"
            property string surface_container: "#1e1f25"
            property string surface_container_high: "#292a2f"
            property string surface_container_highest: "#34343a"
            property string surface_container_low: "#1a1b21"
            property string surface_container_lowest: "#0d0e13"
            property string surface_dim: "#121318"
            property string surface_tint: "#b6c4ff"
            property string surface_variant: "#45464f"
            property string tertiary: "#e3bada"
            property string tertiary_container: "#5b3d57"
            property string tertiary_fixed: "#ffd7f6"
            property string tertiary_fixed_dim: "#e3bada"
            property string transparent: "transparent"
        }
    }
}
