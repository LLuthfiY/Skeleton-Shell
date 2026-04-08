pragma Singleton
import Quickshell

Singleton {
    id: root
    function iconPath(className) {
        const iconManualMap = {
            // Browsers
            "zen-alpha": "zen-browser",
            "zen": "zen-browser",
            "Navigator": "firefox",
            "firefox-esr": "firefox",
            "Brave-browser": "brave-desktop",
            "Google-chrome": "google-chrome",

            // Development
            "code-url-handler": "vscode",
            "code-oss": "vscode",
            "VSCodium": "vscodium",
            "jetbrains-studio": "android-studio",
            "jetbrains-idea-ce": "idea",

            // Communication & Media
            "Spotify": "spotify-client",
            "com.rtm.slack": "slack",
            "org.telegram.desktop": "telegram",
            "Gnome-terminal": "utilities-terminal",
            "pavucontrol": "multimedia-volume-control",
            "thunar": "system-file-manager",
            "org.gnome.Nautilus": "system-file-manager"
        };
        if (iconManualMap[className]) {
            return Quickshell.iconPath(iconManualMap[className], true);
        }
        return Quickshell.iconPath(className, true);
    }
}
