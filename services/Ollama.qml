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
    property list<ChatObject> chatHistoryWithDummy: [chatObject.createObject(root, {
            "text": "",
            "isUser": false,
            "isLoading": true,
            "model": Config.options.services.ai.ollama.model.slice(),
            "isDummy": true
        }), ...chatHistory]
    property bool onTask: false
    property int numChats: Config.options.services.ai.ollama.maxChatForContext

    signal chatUpdated

    component ChatObject: QtObject {
        id: wrapper
        property string text
        property bool isUser: false
        property bool isLoading: false
        property string model: "Gemma3:1b"
        property bool isDummy: false
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
            onStreamFinished: {
                chatHistory[chatHistory.length - 1].text = JSON.parse(this.text).message.content;
                root.onTask = false;
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
        chatOllamaProcess.command = ["bash", Directory.shell.replace("file://", "") + "/scripts/ollama/run.sh", Config.options.services.ai.ollama.model, message];
        const co2 = chatObject.createObject(root, {
            "text": "",
            "isUser": false,
            "isLoading": true,
            "model": Config.options.services.ai.ollama.model.slice()
        });
        chatHistory = [co2, co, ...chatHistory];
        // chatOllamaProcess.running = true;
        var xhr = new XMLHttpRequest();
        var processedLength = 0;
        var buffer = "";
        xhr.open("POST", "http://localhost:11434/api/chat");
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                // const json = JSON.parse(xhr.responseText);
                // co2.text = json.message.content;
                co2.isLoading = false;
                root.onTask = false;
            }
            if (xhr.readyState === XMLHttpRequest.LOADING) {
                // Get only new data
                var newText = xhr.responseText.substring(processedLength);
                processedLength = xhr.responseText.length;

                buffer += newText;
                var lines = buffer.split("\n");
                buffer = lines.pop();  // keep incomplete line

                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    if (!line)
                        continue;
                    try {
                        var json = JSON.parse(line);

                        if (json.message && json.message.content) {
                            chatHistory[0].text += json.message.content;
                        }
                    } catch (e) {
                        console.log("parse error", e);
                    }
                }
            }
        };

        var data = {
            model: Config.options.services.ai.ollama.model,
            messages: [...chatHistory.slice(1, root.numChats).reverse().map(c => {
                    return {
                        role: c.isUser ? "user" : "assistant",
                        content: c.text
                    };
                })],
            stream: true,
            options: {
                temperature: 0.5
            }
        };
        console.log(JSON.stringify(data));
        xhr.send(JSON.stringify(data));
    }
}
