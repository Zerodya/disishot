#!/bin/bash

# Check if dependencies are installed
if [[ "$(which sensors)" == "" ]]; then
        echo "Missing package 'xsensors'. Please install it before proceeding."
        exit 0
fi

# Check if configuration file exists
configfile="disisfine.conf"
dir=$(dirname "${BASH_SOURCE[0]}")
if [ ! -f "$dir/$configfile" ] && [[ "$1" != "-c" ]]; then
    echo "Config file not found. Run again with the '-c' parameter to generate one in the current path."
    exit 0
fi

# Configuration
if [[ "$1" == "-c" ]]; then

        export err="\033[1;31m[-]\033[m"
        export msg="\033[1;32m[+]\033[m"
        export warn="\033[1;33m[!]\033[m"
        export info="\033[0;36m[:]\033[m"
	
	# Detect Ctrl+C to avoid corruption of the config file
	trap ctrl_c INT
	function ctrl_c() {
        	if [ -f "$dir/$configfile" ]; then
			echo -e "\n${err} Operation aborted. Deleting configuration file."
                	rm $configfile
        	fi
        	exit 1
	}
	
	# Print welcome message
	echo -e "\033[1;32m
 	 ____  _     ___     _____ _            _ 
 	|  _ \(_)___|_ _|___|  ___(_)_ __   ___| |
 	| | | | / __|| |/ __| |_  | | '_ \ / _ \ |          
 	| |_| | \__ \| |\__ \  _| | | | | |  __/_|\033[1;34m
 	|____/|_|___/___|___/_|   |_|_| |_|\___(_)
 	                                          "

	# Create config file
	cd $dir
	if [ -f "$dir/$configfile" ]; then
		rm $configfile
	fi
	touch $configfile

	# Show available sensors
	echo -e "${info} These are the sensors available in your system:"
	sensors
	echo -e "\n${info} These are the ones I can monitor:"
	sensors | grep + | cut -d ":" -f1
	echo ""
	
	# Add tempsensor variable
	while true; do

		echo -e "${msg} Which sensor should I monitor?"
		read -p "> " tempsensor
		if [ -z "$(sensors | grep + | cut -d ":" -f1 | grep -w "$tempsensor")" ]; then
			echo -e "${warn} I couldn't find this sensor. Please try again."; continue
		else
			echo "tempsensor=\"$tempsensor\"" >> $configfile;
			break
		fi
	done

	# Add url variable
	while true; do
		echo -e "${msg} What is the Discord webhook URL I should send the alerts to?" 
		read -p "> " url
                if [ -z "$(echo $url | grep "https://discord.com/api/webhooks/")" ]; then
                        echo -e "${warn} The link provided is not correct. Try again."; continue
                else
                        echo "url=\"$url\"" >> $configfile;
                        break
                fi
        done
	
	# Ask for notification test
	while true; do
	    echo -e "\n${msg} Configuration file created! Do you want to receive a test notification? [y/n] " 
	    read -p "> " yn
	    case $yn in
	        [Yy]* ) sensors | grep -e "$tempsensor" | while read line; do
				# Get temp
				temp=$(echo $line | awk -F "+" '{ print $2 }' | awk -F "." '{ print $1 }');
				# Alert message:
				message="Test notification for $(hostname). Temperature is $temp degrees."
				# Send test notification
			        curl -H 'Content-type: application/json' -X POST -d "{\"content\":\"$message\"}" $url;
			done;
			echo -e "${msg} Test notification sent.";
			break;;
	        [Nn]* ) break;;
	        * ) ;;
	    esac
	done
	
	# Remind about cron
	echo -e "\n${warn} Don't forget to run 'crontab -e' to execute this script periodically. Here's an example of a cron job running every 5 minutes:"
	echo -e "\033[0;36m*/5 * * * * /path/to/disisfine.sh\033[m"

	# Exits the configuration
	exit 0
fi

# Sources the config file
. $dir/$configfile

# Executes the actual monitoring script
sensors | grep -e "$tempsensor" | while read line; do
	# Get temp
	temp=$(echo $line | awk -F "+" '{ print $2 }' | awk -F "." '{ print $1 }');
	
	# Alert message:
	message="$(hostname)'s temperature is currently $temp degrees"
	
	# Send Discord notification
	curl -H 'Content-type: application/json' -X POST -d "{\"content\":\"$message\"}" $url;
done
