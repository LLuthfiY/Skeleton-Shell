// DynamicCenterBox.qml
pragma ComponentBehavior: Bound
import QtQuick.Layouts
import QtQuick

import qs.modules.common

Item {
    id: centerBoxRoot
    property bool vertical: false
    property Component startItem: null
    property Component centerItem: null
    property Component endItem: null

    Loader {
        id: layoutLoader
        anchors.fill: parent
        sourceComponent: centerBoxRoot.vertical ? verticalComp : horizontalComp
    }

    implicitWidth: layoutLoader.item ? layoutLoader.item.implicitWidth + centerBoxRoot.anchors.margins * 2 : 0 + centerBoxRoot.anchors.margins * 2
    implicitHeight: layoutLoader.item ? layoutLoader.item.implicitHeight + centerBoxRoot.anchors.margins * 2 : 0 + centerBoxRoot.anchors.margins * 2

    Component {
        id: horizontalComp
        RowLayout {
            RowLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredWidth: Math.max(startLoaderH.implicitWidth, endLoaderH.implicitWidth)
                Loader {
                    id: startLoaderH
                    sourceComponent: centerBoxRoot.startItem
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                }
            }
            Loader {
                sourceComponent: centerBoxRoot.centerItem
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.preferredWidth: Math.max(startLoaderH.implicitWidth, endLoaderH.implicitWidth)
                Loader {
                    id: endLoaderH
                    sourceComponent: centerBoxRoot.endItem
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
            }
        }
    }

    Component {
        id: verticalComp
        ColumnLayout {
            ColumnLayout {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                Layout.preferredHeight: Math.max(startLoader.implicitHeight, endLoader.implicitHeight)
                Loader {
                    id: startLoader
                    sourceComponent: centerBoxRoot.startItem
                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                }
            }

            Loader {
                sourceComponent: centerBoxRoot.centerItem
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                Layout.preferredHeight: Math.max(startLoader.implicitHeight, endLoader.implicitHeight)
                Loader {
                    id: endLoader
                    sourceComponent: centerBoxRoot.endItem
                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                }
            }
        }
    }
}
