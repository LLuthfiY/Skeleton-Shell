import QtQuick
import QtQuick.Controls

import qs.modules.common

Slider {
    id: slider

    implicitWidth: 280
    implicitHeight: 24

    from: 0
    to: 100
    value: 50

    // Wave
    property real waveHeight: 3
    property real waveLength: 30
    property int waveSpeed: 1800
    property real waveLineWidth: 5
    property color waveColor: Colors.colors.primary

    // Material-style track
    property real trackHeight: 12
    property color trackColor: Colors.colors.primary_container
    property color activeTrackColor: "transparent"
    property real trackRadius: trackHeight / 2

    // Material-style thumb
    property real handleSize: 20
    property real pressedHandleSize: 26
    property color handleColor: Colors.colors.primary
    property color handlePressedColor: Colors.colors.primary
    property color handleBorderColor: Colors.colors.primary
    property real handleBorderWidth: 0

    background: Item {
        x: slider.leftPadding
        y: slider.topPadding
        width: slider.availableWidth
        height: slider.availableHeight

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            height: slider.waveLineWidth
            width: parent.width - slider.handleSize / 1.5 - (slider.value / slider.to) * parent.width
            color: slider.trackColor
            radius: 99
        }

        Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: slider.visualPosition * parent.width - slider.handleSize / 1.2
            height: slider.trackHeight
            radius: slider.trackRadius
            color: "transparent"
            // Removed clip: true so rounded caps are not hard-clipped at the edge

            Canvas {
                id: wave
                // Expand canvas slightly to give lineCap room to render rounded edges
                x: -slider.waveLineWidth
                y: 0
                width: parent.width + slider.waveLineWidth * 2
                height: parent.height

                property real phase: 0

                onPhaseChanged: requestPaint()
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()

                onPaint: {
                    const ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    if (width <= 0)
                        return;

                    const mid = height / 2;
                    const amp = Math.min(slider.waveHeight, height / 2 - 1);
                    const period = Math.max(10, slider.waveLength);
                    const k = 2 * Math.PI / period;

                    // Offset drawing start to match canvas translation offset
                    const startX = slider.waveLineWidth;
                    const drawWidth = width - slider.waveLineWidth * 2;

                    function y(x) {
                        return mid + amp * Math.sin(k * (x - startX) + phase);
                    }

                    function slope(x) {
                        return amp * k * Math.cos(k * (x - startX) + phase);
                    }

                    ctx.lineCap = "round";
                    ctx.strokeStyle = slider.waveColor;
                    ctx.lineWidth = slider.waveLineWidth;

                    ctx.beginPath();
                    ctx.moveTo(startX, y(startX));

                    const step = period / 4;
                    for (let x = startX; x < startX + drawWidth; x += step) {
                        const end = Math.min(x + step, startX + drawWidth);
                        const dx = end - x;

                        ctx.bezierCurveTo(x + dx / 3, y(x) + slope(x) * dx / 3, end - dx / 3, y(end) - slope(end) * dx / 3, end, y(end));
                    }
                    ctx.stroke();
                }

                NumberAnimation on phase {
                    from: 0
                    to: Math.PI * 2
                    duration: Math.max(1, slider.waveSpeed)
                    loops: Animation.Infinite
                    running: true
                }
            }
        }
    }

    handle: Item {
        id: thumb

        implicitWidth: slider.handleSize
        implicitHeight: slider.handleSize

        width: implicitWidth
        height: implicitHeight

        x: slider.leftPadding + slider.visualPosition * slider.availableWidth - width / 2
        y: slider.topPadding + (slider.availableHeight - height) / 2

        Rectangle {
            anchors.centerIn: parent
            width: slider.pressed ? slider.pressedHandleSize + 12 : slider.handleSize + 12
            height: width
            radius: width / 2

            color: slider.handleColor
            opacity: slider.pressed ? 0.12 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                }
            }

            Behavior on width {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on height {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: slider.pressed ? slider.pressedHandleSize : slider.handleSize
            height: slider.pressed ? slider.pressedHandleSize : slider.handleSize
            radius: width / 2

            color: slider.pressed ? slider.handlePressedColor : slider.handleColor

            border.color: slider.handleBorderColor
            border.width: slider.handleBorderWidth

            Behavior on width {
                NumberAnimation {
                    duration: 140
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on height {
                NumberAnimation {
                    duration: 140
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: 140
                }
            }
        }
    }
}
