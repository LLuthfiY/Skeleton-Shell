import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.modules.common

Rectangle {
    id: root
    property int value: 0
    property int min: -100000
    property int max: 100000
    property int step: 1
    property bool editable: true

    color: Color.colors.surface_container
    radius: Variable.radius.normal
    width: wrapper.width
    height: wrapper.height

    RowLayout {
        id: wrapper
        spacing: 2
        Rectangle {
            id: minusButton
            property bool hovered: false
            width: 24
            height: 24
            radius: Variable.radius.small
            color: hovered ? Color.colors.surface_container_high : Color.colors.surface_container
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
                    root.value = Math.max(root.value - root.step, root.min);
                }
            }
            LucideIcon {
                icon: "minus"
                color: Color.colors.on_surface
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
            Layout.preferredWidth: 80
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
            width: 24
            height: 24
            radius: Variable.radius.small
            color: hovered ? Color.colors.surface_container_high : Color.colors.surface_container
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
                    root.value = Math.min(root.value + root.step, root.max);
                }
            }
            LucideIcon {
                icon: "plus"
                color: Color.colors.on_surface
                anchors.centerIn: parent
                font.weight: Font.Normal
            }
        }
    }
}
