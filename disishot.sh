#!/bin/bash

# Check if dependencies are installed
if [[ "$(which sensors)" == "" ]]; then
	echo "Missing package 'xsensors'. Please install it before proceeding."
	exit 0
fi

# Check if config file exists
configfile="disishot.conf"
dir=$(dirname "${BASH_SOURCE[0]}")
if [ ! -f "$dir/$configfile" ] && [[ "$1" != "--config" ]]; then
    echo "Config file not found. Run again with the '--config' option to generate one in the current path."
    exit 0
fi

# Configuration
if [[ "$1" == "--config" ]]; then

	# Detect Ctrl-C to avoid corruption of the config file
	trap ctrl_c INT
	function ctrl_c() {
        	if [ -f "$dir/$configfile" ]; then
                	rm $configfile
        	fi
        	exit 1
	}

	# Create config file
	cd $dir
	if [ -f "$dir/$configfile" ]; then
		rm $configfile
	fi
	touch $configfile

	# Add tempsensor variable
	echo ">> These are all the sensors available in your system:"
	sensors
	while true; do
		echo -e ">> You can choose between these:"
		sensors | grep + | cut -d ":" -f1
		echo ""
		read -p ">> Temperature sensor you want to monitor: " tempsensor
		if [ -z "$(sensors | grep + | cut -d ":" -f1 | grep -w "$tempsensor")" ]; then
			echo ">> This sensor was not found. Try again."; continue
		else
			echo "tempsensor=$tempsensor" >> $configfile;
			break
		fi
	done

	# Add url variable
	while true; do
		read -p ">> Discord webhook URL: " url
                if [ -z "$(echo $url | grep "https://discord.com/api/webhooks/")" ]; then
                        echo ">> The link provided is not correct. Try again."; continue
                else
                        echo "url=$url" >> $configfile;
                        break
                fi
        done

	# Add treshold variable
	while true; do
		read -p ">> Temperature treshold for when to send the alert: " treshold
                echo "treshold=$treshold" >> $configfile;
        done

	# Exits the configuration
	exit 0
fi

# Sources the config file
. $configfile

# Executes the actual script
sensors | grep -e "$tempsensor" | while read line; do
	# Get temp
        temp=$(echo $line | awk -F "+" '{ print $2 }' | awk -F "." '{ print $1 }');
	
	# Alert message:
        message="ALERT for $(hostname). Temperature is $temp degrees."

	# Send Discord notification
        if (( temp > $threshold )); then
                curl -H 'Content-type: application/json' -X POST -d "{\"content\":\"$message\"}" $url;
        fi;
        done
