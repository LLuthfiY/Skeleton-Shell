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
    //
    // implicitWidth: 100
    // implicitHeight: 100

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

// import QtQuick
// import Quickshell
// import Quickshell.Services.SystemTray
// import QtQuick.Layouts
// import qs.modules.common
//
// Item {
//     id: root
//     property bool vertical: Config.options.bar.position === "left" || Config.options.bar.position === "right"
//     anchors.fill: parent
//
//     // Calculate implicit dimensions based on content
//     implicitWidth: vertical ? 40 : (sysTrayLoader.item ? sysTrayLoader.item.implicitWidth + anchors.margins * 2 : 0)
//     implicitHeight: vertical ? (sysTrayLoader.item ? sysTrayLoader.item.implicitHeight + anchors.margins * 2 : 0) : 40
//
//     Rectangle {
//         anchors.fill: parent
//         color: Qt.rgba(30, 30, 30, 0.8)
//         border.color: Qt.rgba(100, 100, 100, 0.5)
//         border.width: 1
//         radius: 6
//     }
//
//     Loader {
//         id: sysTrayLoader
//         anchors.centerIn: parent
//         sourceComponent: root.vertical ? verticalComp : horizontalComp
//
//         // Set appropriate implicit dimensions for the loader content
//         // implicitWidth: item ? item.implicitWidth : 0
//         // implicitHeight: item ? item.implicitHeight : 0
//     }
//
//     Component {
//         id: horizontalComp
//         RowLayout {
//             spacing: 8
//             implicitWidth: childrenRect.width
//             implicitHeight: 24
//
//             Repeater {
//                 model: SystemTray.items
//                 delegate: SysTrayItem {}
//             }
//         }
//     }
//
//     Component {
//         id: verticalComp
//         ColumnLayout {
//             spacing: 8
//             implicitWidth: 24
//             implicitHeight: childrenRect.height
//
//             Repeater {
//                 model: SystemTray.items
//                 delegate: SysTrayItem {}
//             }
//         }
//     }
// }
