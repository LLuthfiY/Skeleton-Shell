import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Quickshell

import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property var notificationObject
    property bool hasAppIcon: notificationObject.appIcon !== ""
    property bool hasImage: notificationObject.image !== ""

    function resolveIcon(icon) {
        if (!icon || icon === "")
            return "";

        // Reject stale qsimage handles (session-only)
        if (icon.startsWith("image://qsimage/"))
            return "";

        // Allow other providers
        if (icon.startsWith("image://"))
            return icon;

        if (icon.startsWith("/"))
            return "file://" + icon;

        return "image://icon/" + icon;
    }

    Rectangle {
        id: background
        color: Color.colors.primary_container
        width: Variable.size.notificationAppIconSize
        height: Variable.size.notificationAppIconSize
        radius: 100
        Loader {
            id: iconLoader
            anchors.fill: parent
            sourceComponent: hasImage ? imageComponent : hasAppIcon ? appIconComponent : emptyComponent
        }
    }

    Component {
        id: imageComponent
        Image {
            id: image
            source: root.resolveIcon(notificationObject.image)
            Layout.preferredWidth: Variable.size.notificationAppIconSize
            Layout.preferredHeight: Variable.size.notificationAppIconSize
            Layout.alignment: Qt.AlignVCenter
        }
    }

    Component {
        id: appIconComponent
        Image {
            id: appIcon
            source: root.resolveIcon(notificationObject.appIcon)
            Layout.preferredWidth: Variable.size.notificationAppIconSize
            Layout.preferredHeight: Variable.size.notificationAppIconSize
            Layout.alignment: Qt.AlignVCenter
        }
    }

    Component {
        id: emptyComponent
        Rectangle {
            width: Variable.size.notificationAppIconSize
            height: Variable.size.notificationAppIconSize
            color: "transparent"
            LucideIcon {
                id: icon
                icon: "message-circle"
                color: Color.colors.primary
                font.pixelSize: Variable.font.pixelSize.huge
                anchors.centerIn: parent
            }
        }
    }
}
