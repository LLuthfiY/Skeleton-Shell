import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Universal

import Quickshell

import qs.modules.common
import qs.modules.common.widgets
import qs.services

Rectangle {
    // height: (root.size) * 7 + month.height + (Variable.margin.normal * 2 * Config.options.appearance.uiScale ^ 2)
    height: calendarButtons.height + rowOfWeekdays.height + month.height + Variable.margin.normal
    // height: root.implicitHeight
    color: "transparent"
    ColumnLayout {
        id: root
        // columnSpacing: 0
        // rowSpacing: 0
        // anchors.fill: parent
        property int size: Variable.size.large
        width: parent.width

        // columns: 2
        // rows: 3
        property var date: systemClock.date

        SystemClock {
            id: systemClock
            precision: SystemClock.Hours
        }

        Rectangle {
            id: calendarButtons
            color: "transparent"
            // Layout.row: 0
            // Layout.column: 0
            // Layout.columnSpan: 2
            Layout.fillWidth: true
            height: root.size
            Rectangle {
                id: prevMonthButton
                width: root.size
                height: root.size
                radius: Variable.radius.small
                anchors.left: parent.left
                color: prevMonthHoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                HoverHandler {
                    id: prevMonthHoverHandler
                }
                TapHandler {
                    onTapped: {
                        root.date = new Date(root.date.getFullYear(), root.date.getMonth() - 1, root.date.getDate());
                    }
                }
                LucideIcon {
                    icon: "chevron-left"
                    color: Color.colors.on_surface
                    anchors.centerIn: parent
                }
            }
            Rectangle {
                id: currentMonthButton
                width: currentMonthText.implicitWidth + Variable.margin.normal
                height: root.size
                radius: Variable.radius.small
                color: currentMonthHoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface
                anchors.centerIn: parent
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                HoverHandler {
                    id: currentMonthHoverHandler
                }
                TapHandler {
                    onTapped: {
                        root.date = systemClock.date;
                    }
                }
                Text {
                    id: currentMonthText
                    text: Qt.formatDate(root.date, "MMMM yyyy")
                    font.family: Variable.font.family.main
                    font.weight: Font.Bold
                    color: Color.colors.on_surface
                    anchors.centerIn: parent
                    font.pixelSize: Variable.font.pixelSize.small
                }
            }
            Rectangle {
                id: nextMonthButton
                anchors.right: parent.right
                width: root.size
                height: root.size
                radius: Variable.radius.small
                color: nextMonthHoverHandler.hovered ? Color.colors.surface_container_high : Color.colors.surface
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                TapHandler {
                    onTapped: {
                        root.date = new Date(root.date.getFullYear(), root.date.getMonth() + 1, root.date.getDate());
                    }
                }
                HoverHandler {
                    id: nextMonthHoverHandler
                }
                LucideIcon {
                    icon: "chevron-right"
                    anchors.centerIn: parent
                    color: Color.colors.on_surface
                }
            }
            // Item {
            //     Layout.fillWidth: true
            // }
            // Rectangle {
            //     id: prevYearButton
            //     width: root.size
            //     height: root.size
            //     radius: Variable.radius.small
            //     color: prevYearHoverHandler.hovered ? Color.colors.primary : "transparent"
            //     Behavior on color {
            //         ColorAnimation {
            //             duration: 200
            //         }
            //     }
            //     HoverHandler {
            //         id: prevYearHoverHandler
            //     }
            //     TapHandler {
            //         onTapped: {
            //             root.date = new Date(root.date.getFullYear() - 1, root.date.getMonth(), root.date.getDate());
            //         }
            //     }
            //     LucideIcon {
            //         icon: "chevron-left"
            //         color: prevYearHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
            //         anchors.centerIn: parent
            //     }
            // }
            // Rectangle {
            //     id: currentYearButton
            //     width: Variable.uiScale(48)
            //     height: root.size
            //     radius: Variable.radius.small
            //     color: currentYearHoverHandler.hovered ? Color.colors.primary : "transparent"
            //     Behavior on color {
            //         ColorAnimation {
            //             duration: 200
            //         }
            //     }
            //     HoverHandler {
            //         id: currentYearHoverHandler
            //     }
            //     TapHandler {
            //         onTapped: {
            //             root.date = new Date(root.date.getFullYear(), root.date.getMonth(), root.date.getDate());
            //         }
            //     }
            //
            //     Text {
            //         id: currentYearText
            //         text: Qt.formatDate(root.date, "yyyy")
            //         font.family: Variable.font.family.main
            //         font.weight: Font.Bold
            //         color: currentYearHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
            //         anchors.centerIn: parent
            //         font.pixelSize: Variable.font.pixelSize.small
            //     }
            // }
            // Rectangle {
            //     id: nextYearButton
            //     width: root.size
            //     height: root.size
            //     radius: Variable.radius.small
            //     color: nextYearHoverHandler.hovered ? Color.colors.primary : "transparent"
            //     Behavior on color {
            //         ColorAnimation {
            //             duration: 200
            //         }
            //     }
            //     HoverHandler {
            //         id: nextYearHoverHandler
            //     }
            //     TapHandler {
            //         onTapped: {
            //             root.date = new Date(root.date.getFullYear() + 1, root.date.getMonth(), root.date.getDate());
            //         }
            //     }
            //     LucideIcon {
            //         icon: "chevron-right"
            //         color: nextYearHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
            //         anchors.centerIn: parent
            //     }
            // }
        }
        RowLayout {
            spacing: 0
            Rectangle {
                Layout.column: 0
                Layout.row: 1
                width: root.size
                height: root.size
                color: "transparent"
            }

            Rectangle {
                id: rowOfWeekdays
                Layout.column: 1
                Layout.row: 1
                Layout.preferredHeight: root.size
                // Layout.preferredWidth: root.size * 7
                Layout.fillWidth: true
                color: "transparent"
                clip: true
                DayOfWeekRow {
                    id: dayOfWeekRow
                    locale: Qt.locale("en_US")
                    anchors.fill: parent
                    anchors.leftMargin: Variable.margin.small
                    anchors.rightMargin: Variable.margin.small

                    delegate: Rectangle {
                        width: root.size
                        height: root.size
                        radius: Variable.radius.small
                        color: "transparent"
                        Text {
                            text: model.shortName
                            font.pixelSize: Variable.font.pixelSize.small
                            color: Color.colors.on_surface
                            font.weight: Font.Bold
                            font.family: Variable.font.family.main
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
        RowLayout {
            id: calendarContent
            spacing: 0
            Layout.preferredHeight: root.implicitWidth
            Rectangle {
                // Layout.column: 0
                // Layout.row: 2
                Layout.preferredHeight: Variable.uiScale(260)
                Layout.preferredWidth: root.size
                Layout.topMargin: Variable.margin.small
                Layout.bottomMargin: Variable.margin.small
                color: "transparent"
                WeekNumberColumn {
                    id: weekNumberColumn
                    year: root.date.getFullYear()
                    month: root.date.getMonth()
                    clip: true
                    anchors.fill: parent
                    anchors.topMargin: Variable.margin.small
                    anchors.bottomMargin: Variable.margin.small
                    delegate: Rectangle {
                        radius: Variable.radius.small
                        color: "transparent"
                        Text {
                            text: model.weekNumber
                            font.pixelSize: Variable.font.pixelSize.small
                            color: Color.colors.on_surface
                            font.weight: Font.Bold
                            font.family: Variable.font.family.main
                            anchors.centerIn: parent
                        }
                    }
                }
            }
            Rectangle {
                Layout.preferredWidth: Variable.uiScale(2)
                Layout.preferredHeight: month.height
                radius: Variable.radius.normal
                color: Color.colors.primary_container
            }
            Rectangle {
                id: month
                Layout.preferredHeight: Variable.uiScale(260)
                Layout.fillWidth: true
                Layout.margins: 0
                color: "transparent"
                radius: Variable.radius.normal
                clip: true
                MonthGrid {
                    id: monthGrid
                    anchors.fill: parent
                    anchors.margins: Variable.margin.small
                    year: root.date.getFullYear()
                    month: root.date.getMonth()
                    padding: 0
                    delegate: Rectangle {
                        width: root.size
                        height: root.size
                        radius: Variable.radius.smallest
                        property bool isCurrentDay: model.day === root.date.getDate() && model.month === root.date.getMonth() && model.year === root.date.getFullYear()
                        property bool isCurrentMonth: model.month === root.date.getMonth() && model.year === root.date.getFullYear()
                        color: isCurrentDay ? Color.colors.primary : "transparent"
                        Text {
                            text: model.day
                            font.pixelSize: Variable.font.pixelSize.small
                            color: isCurrentDay ? Color.colors.on_primary : isCurrentMonth ? Color.colors.on_surface : "#777777"
                            font.weight: Font.Bold
                            font.family: Variable.font.family.main
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }
}
