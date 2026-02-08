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
    property int size: 24
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
        Rectangle {
            id: prevMonthButton
            property bool isHovered: false
            width: root.size
            height: root.size
            radius: Variable.radius.small
            color: isHovered ? Color.colors.primary : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    prevMonthButton.isHovered = true;
                }
                onExited: {
                    prevMonthButton.isHovered = false;
                }
                onClicked: {
                    root.date = new Date(root.date.getFullYear(), root.date.getMonth() - 1, root.date.getDate());
                }
            }
            LucideIcon {
                icon: "chevron-left"
                color: prevMonthButton.isHovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
            }
        }
        Rectangle {
            id: currentMonthButton
            property bool isHovered: false
            width: 80
            height: root.size
            radius: Variable.radius.small
            color: isHovered ? Color.colors.primary : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    currentMonthButton.isHovered = true;
                }
                onExited: {
                    currentMonthButton.isHovered = false;
                }
                onClicked: {
                    root.date = systemClock.date;
                }
            }

            Text {
                id: currentMonthText
                text: Qt.formatDate(root.date, "MMMM")
                font.family: Variable.font.family.main
                font.weight: Font.Bold
                color: currentMonthButton.isHovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
            }
        }
        Rectangle {
            id: nextMonthButton
            property bool isHovered: false
            width: root.size
            height: root.size
            radius: Variable.radius.small
            color: isHovered ? Color.colors.primary : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    nextMonthButton.isHovered = true;
                }
                onExited: {
                    nextMonthButton.isHovered = false;
                }
                onClicked: {
                    root.date = new Date(root.date.getFullYear(), root.date.getMonth() + 1, root.date.getDate());
                }
            }
            LucideIcon {
                icon: "chevron-right"
                color: nextMonthButton.isHovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
            }
        }
        Item {
            Layout.fillWidth: true
        }
        Rectangle {
            id: prevYearButton
            property bool isHovered: false
            width: root.size
            height: root.size
            radius: Variable.radius.small
            color: isHovered ? Color.colors.primary : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    prevYearButton.isHovered = true;
                }
                onExited: {
                    prevYearButton.isHovered = false;
                }
                onClicked: {
                    root.date = new Date(root.date.getFullYear() - 1, root.date.getMonth(), root.date.getDate());
                }
            }
            LucideIcon {
                icon: "chevron-left"
                color: prevYearButton.isHovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
            }
        }
        Rectangle {
            id: currentYearButton
            property bool isHovered: false
            width: 48
            height: root.size
            radius: Variable.radius.small
            color: isHovered ? Color.colors.primary : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    currentYearButton.isHovered = true;
                }
                onExited: {
                    currentYearButton.isHovered = false;
                }
                onClicked: {
                    root.date = new Date(root.date.getFullYear(), root.date.getMonth(), root.date.getDate());
                }
            }

            Text {
                id: currentYearText
                text: Qt.formatDate(root.date, "yyyy")
                font.family: Variable.font.family.main
                font.weight: Font.Bold
                color: currentYearButton.isHovered ? Color.colors.on_primary : Color.colors.primary
                anchors.centerIn: parent
            }
        }
        Rectangle {
            id: nextYearButton
            property bool isHovered: false
            width: root.size
            height: root.size
            radius: Variable.radius.small
            color: isHovered ? Color.colors.primary : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    nextYearButton.isHovered = true;
                }
                onExited: {
                    nextYearButton.isHovered = false;
                }
                onClicked: {
                    root.date = new Date(root.date.getFullYear() + 1, root.date.getMonth(), root.date.getDate());
                }
            }
            LucideIcon {
                icon: "chevron-right"
                color: nextYearButton.isHovered ? Color.colors.on_primary : Color.colors.primary
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
            anchors.leftMargin: 8
            anchors.rightMargin: 8

            delegate: Rectangle {
                width: root.size
                height: root.size
                radius: Variable.radius.small
                color: "transparent"
                Text {
                    text: model.shortName
                    font.pixelSize: 14
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
        height: dayOfWeekRow.implicitWidth + 16
        // Layout.preferredHeight: dayOfWeekRow.implicitWidth * 6 / 7
        color: "transparent"
        clip: true
        WeekNumberColumn {
            id: weekNumberColumn
            locale: Qt.locale("en_US")
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.bottomMargin: 8
            month: root.date.getMonth()
            year: root.date.getFullYear()

            delegate: Rectangle {
                width: root.size
                height: root.size
                radius: Variable.radius.small
                color: "transparent"
                Text {
                    text: model.weekNumber
                    font.pixelSize: 14
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
        border.width: 2
        color: "transparent"
        radius: Variable.radius.small
        Layout.column: 1
        Layout.row: 2
        Layout.fillWidth: true

        MonthGrid {
            id: monthGrid
            locale: Qt.locale("en_US")
            anchors.fill: parent
            anchors.margins: 8
            month: root.date.getMonth()
            year: root.date.getFullYear()

            delegate: Rectangle {
                width: root.size
                height: root.size
                radius: Variable.radius.small
                property bool isCurrent: model.day === systemClock.date.getDate() && model.month === systemClock.date.getMonth() && model.year === systemClock.date.getFullYear()
                property bool sameMonth: model.month === root.date.getMonth() && model.year === root.date.getFullYear()
                border.color: isCurrent ? Color.colors.primary : "transparent"
                border.width: 2
                color: "transparent"
                Text {
                    text: model.day
                    font.pixelSize: 14
                    color: parent.sameMonth ? Color.colors.on_surface : "#77" + Color.colors.on_surface.slice(1)
                    font.weight: Font.Bold
                    font.family: Variable.font.family.main
                    anchors.centerIn: parent
                }
            }
        }
    }
}
