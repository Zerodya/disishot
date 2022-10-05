# 🔥 DisIsHot!
**A bash script that sends you a Discord notification whenever your server is running too hot.**

[`disishot.sh`](https://github.com/Zerodya/disishot/blob/main/disishot.sh) works by using [xsensors](https://packages.debian.org/bullseye/xsensors) to check the temperature and [Discord Webhooks](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) to send the notification. To be used with `cron` to periodically check if the temperature is too high.

The variant [`disisfine.sh`](https://github.com/Zerodya/disishot/blob/main/disisfine.sh) works just the same but sends a notification about the current temperature regardless of how hot the server is. Its intended use is to be able to quickly check the temperature at a glance so you better mute its Discord channel.

This is what the configuration looks like:

![alt text](https://github.com/Zerodya/disishot/blob/main/configuration.png?raw=true)

## Dependencies
- xsensors

`apt install xsensors`

## Usage
**1.** Download the script and make it executable:
```
wget https://raw.githubusercontent.com/Zerodya/disishot/main/disishot.sh
chmod +x disishot.sh
```

**2.** Run the script with the `-c` parameter to create a configuration file, then follow the instructions:
```
./disishot.sh -c
```

**3.** Add a line to your crontab to periodically run the script by using `crontab -e`.

Example of a cron job running every 5 minutes:
```
*/5 * * * * /path/to/disishot.sh
```
***
### TO DO:
- During the intial setup, choose the sensor with numbers instead of typing the whole word
