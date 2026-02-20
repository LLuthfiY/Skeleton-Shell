import QtQuick

import Qt5Compat.GraphicalEffects
import qs.modules.common

Rectangle {
    id: root
    property int dotSpacing: 10 // distance between dots
    property int dotRadius: 4 // size of each dot
    clip: true
    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            // Define a simple color gradient for demonstration
            //
            for (var y = root.dotRadius; y < height; y += root.dotSpacing) {
                for (var x = root.dotRadius; x < width; x += root.dotSpacing) {
                    ctx.fillStyle = Color.colors.primary;
                    ctx.beginPath();
                    ctx.arc(x, y, root.dotRadius, 0, 2 * Math.PI);
                    ctx.fill();
                }
            }
        }

        Component.onCompleted: canvas.requestPaint()
    }
}
