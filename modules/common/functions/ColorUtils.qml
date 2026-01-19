pragma Singleton
import Quickshell

Singleton {
    id: root

    function transparentize(color_hex, alpha = 1) {
        let color = Qt.color(color_hex);
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }
}
