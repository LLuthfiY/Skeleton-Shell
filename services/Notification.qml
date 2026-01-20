pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

import qs.modules.common

Singleton {
    id: root
    property bool silent: false
    property var filePath: Directory.notificationsPath
    property list<Notif> list: []
    property var popupList: list.filter(notif => notif.popup)
    property bool popupInhibited: (GlobalState?.sidebarRightOpen ?? false) || silent
    property var latestTimeForApp: ({})

    property int idOffset
    signal initDone
    signal notify(notification: var)
    signal discard(id: int)
    signal discardAll
    signal timeout(id: var)

    component Notif: QtObject {
        id: wrapper
        required property int notificationId
        property Notification notification
        property list<var> actions: notification?.actions.map(action => ({
                    "identifier": action.identifier,
                    "text": action.text
                })) ?? []
        property bool popup: false
        property bool pendingClose: false
        property string appIcon: notification?.appIcon ?? ""
        property string appName: notification?.appName ?? ""
        property string body: notification?.body ?? ""
        property string image: notification?.image ?? ""
        property string summary: notification?.summary ?? ""
        property double time
        property string urgency: notification?.urgency.toString() ?? "normal"
        property Timer timer

        onNotificationChanged: {
            if (notification === null) {}
        }
    }
    function notifToJSON(notif) {
        return {
            "notificationId": notif.notificationId,
            "actions": notif.actions,
            "appIcon": notif.appIcon,
            "appName": notif.appName,
            "body": notif.body,
            "image": notif.image,
            "summary": notif.summary,
            "time": notif.time,
            "urgency": notif.urgency
        };
    }

    function notifToString(notif) {
        return JSON.stringify(notifToJSON(notif), null, 2);
    }

    function stringifyList(list) {
        return JSON.stringify(list.map(notif => notifToJSON(notif)), null, 2);
    }

    function timeoutNotification(id) {
        const index = root.list.findIndex(notif => notif.notificationId === id);
        if (root.list[index] != null)
            root.list[index].pendingClose = true;
        root.timeout(id);
    }

    component NotifTimer: Timer {
        required property int notificationId
        interval: 5000
        running: true
        onTriggered: () => {
            root.timeoutNotification(notificationId);
            destroy();
        }
    }

    Component {
        id: notifComponent
        Notif {}
    }
    Component {
        id: notifTimerComponent
        NotifTimer {}
    }

    FileView {
        id: notifFileView
        path: Qt.resolvedUrl(filePath)
        onLoaded: {
            const fileContents = notifFileView.text();
            root.list = JSON.parse(fileContents).map(notif => {
                return notifComponent.createObject(root, {
                    "notificationId": notif.notificationId,
                    "actions": [],
                    "appIcon": notif.appIcon,
                    "appName": notif.appName,
                    "body": notif.body,
                    "image": notif.image,
                    "summary": notif.summary,
                    "time": notif.time,
                    "urgency": notif.urgency
                });
            });
            let maxId = 0;
            root.list.forEach(notif => {
                maxId = Math.max(maxId, notif.notificationId);
            });

            console.log("[Notifications] File loaded");
            root.idOffset = maxId;
            root.initDone();
        }
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                console.log("[Notifications] File not found, creating new file.");
                root.list = [];
                notifFileView.setText(stringifyList(root.list));
            } else {
                console.log("[Notifications] Error loading file: " + error);
            }
        }
    }
    NotificationServer {
        id: notifServer
        // actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true

        onNotification: notification => {
            notification.tracked = true;
            const newNotifObject = notifComponent.createObject(root, {
                "notificationId": notification.id + root.idOffset,
                "notification": notification,
                "time": Date.now()
            });
            root.list = [...root.list, newNotifObject];

            // Popup
            if (!root.popupInhibited) {
                newNotifObject.popup = true;
                if (notification.expireTimeout != 0) {
                    newNotifObject.timer = notifTimerComponent.createObject(root, {
                        "notificationId": newNotifObject.notificationId,
                        "interval": notification.expireTimeout < 0 ? 5000 : notification.expireTimeout
                    });
                }
            }

            root.notify(newNotifObject);
            notifFileView.setText(stringifyList(root.list));
        }
    }
}
