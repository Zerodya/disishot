#!/bin/bash

# Discord webhook URL
url=https://discord.com/api/webhooks/XXXXXXXX/XXXXXXXXX

# Which temperature to monitor (Run `sensors` to find which one you want to monitor)
temptype="temp1"

sensors | grep -e "$temptype" | while read line; do
        temp=$(echo $line | awk -F "+" '{ print $2 }' | awk -F "." '{ print $1 }');

        # Alert message:
        message="$(hostname)'s temperature is currently $temp degrees"
	
        curl -H 'Content-type: application/json' -X POST -d "{\"content\":\"$message\"}" $url;
        done
