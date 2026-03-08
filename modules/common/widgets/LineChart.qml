import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Effects

Canvas { // Visualizer
    id: root
    property list<int> points
    property real maxValue: 100
    property bool live: true
    property color color: Color.colors.primary
    property int lineWidth: 1
    property bool drawBottomLine: true
    property bool fill: false
    property color fillColor: Color.colors.primary
    property color outlineColor: Color.colors.surface_container
    property bool outline: true

    onPointsChanged: () => {
        root.requestPaint();
    }

    anchors.fill: parent
    onPaint: {
        let ctx = getContext("2d");
        ctx.clearRect(0, 0, root.width, root.height);

        if (root.outline) {
            ctx.strokeStyle = root.outlineColor;
            ctx.lineWidth = root.lineWidth + 1;
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(root.width, 0);
            ctx.lineTo(root.width, root.height);
            ctx.lineTo(0, root.height);
            ctx.lineTo(0, 0);
            ctx.stroke();
            ctx.closePath();
        }
        ctx.lineWidth = root.lineWidth;
        ctx.strokeStyle = root.color;
        ctx.beginPath();
        ctx.moveTo(0, root.height - (root.points[0] / root.maxValue) * root.height);
        for (let i = 1; i < root.points.length; i++) {
            ctx.lineTo(root.width * i / (root.points.length - 1), root.height - (root.points[i] / root.maxValue) * root.height);
        }
        if (root.drawBottomLine || root.fill) {
            ctx.lineTo(root.width, root.height);
            ctx.lineTo(0, root.height);
            ctx.lineTo(0, root.height - (root.points[0] / root.maxValue) * root.height);
        }
        if (root.fill) {
            ctx.fillStyle = root.fillColor;
            ctx.fill();
        }
        ctx.stroke();
        ctx.closePath();
    }
}
