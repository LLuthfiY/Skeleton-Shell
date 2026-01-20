pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.modules.common
import qs.modules.common.functions

Singleton {
    id: root
    property QtObject sizes
    property QtObject font

    sizes: QtObject {
        property int notificationPopupWidth: 400
    }
    font: QtObject {
        property QtObject family: QtObject {
            property string main: "Open Sans"
            property string title: "Open Sans"
            property string iconMaterial: "Material Symbols Rounded"
            property string iconNerd: "CaskaydiaCove NFP"
            property string monospace: "CaskaydiaMono NFP"
            property string reading: "Readex Pro"
            property string expressive: "Space Grotesk"
        }
        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 12
            property int small: 15
            property int normal: 16
            property int large: 17
            property int larger: 19
            property int huge: 22
            property int hugeass: 23
            property int title: huge
        }
    }
}
