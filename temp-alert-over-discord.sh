#!/bin/bash

# Discord webhook URL
url=https://discord.com/api/webhooks/XXXXXXXX/XXXXXXXXX

# Temperature threshold for when to send alert
threshold=80

sensors | grep -e "temp1" | while read line; do
        temp=$(echo $line | awk -F "+" '{ print $2 }' | awk -F "." '{ print $1 }');
        
        # Alert message:
        message="ALERT for $(hostname). Temperature is $temp degrees. That's hot!"
        
        if (( temp > $threshold )); then
                curl -H 'Content-type: application/json' -X POST -d "{\"content\":\"$message\"}" $url;
        fi;
        done
