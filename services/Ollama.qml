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
    property var xhr: null
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

    function stop() {
        if (xhr) {
            xhr.abort();
        }
        root.onTask = false;
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
        xhr = new XMLHttpRequest();
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
                chatHistory[chatHistory.length - 1].text = chatHistory[chatHistory.length - 1].text.replace(/<img data-src=/g, "<img src=");
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
                            json.message.content = json.message.content.replace(/<img src=/g, "<img data-src=");
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
            messages: [
                {
                    role: "user",
                    // content: "Respond using HTML Formatting not markdown, if you need to show image use link from internet as source not base64, also all background color become " + Color.colors.surface
                    content: "respond in Markdown format, if you need to show image show it as link not image. show image with width not more than 500"
                },
                ...chatHistory.slice(1, root.numChats).reverse().map(c => {
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
        xhr.send(JSON.stringify(data));
    }
}
