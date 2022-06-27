# 🔥 Dis is hot!
**A simple bash script that sends you a Discord notification whenever your server is running too hot.**

[`disishot.sh`](https://github.com/Zerodya/disishot/blob/main/disishot.sh) works by using `xsensors` to check the temperature and [Discord Webhooks](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) to send  the notification. To be used with `cron` to periodically check if the temperature is too high.

The variant [`disisfine.sh`](https://github.com/Zerodya/disishot/blob/main/disisfine.sh) works just the same but it sends a notification about the current temperature regardless of how hot the server is. Its intended use is to be able to quickly check the temperature at a glance so you better mute its Discord channel.

TODO: automated configuration with prompts

## Dependencies
- xsensors

`apt install xsensors`

## Configuration
**This script is not meant to run as is. You need to configure it first.**

Edit the script:

**Step 1.** Run `sensors` and choose which temperature to monitor.

![alt text](https://github.com/Zerodya/disishot/blob/main/screenshot1.png?raw=true)

In my case I want to monitor 'temp1', so I will be editing the variable in the script like this: `tempsensor=temp1`

**Step 2.** Add your Discord Webhook URL.

**Step 3.** Choose a temperature treshold.

**Step 4.** Change the notification message (optional).

Lastly, make the script executable and you're good to go:
```
chmod +x thisishot.sh
```

## Cron job
Add a line to your crontab to periodically run the script by using `crontab -e`.

Example of a cron job running every 5 minutes:
```
*/5 * * * * /path/to/disishot.sh
```
