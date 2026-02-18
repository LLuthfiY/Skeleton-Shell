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
    property bool onTask: false

    signal chatUpdated

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

    Process {
        id: chatOllamaProcess
        stdout: StdioCollector {
            id: chatOllamaCollector
            waitForEnd: true
            // property string unCompletedMessage: ""
            // property QtObject lastObject: null
            // property string lastText: ""
            // property int updateCount: 20
            // onDataChanged: {
            //     if (!lastObject) {
            //         lastObject = chatObject.createObject(root, {
            //             "text": "",
            //             "isUser": false
            //         });
            //         chatHistory = [...chatHistory, lastObject];
            //     }
            //
            //     const words = this.text.trim().split("\n");
            //     for (let i = 0; i < words.length; i++) {
            //         let json = JSON.parse(words[i]);
            //         const content = words[i].match(/"content":"(.*?)"/)[1];
            //         if (content) {
            //             lastText += (lastObject.text.length > 0 ? " " : "") + content;
            //         }
            //         updateCount--;
            //         if (updateCount <= 0) {
            //             lastObject.text += lastText;
            //             lastText = "";
            //             updateCount = 20;
            //         }
            //     }
            // }
            // onTextChanged: {
            //     const text = chatOllamaCollector.unCompletedMessage + this.text;
            //     const words = text.trim().split("\n");
            //     unCompletedMessage = "";
            //     for (const word of words) {
            //         if (word.endsWith("}")) {
            //             const content = JSON.parse(word).message.content;
            //             if (content) {
            //                 chatHistory[chatHistory.length - 1].text += (chatHistory[chatHistory.length - 1].text.length > 0 ? " " : "") + content;
            //             }
            //         } else {
            //             unCompletedMessage = word;
            //         }
            //     }
            // }
            onStreamFinished: {
                // lastObject = null;
                // lastText = "";
                // updateCount = 20;
                // console.log(this.text);
                chatHistory[chatHistory.length - 1].text = JSON.parse(this.text).message.content;
                root.onTask = false;
                root.chatUpdated();
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
        if (root.onTask) {
            return;
        }
        root.onTask = true;
        const co = chatObject.createObject(root, {
            "text": message,
            "isUser": true
        });
        chatHistory = [...chatHistory, co];
        chatOllamaProcess.command = ["bash", Directory.shell.replace("file://", "") + "/scripts/ollama/run.sh", Config.options.services.ai.ollama.model, message];
        const co2 = chatObject.createObject(root, {
            "text": "Thinking...",
            "isUser": false
        });
        chatHistory = [...chatHistory, co2];
        chatOllamaProcess.running = true;
    }
}
