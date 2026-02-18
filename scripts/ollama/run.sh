#!/bin/bash

curl -s "http://localhost:11434/api/chat" \
    -d "{
        \"model\": \"$1\",
        \"messages\": [
            {
                \"content\": \"$2\",
                \"role\": \"user\"
            }
        ],
        \"stream\": false
    }"
