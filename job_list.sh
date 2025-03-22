#!/bin/bash


# clearing dead screen if any present
screen -wipe

# Find and kill the ngrok process

ngrok_pid=$(pgrep -f "ngrok")
if [ -n "$ngrok_pid" ]; then
    echo "Killing ngrok process with PID: $ngrok_pid"
    pkill -9 "$ngrok_pid"
else
    echo "No ngrok process found."
fi

sleep 1

# Restart ngrok with the start --all command
screen -dmS ngrok_task ngrok start --all

echo "Running Keep App"

pkill -f keep.jar

screen -dmS java_app1 java -jar /home/kali/springboot_app/keep_app/keep.jar

#echo "Running Jenkins"
#screen -dmS jenkins java -jar /usr/share/java/jenkins.war

#echo "Running UrlExtractor"
#screen -dmS java_app2 java -jar /home/kali/springboot_app/url_ext/url_ext.jar
