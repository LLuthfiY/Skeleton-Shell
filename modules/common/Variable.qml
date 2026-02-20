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
        property int notificationPopupWidth: root.uiScale(400)
        property int notificationHistoryWidth: root.uiScale(200)
        property int notificationAppIconSize: root.uiScale(48)
        property int dashboardWidth: root.uiScale(400)
        property int aiChatWidth: root.uiScale(600)

        property int smallest: root.uiScale(4)
        property int small: root.uiScale(8)
        property int normal: root.uiScale(16)
        property int large: root.uiScale(24)
        property int larger: root.uiScale(32)
        property int huge: root.uiScale(48)
        property int hugeass: root.uiScale(64)
    }
    font: QtObject {
        property QtObject family: QtObject {
            property string main: "Noto Sans"
            property string iconLucide: lucide.font.family
        }
        property QtObject pixelSize: QtObject {
            property int smallest: root.uiScale(10)
            property int smaller: root.uiScale(12)
            property int small: root.uiScale(14)
            property int normal: root.uiScale(16)
            property int large: root.uiScale(17)
            property int larger: root.uiScale(19)
            property int huge: root.uiScale(22)
            property int hugeass: root.uiScale(23)
            property int title: huge
        }
    }

    margin: QtObject {
        property int smallest: root.uiScale(4)
        property int small: root.uiScale(8)
        property int normal: root.uiScale(16)
        property int large: root.uiScale(24)
        property int larger: root.uiScale(32)
        property int huge: root.uiScale(48)
        property int hugeass: root.uiScale(64)
    }

    radius: QtObject {
        property int smallest: root.uiScale(4)
        property int small: root.uiScale(8)
        property int normal: root.uiScale(16)
        property int large: root.uiScale(24)
        property int larger: root.uiScale(32)
        property int huge: root.uiScale(48)
        property int hugeass: root.uiScale(64)
    }
}
