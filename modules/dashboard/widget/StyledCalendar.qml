import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Universal

import Quickshell

import qs.modules.common
import qs.modules.common.widgets
import qs.services

Rectangle {
    id: root
    Layout.fillWidth: true

    width: parent.width
    height: wrapper.height
    color: "transparent"

    property var date: systemClock.date
    property int temp: Weather.temperature
    property string icon: Weather.icon
    property int buttonSize: Variable.uiScale(36)

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }

    function getCurrentMonth() {
        root.date = systemClock.date;
    }

    function getNextMonth() {
        root.date = new Date(root.date.getFullYear(), root.date.getMonth() + 1, 15);
    }

    function getPrevMonth() {
        root.date = new Date(root.date.getFullYear(), root.date.getMonth() - 1, 15);
    }

    RowLayout {
        id: wrapper
        width: parent.width
        spacing: 0
        Rectangle {
            color: Color.colors.surface_container
            radius: Variable.radius.normal
            width: weatherWrapper.width + Variable.margin.normal
            height: calendarWrapper.height
            ColumnLayout {
                anchors.centerIn: parent
                spacing: Variable.margin.large
                ColumnLayout {
                    id: weatherWrapper
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 0
                    Rectangle {
                        Layout.preferredWidth: weatherIcon.width + Variable.margin.normal
                        Layout.preferredHeight: weatherIcon.height + Variable.margin.normal
                        color: "transparent"
                        LucideIcon {
                            id: weatherIcon
                            anchors.centerIn: parent
                            icon: root.icon
                            font.pixelSize: Variable.uiScale(54)
                            color: Color.colors.on_surface
                        }
                    }
                    Text {
                        text: root.temp + "°C"
                        width: weatherWrapper.width
                        Layout.alignment: Qt.AlignHCenter
                        font.family: Variable.font.family.main
                        font.weight: Font.Bold
                        color: Color.colors.on_surface
                        font.pixelSize: Variable.font.pixelSize.normal
                    }
                }
                Text {
                    text: "-- Next Days --"
                    font.family: Variable.font.family.main
                    color: Color.colors.on_surface
                    font.pixelSize: Variable.font.pixelSize.smallest
                    Layout.alignment: Qt.AlignHCenter
                }
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Repeater {
                        model: Weather.dailyForecast
                        delegate: RowLayout {
                            LucideIcon {
                                icon: Weather.getIcon(modelData.weatherCode)
                                color: Color.colors.on_surface
                                font.pixelSize: Variable.font.pixelSize.small
                            }
                            Text {
                                text: modelData.temperature_2m_min + "\n" + modelData.temperature_2m_max
                                font.family: Variable.font.family.main
                                color: Color.colors.on_surface
                                font.pixelSize: Variable.font.pixelSize.smallest
                            }
                            Text {
                                text: "°C"
                                font.family: Variable.font.family.main
                                color: Color.colors.on_surface
                                font.pixelSize: Variable.font.pixelSize.smallest
                            }
                        }
                    }
                }
            }
        }
        Item {
            Layout.fillWidth: true
        }
        ColumnLayout {
            id: calendarWrapper
            spacing: 0
            RowLayout {
                id: calendarButtons
                spacing: Variable.margin.small
                Layout.alignment: Qt.AlignHCenter
                Rectangle {
                    id: prevMonthButton
                    Layout.preferredWidth: root.buttonSize
                    Layout.preferredHeight: root.buttonSize
                    radius: Variable.radius.normal
                    color: prevMonthHoverHandler.hovered ? Color.colors.surface_container : Color.colors.surface
                    LucideIcon {
                        icon: "chevron-left"
                        color: Color.colors.on_surface
                        anchors.centerIn: parent
                    }

                    HoverHandler {
                        id: prevMonthHoverHandler
                    }

                    TapHandler {
                        onTapped: {
                            root.getPrevMonth();
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }
                Rectangle {
                    Layout.preferredHeight: root.buttonSize
                    Layout.preferredWidth: calendarWrapper.implicitWidth - prevMonthButton.width - nextMonthButton.width - 2 * Variable.margin.normal
                    radius: Variable.radius.normal
                    color: currentMonthHoverHandler.hovered ? Color.colors.surface_container : Color.colors.surface

                    Text {
                        id: currentMonthText
                        text: Qt.formatDate(root.date, "MMMM yyyy")
                        font.family: Variable.font.family.main
                        font.weight: Font.Bold
                        color: Color.colors.on_surface
                        anchors.centerIn: parent
                        font.pixelSize: Variable.font.pixelSize.small
                    }

                    HoverHandler {
                        id: currentMonthHoverHandler
                    }

                    TapHandler {
                        onTapped: {
                            root.getCurrentMonth();
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }
                Rectangle {
                    id: nextMonthButton
                    Layout.preferredWidth: root.buttonSize
                    Layout.preferredHeight: root.buttonSize
                    radius: Variable.radius.normal
                    color: nextMonthHoverHandler.hovered ? Color.colors.surface_container : Color.colors.surface
                    LucideIcon {
                        icon: "chevron-right"
                        color: Color.colors.on_surface
                        anchors.centerIn: parent
                    }

                    HoverHandler {
                        id: nextMonthHoverHandler
                    }

                    TapHandler {
                        onTapped: {
                            root.getNextMonth();
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }
            }
            DayOfWeekRow {
                id: dayOfWeekRow
                Layout.leftMargin: Variable.margin.small
                locale: Qt.locale("en_US")
                spacing: 0
                width: root.buttonSize * 7
                height: root.buttonSize
                delegate: Rectangle {
                    width: root.buttonSize
                    height: root.buttonSize
                    color: "transparent"
                    Text {
                        text: model.shortName
                        font.pixelSize: Variable.font.pixelSize.smallest
                        color: Color.colors.on_surface
                        font.weight: Font.Normal
                        font.family: Variable.font.family.main
                        anchors.centerIn: parent
                    }
                }
            }
            Rectangle {
                id: calendarDaysWrapper
                width: monthGrid.width + 2 * Variable.margin.small
                height: monthGrid.height + 2 * Variable.margin.small
                color: Color.colors.surface_container
                radius: Variable.radius.normal
                MonthGrid {
                    id: monthGrid
                    width: root.buttonSize * 7
                    height: root.buttonSize * 6
                    padding: 0
                    spacing: 0
                    anchors.centerIn: parent
                    delegate: Rectangle {
                        width: root.buttonSize
                        height: root.buttonSize
                        radius: Variable.radius.small
                        property bool isCurrentDay: model.day === systemClock.date.getDate() && model.month === systemClock.date.getMonth() && model.year === systemClock.date.getFullYear()
                        property bool isCurrentMonth: model.month === root.date.getMonth() && model.year === root.date.getFullYear()
                        color: isCurrentDay ? Color.colors.primary : "transparent"
                        Text {
                            text: model.day
                            font.pixelSize: isCurrentMonth ? Variable.font.pixelSize.small : Variable.font.pixelSize.smallest
                            color: isCurrentDay ? Color.colors.on_primary : isCurrentMonth ? Color.colors.on_surface : "#777777"
                            font.weight: Font.Normal
                            font.family: Variable.font.family.main
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }
}
