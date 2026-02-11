pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    function formatTime(time) {
        const diff = Math.floor((Date.now() - time) / 1000);
        if (diff < 10)
            return "just now";
        if (diff < 60)
            return diff + " seconds ago";
        if (diff < 3600)
            return Math.floor(diff / 60) + " minutes ago";
        if (diff < 86400)
            return Math.floor(diff / 3600) + " hours ago";
        return Math.floor(diff / 86400) + " days ago";
    }
}
