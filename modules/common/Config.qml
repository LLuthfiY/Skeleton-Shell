pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool ready: false
    property string configFile: Directory.configFile
    property alias options: configOptionJsonAdapter

    function setNestedValue(nestedKey, value) {
        let keys = nestedKey.split(".");
        let obj = root.options;
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
        path: root.configFile
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
            id: configOptionJsonAdapter

            property JsonObject appearance: JsonObject {
                property bool darkMode: true
                property JsonObject palette: JsonObject {
                    property string type: "scheme-tonal-spot" // Allowed: scheme-content, scheme-expressive, scheme-fidelity, scheme-fruit-salad, scheme-monochrome, scheme-neutral, scheme-rainbow, scheme-tonal-spot
                }
                property real uiScale: 1
            }
            property JsonObject background: JsonObject {
                property string wallpaperPath: Directory.config + "/config/wallpaper"
                property string liveWallpaperPath: Directory.config + "/config/livewallpaper"
                property bool liveWallpaper: false
                property bool mute: true
            }
            property JsonObject bar: JsonObject {
                property string position: "top"
                property string foreground: "primary"
                property string background: "surface"
                property string borderColor: "primary"
                property bool fullWidth: false
                property int border: 2
                property bool borderScreen: false
                property int width: 800
                property int margin: 0
                property int borderRadius: 8
                property list<string> startWidgets: []
                property list<string> endWidgets: []
                property list<string> centerWidgets: []
                property list<string> screenList: []
            }

            property JsonObject dashboard: JsonObject {
                property list<string> widgets: ["PowerAndSetting.qml"]
                property string position: "right"
            }

            property JsonObject modules: JsonObject {
                property list<string> enabled: []
                property bool bar: true
                property bool background: true
                property bool dashboard: true
                property bool mediaPlayer: true
                property bool notification: true
                property bool osd: true
                property bool overview: true
                property bool popupCloser: true
            }

            property JsonObject windowManager: JsonObject {
                property int workspaces: 8
                property int gapsOut: 16
                property int gapsIn: 8
                property real activeOpacity: 1
                property real inactiveOpacity: 0.8
                property int windowBorderSize: 0
                property int windowBorderRadius: 16
                property int applyConfigDelay: 1000
            }
            property JsonObject notification: JsonObject {
                property string position: "topRight"
            }
            property JsonObject mediaPlayer: JsonObject {
                property bool enable: false
            }
            property JsonObject interactions: JsonObject {
                property JsonObject scrolling: JsonObject {
                    property bool fasterTouchpadScroll: false
                }
            }
            property JsonObject services: JsonObject {
                property JsonObject geoLocation: JsonObject {
                    property string latitude: "-6.5944"
                    property string longitude: "106.75"
                }
                property JsonObject nightLight: JsonObject {
                    property int state: 0
                    property int nightTemp: 4500
                    property int dayTemp: 5700
                }
                property JsonObject ai: JsonObject {
                    property string provider: "Ollama"
                    property JsonObject ollama: JsonObject {
                        property string apiKey: "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
                        property string model: "gemma3:1b"
                        property string address: "http://localhost:11434"
                    }
                }
            }
        }
    }
}
