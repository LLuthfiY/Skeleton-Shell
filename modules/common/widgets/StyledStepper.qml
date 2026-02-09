import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.modules.common

Rectangle {
    id: root
    property real scale: Config.options.appearance.uiScale
    property real value: 0
    property real min: -100000
    property real max: 100000
    property real step: 1
    property bool editable: true

    color: Color.colors.surface
    radius: Variable.radius.small
    width: wrapper.width
    height: wrapper.height

    RowLayout {
        id: wrapper
        spacing: Variable.margin.normal
        Rectangle {
            id: minusButton
            property bool hovered: false
            width: Variable.size.large
            height: Variable.size.large
            radius: Variable.radius.small
            color: hovered ? Color.colors.primary : "transparent"
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    minusButton.hovered = true;
                }
                onExited: {
                    minusButton.hovered = false;
                }
                onClicked: {
                    root.value = Math.max((root.value - root.step).toFixed(10), root.min);
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            LucideIcon {
                icon: "minus"
                color: parent.hovered ? Color.colors.on_primary : Color.colors.on_surface
                anchors.centerIn: parent
                font.weight: Font.Normal
            }
        }
        TextInput {
            text: root.value
            font.family: Variable.font.family.main
            font.weight: Font.Normal
            color: Color.colors.on_surface
            font.pixelSize: Variable.font.pixelSize.small
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: 80 * root.scale
            readOnly: !root.editable
            validator: IntValidator {
                bottom: root.min
                top: root.max
            }
            onTextChanged: {
                root.value = text;
            }
        }
        Rectangle {
            id: plusButton
            property bool hovered: false
            width: Variable.size.large
            height: Variable.size.large
            radius: Variable.radius.small
            color: hovered ? Color.colors.primary : "transparent"
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    plusButton.hovered = true;
                }
                onExited: {
                    plusButton.hovered = false;
                }
                onClicked: {
                    root.value = Math.min((root.value + root.step).toFixed(10), root.max);
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            LucideIcon {
                icon: "plus"
                color: parent.hovered ? Color.colors.on_primary : Color.colors.on_surface
                anchors.centerIn: parent
                font.weight: Font.Normal
            }
        }
    }
}
