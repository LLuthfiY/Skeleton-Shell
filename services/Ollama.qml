pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick

import Quickshell
import Quickshell.Io

import qs.modules.common

Singleton {
    id: root
    property bool active: false
    property list<string> models: []
    property list<ChatObject> chatHistory: []

    component ChatObject: QtObject {
        id: wrapper
        property string text
        property bool isUser: false
    }

    Component {
        id: chatObject
        ChatObject {}
    }

    Process {
        id: checkActiveProcess
        command: ["curl", Config.options.services.ai.ollama.address]
        stdout: StdioCollector {
            onStreamFinished: {
                root.active = this.text.includes("Ollama is running");
            }
        }
    }

    Process {
        id: getModelsProcess
        command: ["curl", Config.options.services.ai.ollama.address + "/api/tags"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.models = JSON.parse(this.text).models.map(model => model.name);
            }
        }
    }

    Timer {
        id: checkActiveTimer
        running: true
        interval: 5000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            checkActiveProcess.running = true;
            getModelsProcess.running = true;
        }
    }

    function getModels() {
        getModelsProcess.running = true;
    }

    function sendMessage(message) {
        const co = chatObject.createObject(root, {
            "text": message,
            "isUser": true
        });
        chatHistory = [...chatHistory, co];
    }
}
