import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Universal

import Quickshell

import qs.modules.common
import qs.modules.common.widgets
import qs.services

GridLayout {
    id: root
    property int size: Variable.size.large
    columns: 2
    rows: 3
    property var date: systemClock.date

    SystemClock {
        id: systemClock
        precision: SystemClock.Hours
    }

    RowLayout {
        Layout.row: 0
        Layout.column: 0
        Layout.columnSpan: 2
        spacing: Variable.margin.small
        Rectangle {
            id: prevMonthButton
            width: root.size
            height: root.size
            radius: Variable.radius.small
            color: prevMonthHoverHandler.hovered ? Color.colors.primary : "transparent"
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
                color: prevMonthHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
            }
        }
        Rectangle {
            id: currentMonthButton
            width: 80 * Config.options.appearance.uiScale
            height: root.size
            radius: Variable.radius.small
            color: currentMonthHoverHandler.hovered ? Color.colors.primary : "transparent"
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
                text: Qt.formatDate(root.date, "MMMM")
                font.family: Variable.font.family.main
                font.weight: Font.Bold
                color: currentMonthHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
                font.pixelSize: Variable.font.pixelSize.small
            }
        }
        Rectangle {
            id: nextMonthButton
            width: root.size
            height: root.size
            radius: Variable.radius.small
            color: nextMonthHoverHandler.hovered ? Color.colors.primary : "transparent"
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
                color: nextMonthHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
            }
        }
        Item {
            Layout.fillWidth: true
        }
        Rectangle {
            id: prevYearButton
            width: root.size
            height: root.size
            radius: Variable.radius.small
            color: prevYearHoverHandler.hovered ? Color.colors.primary : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            HoverHandler {
                id: prevYearHoverHandler
            }
            TapHandler {
                onTapped: {
                    root.date = new Date(root.date.getFullYear() - 1, root.date.getMonth(), root.date.getDate());
                }
            }
            LucideIcon {
                icon: "chevron-left"
                color: prevYearHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
            }
        }
        Rectangle {
            id: currentYearButton
            width: 48 * Config.options.appearance.uiScale
            height: root.size
            radius: Variable.radius.small
            color: currentYearHoverHandler.hovered ? Color.colors.primary : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            HoverHandler {
                id: currentYearHoverHandler
            }
            TapHandler {
                onTapped: {
                    root.date = new Date(root.date.getFullYear(), root.date.getMonth(), root.date.getDate());
                }
            }

            Text {
                id: currentYearText
                text: Qt.formatDate(root.date, "yyyy")
                font.family: Variable.font.family.main
                font.weight: Font.Bold
                color: currentYearHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
                font.pixelSize: Variable.font.pixelSize.small
            }
        }
        Rectangle {
            id: nextYearButton
            width: root.size
            height: root.size
            radius: Variable.radius.small
            color: nextYearHoverHandler.hovered ? Color.colors.primary : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            HoverHandler {
                id: nextYearHoverHandler
            }
            TapHandler {
                onTapped: {
                    root.date = new Date(root.date.getFullYear() + 1, root.date.getMonth(), root.date.getDate());
                }
            }
            LucideIcon {
                icon: "chevron-right"
                color: nextYearHoverHandler.hovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
            }
        }
    }
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
        implicitHeight: root.size
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
    Rectangle {
        Layout.column: 0
        Layout.row: 2
        width: root.size
        height: dayOfWeekRow.implicitWidth + 16 * Config.options.appearance.uiScale
        // Layout.preferredHeight: dayOfWeekRow.implicitWidth * 6 / 7
        color: "transparent"
        clip: true
        WeekNumberColumn {
            id: weekNumberColumn
            locale: Qt.locale("en_US")
            anchors.fill: parent
            anchors.topMargin: Variable.margin.small
            anchors.bottomMargin: Variable.margin.small
            month: root.date.getMonth()
            year: root.date.getFullYear()

            delegate: Rectangle {
                width: root.size
                height: root.size
                radius: Variable.radius.small
                color: "transparent"
                Text {
                    text: model.weekNumber
                    font.pixelSize: Variable.font.pixelSize.small
                    font.family: Variable.font.family.main
                    font.weight: Font.Bold
                    color: Color.colors.on_surface
                    anchors.centerIn: parent
                }
            }
        }
    }
    Rectangle {
        implicitWidth: dayOfWeekRow.implicitWidth
        height: weekNumberColumn.parent.height
        border.color: Color.colors.primary_container
        border.width: 2 * Config.options.appearance.uiScale
        color: "transparent"
        radius: Variable.radius.small
        Layout.column: 1
        Layout.row: 2
        Layout.fillWidth: true

        MonthGrid {
            id: monthGrid
            locale: Qt.locale("en_US")
            anchors.fill: parent
            anchors.margins: Variable.margin.small
            month: root.date.getMonth()
            year: root.date.getFullYear()

            delegate: Rectangle {
                width: root.size
                height: root.size
                radius: Variable.radius.small
                property bool isCurrent: model.day === systemClock.date.getDate() && model.month === systemClock.date.getMonth() && model.year === systemClock.date.getFullYear()
                property bool sameMonth: model.month === root.date.getMonth() && model.year === root.date.getFullYear()
                border.color: isCurrent ? Color.colors.primary : "transparent"
                border.width: 2 * Config.options.appearance.uiScale
                color: "transparent"
                Text {
                    text: model.day
                    font.pixelSize: Variable.font.pixelSize.small
                    color: parent.sameMonth ? Color.colors.on_surface : "#77" + Color.colors.on_surface.slice(1)
                    font.weight: Font.Bold
                    font.family: Variable.font.family.main
                    anchors.centerIn: parent
                }
            }
        }
    }
}
