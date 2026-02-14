import QtQuick
import QtQuick.Layouts

Loader {
    id: dynamicLayoutRoot
    property bool vertical: false
    property int spacing: 4

    sourceComponent: dynamicLayoutRoot.vertical ? colComp : rowComp
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    onLoaded: {
        for (let c of dynamicLayoutRoot.children) {
            if (c !== dynamicLayoutRoot.item) {
                c.parent = dynamicLayoutRoot.item;
            }
        }
    }

    Component {
        id: rowComp
        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: dynamicLayoutRoot.spacing
        }
    }

    Component {
        id: colComp
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: dynamicLayoutRoot.spacing
        }
    }
}
