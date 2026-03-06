pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

import qs.modules.common

Singleton {
    id: root
    property bool onProgress: false
    function cloneRepo(url) {
        onProgress = true;
        let repo = url.replace("https://", "").replace("http://", "");
        repo = repo.endsWith(".git") ? repo.slice(0, -4) : repo;
        cloneProcess.command = ["git", "clone", url, Directory.trimFileProtocol(Directory.repos + "/" + repo)];
        cloneProcess.running = true;
    }
    Process {
        id: cloneProcess
        stdout: StdioCollector {
            onStreamFinished: {
                root.onProgress = false;
            }
        }
    }
}
