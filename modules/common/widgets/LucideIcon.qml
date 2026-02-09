import QtQuick
import QtQuick.Layouts

import Quickshell.Io

import qs.modules.common

// Text {
//     id: root
//     required property string icon
//     property string label: ""
//     font.family: Variable.font.family.iconLucide
//     renderType: Text.QtRendering
//     property string iconSymbol: String.fromCharCode(parseInt(Variable.lucideJson[icon].encodedCode.slice(1), 16))
//     // text: String.fromCharCode(parseInt(Variable.lucideJson[icon].encodedCode.slice(1), 16))
//     text: label !== "" ? iconSymbol + " " + label : iconSymbol
// }
//
RowLayout {
    id: root
    required property string icon
    Layout.alignment: Qt.AlignLeft
    property string label: ""
    property int space: Variable.margin.small
    spacing: label !== "" ? space : 0
    property font font: ({
            family: Variable.font.family.main,
            pixelSize: Variable.font.pixelSize.normal,
            weight: Font.Normal
        })
    property string color: Color.colors.on_surface
    property string iconSymbol: String.fromCharCode(parseInt(Variable.lucideJson[icon].encodedCode.slice(1), 16))
    // text: String.fromCharCode(parseInt(Variable.lucideJson[icon].encodedCode.slice(1), 16))
    Text {
        text: iconSymbol
        font.family: Variable.font.family.iconLucide
        font.pixelSize: root.font.pixelSize
        renderType: Text.QtRendering
        color: root.color
    }
    Loader {
        active: label !== ""
        Layout.alignment: root.Layout.alignment
        sourceComponent: Text {
            text: label
            horizontalAlignment: Text.AlignLeft
            font: root.font
            renderType: Text.QtRendering
            color: root.color
        }
    }
}
