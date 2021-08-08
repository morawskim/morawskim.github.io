# DevOps apps

## One-Time-Secret sharing platform

`ots` is a one-time-secret sharing platform. The secret is encrypted with a symmetric 256bit AES encryption in the browser before being sent to the server. Afterwards an URL containing the ID of the secret and the password is generated. The password is never sent to the server so the server will never be able to decrypt the secrets it delivers with a reasonable effort. Also the secret is immediately deleted on the first read.

[Luzifer / OTS](https://github.com/Luzifer/ots)

## A service health dashboard

`gatus` - A service health dashboard in Go that is meant to be used as a docker image with a custom configuration file.

The main features of Gatus are:

- **Highly flexible health check conditions**: While checking the response status may be enough for some use cases, Gatus goes much further and allows you to add conditions on the response time, the response body and even the IP address.

- **Ability to use Gatus for user acceptance tests**: Thanks to the point above, you can leverage this application to create automated user acceptance tests.

- **Very easy to configure**: Not only is the configuration designed to be as readable as possible, it's also extremely easy to add a new service or a new endpoint to monitor.

- **Alerting**: While having a pretty visual dashboard is useful to keep track of the state of your application(s), you probably don't want to stare at it all day. Thus, notifications via Slack, Mattermost, PagerDuty and Twilio are supported out of the box with the ability to configure a custom alerting provider for any needs you might have, whether it be a different provider or a custom application that manages automated rollbacks.

- **Metrics**

- **Low resource consumption**: As with most Go applications, the resource footprint that this application requires is negligibly small.

- **Service auto discovery in Kubernetes** (ALPHA)

[TwinProduction / gatus](https://github.com/TwinProduction/gatus)

## Real-time HTTP Intrusion Detection

`teler` is an real-time intrusion detection and threat alert based on web log that runs in a terminal with resources that we collect and provide by the community.

Features:

* **Real-time**: Analyze logs and identify suspicious activity in real-time.

* **Alerting**: teler provides alerting when a threat is detected, push notifications include Slack, Telegram and Discord.

* **Monitoring**: We've our own metrics if you want to monitor threats easily, and we use Prometheus for that.

* **Latest resources**: Collections is continuously up-to-date.

* **Minimal configuration**: You can just run it against your log file, write the log format and let
  teler analyze the log and show you alerts!

* **Flexible log formats**: teler allows any custom log format string! It all depends on how you write the log format in configuration file.

* **Incremental log processing**: Need data persistence rather than [buffer stream](https://linux.die.net/man/1/stdbuf)?
  teler has the ability to process logs incrementally through the on-disk persistence options.


[kitabisa/teler](https://github.com/kitabisa/teler)

## Wiki

`Wiki.js` - A modern, lightweight and powerful wiki app built on Node.js.

[wiki.js](https://wiki.js.org/)

## Realtime log viewer for docker containers

Dozzle is a small lightweight application with a web based interface to monitor Docker logs. It doesn’t store any log files. It is for live monitoring of your container logs only.

Features:
* Intelligent fuzzy search for container names
* Search logs using regex
* Small memory footprint
* Split screen for viewing multiple logs
* Download logs easy
* Live stats with memory and CPU usage
* Authentication with username and password

[Dozzle](https://github.com/amir20/dozzle)

## A docker job scheduler (aka. crontab for docker)

Ofelia is a modern and low footprint job scheduler for docker environments, built on Go. Ofelia aims to be a replacement for the old fashioned cron.

Przykładowa konfiguracja zadania:

```
[job-exec "YOUR_NAME"]
schedule = 0 40 2 * * *
container = YOUR_CONTAINER_NAME
command = /path/to/your/command
user = www-data
```

[Ofelia](https://github.com/mcuadros/ofelia)
