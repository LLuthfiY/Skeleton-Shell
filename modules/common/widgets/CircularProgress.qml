import QtQuick
import QtQuick.Shapes

import qs.modules.common.functions
import qs.modules.common

Item {
    id: root

    property int implicitSize: 40
    property int lineWidth: 5
    property real value: 0.0                // 0.0 to 1.0
    property color colPrimary: Color.colors.primary
    property color colSecondary: ColorUtils.transparentize(Color.colors.primary, 0.5)
    property bool enableAnimation: true
    property int animationDuration: 800
    property var easingType: Easing.OutCubic
    property int gap: 20
    property Component inside: null

    width: implicitSize
    height: implicitSize

    property real degree: value * 360
    property real radius: implicitSize / 2 - lineWidth / 2
    property real centerX: width / 2
    property real centerY: height / 2
    property real startAngle: -90
    property real gapAngle: 15 * gap * lineWidth / implicitSize

    // Animate the degree (sweepAngle)
    Behavior on degree {
        enabled: root.enableAnimation
        NumberAnimation {
            duration: root.animationDuration
            easing.type: root.easingType
        }
    }

    // Background ring (full circle)
    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeColor: colSecondary
            strokeWidth: lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"

            startX: centerX
            startY: centerY - radius

            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.radius
                radiusY: root.radius
                startAngle: root.degree + root.startAngle + root.gapAngle
                sweepAngle: Math.max(360 - root.degree - root.gapAngle * 2, 0)
            }
        }
    }

    // Progress arc
    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeColor: colPrimary
            strokeWidth: lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"

            startX: centerX
            startY: centerY - radius

            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.radius
                radiusY: root.radius
                startAngle: root.startAngle
                sweepAngle: root.degree
            }
        }
    }

    // Center label
    Loader {
        anchors.centerIn: parent
        sourceComponent: root.inside
    }
}
