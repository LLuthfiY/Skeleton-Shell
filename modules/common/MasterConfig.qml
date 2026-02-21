pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import qs.modules.common

Singleton {
    id: root

    property bool masterConfigReady: false
    property bool configFolderReady: true
    property bool ready: masterConfigReady && configFolderReady
    property string configFile: Directory.cache + "/Skeleton-Shell/MasterConfig.json"
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

    Process {
        id: createConfigFolder
        command: ["bash", "-c", "ln -sfn " + Directory.trimFileProtocol(Directory.config + "/Skeleton-Shell") + ' ' + Directory.trimFileProtocol(Directory.cache + "/Skeleton-Shell/ConfigFolder")]
        stdout: StdioCollector {
            onStreamFinished: {
                configFolderReady = true;
            }
        }
    }

    FileView {
        path: root.configFile
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoaded: root.masterConfigReady = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
                root.configFolderReady = false;
                createConfigFolder.running = true;
            }
        }

        JsonAdapter {
            id: configOptionJsonAdapter
            property bool defaultConfig: true
            property string configFile: Directory.configFile
        }
    }
}
