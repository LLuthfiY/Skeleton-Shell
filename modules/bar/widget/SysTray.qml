//@ pragma UseQApplication
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Services.SystemTray

import qs.modules.common

Item {
    id: root
    property bool vertical: Config.options.bar.position === "left" || Config.options.bar.position === "right"
    implicitWidth: sysTrayLoader.item ? sysTrayLoader.item.implicitWidth : 0
    implicitHeight: sysTrayLoader.item ? sysTrayLoader.item.implicitHeight : 0

    Loader {
        id: sysTrayLoader
        sourceComponent: root.vertical ? verticalComp : horizontalComp
    }

    Component {
        id: horizontalComp
        RowLayout {
            spacing: 4
            anchors.fill: parent
            Repeater {
                model: SystemTray.items
                SysTrayItem {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
            }
        }
    }

    Component {
        id: verticalComp
        ColumnLayout {
            anchors.fill: parent
            spacing: 4
            Repeater {
                model: SystemTray.items
                SysTrayItem {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
            }
        }
    }
}
