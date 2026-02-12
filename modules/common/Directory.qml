pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import Qt.labs.platform

Singleton {
    id: root

    function trimFileProtocol(str) {
        return str.startsWith("file://") ? str.slice(7) : str;
    }

    // Standard paths, with file:// prefix
    readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]
    readonly property string genericCache: StandardPaths.standardLocations(StandardPaths.GenericCacheLocation)[0]
    readonly property string documents: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
    readonly property string downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]
    readonly property string pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    readonly property string music: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
    readonly property string videos: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]

    readonly property string shell: StandardPaths.standardLocations(StandardPaths.GenericDataLocation)[0] + "/Skeleton-Shell"

    readonly property string configFile: config + "/Skeleton-Shell/config.json"
    readonly property string colorFile: config + "/Skeleton-Shell/colors.json"
    readonly property string notificationsPath: trimFileProtocol(`${Directory.cache}/notifications/notifications.json`)
    readonly property string hyprlandConfig: trimFileProtocol(`${Directory.config}/hypr/Skeleton-Shell/config.conf`)
}
