pragma Singleton
import Quickshell

Singleton {
    id: root

    function transparentize(color_hex, alpha = 1) {
        let color = Qt.color(color_hex);
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    function hexToRgb(hex) {
        let result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        return result ? {
            r: parseInt(result[1], 16),
            g: parseInt(result[2], 16),
            b: parseInt(result[3], 16)
        } : null;
    }

    function invertHex(hex) {
        hex = hex.replace('#', '');
        // Convert to number, invert, convert back to hex
        return '#' + (0xFFFFFF ^ parseInt(hex, 16)).toString(16).padStart(6, '0').toUpperCase();
    }

    function hexToHsl(hex) {
        let rgb = hexToRgb(hex);
        if (rgb) {
            let r = rgb.r / 255;
            let g = rgb.g / 255;
            let b = rgb.b / 255;
            let max = Math.max(r, g, b);
            let min = Math.min(r, g, b);
            let h, s, l = (max + min) / 2;
            if (max === min) {
                h = s = 0;
            } else {
                let d = max - min;
                s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
                switch (max) {
                case r:
                    h = (g - b) / d + (g < b ? 6 : 0);
                    break;
                case g:
                    h = (b - r) / d + 2;
                    break;
                case b:
                    h = (r - g) / d + 4;
                    break;
                }
                h /= 6;
            }
            return {
                h: h,
                s: s,
                l: l
            };
        }
        return null;
    }

    function isHexDark(hex) {
        let rgb = hexToRgb(hex);
        if (rgb) {
            let r = rgb.r / 255;
            let g = rgb.g / 255;
            let b = rgb.b / 255;
            let luma = 0.2126 * r + 0.7152 * g + 0.0722 * b;
            return luma < 0.5;
        }
        return false;
    }
}
