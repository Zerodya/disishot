#!/bin/bash

# Discord webhook URL
url=https://discord.com/api/webhooks/XXXXXXXX/XXXXXXXXX

sensors | grep -e "temp1" | while read line; do
        temp=$(echo $line | awk -F "+" '{ print $2 }' | awk -F "." '{ print $1 }');

        # Alert message:
        message="$(hostname)'s temperature is currently $temp degrees"
	
        curl -H 'Content-type: application/json' -X POST -d "{\"content\":\"$message\"}" $url;
        done
