pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.common.functions

Singleton {
    id: root
    property QtObject sizes
    property QtObject font
    property QtObject margin
    property QtObject radius

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

    sizes: QtObject {
        property int notificationPopupWidth: 400
        property int notificationAppIconSize: 48
        property int dashboardWidth: 400
    }
    font: QtObject {
        property QtObject family: QtObject {
            property string main: "Noto Sans"
            property string iconLucide: lucide.font.family
        }
        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 12
            property int small: 14
            property int normal: 16
            property int large: 17
            property int larger: 19
            property int huge: 22
            property int hugeass: 23
            property int title: huge
        }
    }

    margin: QtObject {
        property int smallest: 4
        property int small: 8
        property int normal: 16
        property int large: 24
        property int larger: 32
        property int huge: 48
        property int hugeass: 64
    }

    radius: QtObject {
        property int smallest: 4
        property int small: 8
        property int normal: 16
        property int large: 24
        property int larger: 32
        property int huge: 48
        property int hugeass: 64
    }
}
