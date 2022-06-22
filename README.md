# TAOD - Temp Alert Over Discord
**A bash script that sends you a Discord notification whenever your server is running too hot.**

Works by using `xsensors` to check the temperature and [Discord Webhooks](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) to send  the notification. Should be used with `cron` to periodically check if the temperature is too high.

## Dependencies
- xsensors

`apt install xsensors`

## Configuration
Edit the script: 
1. Add your Discord Webhook URL.
2. Choose a temperature treshold.
3. Change the notification message (optional).

## Cron job
Add a line to your crontab to periodically run the script by using `crontab -e`.

Example of a cron job running every 5 minutes:
```
*/5 * * * * /path/to/temp-alert-over-discord.sh
```
