pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.common.functions

Singleton {
    id: root

    property real scale: Config.options.appearance.uiScale
    property QtObject size
    property QtObject font
    property QtObject margin
    property QtObject radius

    function uiScale(size) {
        return Math.round(size * root.scale);
    }

    FontLoader {
        id: lucide
        source: Directory.shell + "/assets/fonts/lucide.ttf"
    }
    FileView {
        id: lucideJsonFile
        path: Directory.shell + "/assets/fonts/lucide.json"
        blockLoading: true
    }
    readonly property var lucideJson: JSON.parse(lucideJsonFile.text())

    size: QtObject {
        property int notificationPopupWidth: 400 * root.scale
        property int notificationHistoryWidth: 200 * root.scale
        property int notificationAppIconSize: 48 * root.scale
        property int dashboardWidth: 400 * root.scale

        property int smallest: 4 * root.scale
        property int small: 8 * root.scale
        property int normal: 16 * root.scale
        property int large: 24 * root.scale
        property int larger: 32 * root.scale
        property int huge: 48 * root.scale
        property int hugeass: 64 * root.scale
    }
    font: QtObject {
        property QtObject family: QtObject {
            property string main: "Noto Sans"
            property string iconLucide: lucide.font.family
        }
        property QtObject pixelSize: QtObject {
            property int smallest: 10 * root.scale
            property int smaller: 12 * root.scale
            property int small: 14 * root.scale
            property int normal: 16 * root.scale
            property int large: 17 * root.scale
            property int larger: 19 * root.scale
            property int huge: 22 * root.scale
            property int hugeass: 23 * root.scale
            property int title: huge * root.scale
        }
    }

    margin: QtObject {
        property int smallest: 4 * root.scale
        property int small: 8 * root.scale
        property int normal: 16 * root.scale
        property int large: 24 * root.scale
        property int larger: 32 * root.scale
        property int huge: 48 * root.scale
        property int hugeass: 64 * root.scale
    }

    radius: QtObject {
        property int smallest: 4 * root.scale
        property int small: 8 * root.scale
        property int normal: 16 * root.scale
        property int large: 24 * root.scale
        property int larger: 32 * root.scale
        property int huge: 48 * root.scale
        property int hugeass: 64 * root.scale
    }
}
