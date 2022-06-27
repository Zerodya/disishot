#!/bin/bash

# Discord webhook URL
url=https://discord.com/api/webhooks/XXXXXXXX/XXXXXXXXX

# Temperature threshold for when to send alert
threshold=80

# Which temperature to monitor (Run `sensors` to find which one you want to monitor)
tempsensor="temp1"

sensors | grep -e "$tempsensor" | while read line; do
        temp=$(echo $line | awk -F "+" '{ print $2 }' | awk -F "." '{ print $1 }');
        
        # Alert message:
        message="ALERT for $(hostname). Temperature is $temp degrees."
        
        if (( temp > $threshold )); then
                curl -H 'Content-type: application/json' -X POST -d "{\"content\":\"$message\"}" $url;
        fi;
        done
