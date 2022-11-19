# AWS CloudWatch

## Filtrowanie logów

Przesyłając do CloudWatch logi access_log serwera nginx możemy je filtrować po słowie kluczowym, albo po kolumnie.

Standardowy wpis wygląda tak: `127.0.0.1 - - [19/Nov/2022:12:55:04 +0000] "GET /?foo=bar HTTP/1.1" 200 612 "-" "curl/7.68.0"`

W CloudWatch w polu "Filter events" wpisujemy `[remoteAddres, placeholder, remoteUser, date, request, statusCode="404", bodySent, httpReferer, useragent]` aby wyszukać wszystkie wpisy, których kod odpowiedzi HTTP wynosi 404.

Wyszukiwanie po wartości "404" może wyświetlić niepotrzebne dane:

> 127.0.0.1 - - [19/Nov/2022:12:55:10 +0000] "GET /rrr HTTP/1.1" 404 162 "-" "curl/7.68.0"
>
> 127.0.0.1 - - [19/Nov/2022:13:29:13 +0000] "GET /?a404=404 HTTP/1.1" 200 612 "-" "curl/7.68.0"

Stosując symbol `*` wyszukujemy wpisy z kodem 5xx - `[remoteAddres, placeholder, remoteUser, date, request, statusCode="5*", bodySent, httpReferer, useragent]`

## Polityka do przesyłania metryk

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudwatch:PutMetricData",
            "Resource": "*"
        }
    ]
}
```

## Polityka do przesyłania logów

Przykładowy dokument JSON z definicją polityki do przesyłania strumienia logów.
W przykładzie musimy zastąpić symbol `<ARN_LOG_GROUP>` identyfikatorem ARN naszej log-group.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:GetLogEvents",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": [
                "<ARN_LOG_GROUP>:log-stream:*",
                "<ARN_LOG_GROUP>/*:log-stream:*"
            ],
            "Sid": "EnableCreationAndManagementOfCloudwatchLogEvents"
        },
        {
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutRetentionPolicy",
                "logs:CreateLogGroup"
            ],
            "Effect": "Allow",
            "Resource": [
                "<ARN_LOG_GROUP>",
                "<ARN_LOG_GROUP>:log-stream:*",
                "<ARN_LOG_GROUP>/*",
                "<ARN_LOG_GROUP>/*:log-stream:*"
            ],
            "Sid": "EnableCreationAndManagementOfCloudwatchLogGroupsAndStreams"
        }
    ]
}
```

## CloudWatch Agent

Korzystamy z [dokumentacji](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/download-cloudwatch-agent-commandline.html), aby znaleźć adres do pobrania pliku agenta.
Dla ubuntu będzie to [https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb](https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb)

Instalujemy pakiet - `sudo apt-get install ./amazon-cloudwatch-agent.deb`

Logujemy się na konto root - `sudo bash` i konfigurujemy dostęp do AWS - albo za pomocą awscli, albo ręcznie tworząc plik `~/.aws/credentials` o zawartości:

```
[AmazonCloudWatchAgent]
aws_access_key_id = my_access_key
aws_secret_access_key = my_secret_key
```

A także `~/.aws/config` o zawartości:

```
[profile AmazonCloudWatchAgent]
region = eu-central-1
```


Następnie możemy wywołać polecenie `sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard`, aby za pomocą kreatora wygenerować przykładowy plik konfiguracyjny. Albo skorzystać z szablonu poniżej.
Schemat dostępnych opcji konfiguracyjnych znajduje się [w dokumentacji](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)

```
{
	"agent": {
		"metrics_collection_interval": 60,
		"run_as_user": "root"
	},
	"logs": {
		"logs_collected": {
			"files": {
				"collect_list": [
					{
						"file_path": "/my/path/to/log/file.log",
						"log_group_name": "my-group-name",
						"log_stream_name": "{hostname}-mylog",
						"retention_in_days": 7
					}
				]
			}
		}
	},
	"metrics": {
		"metrics_collected": {
			"cpu": {
				"measurement": [
					"cpu_usage_idle",
					"cpu_usage_iowait"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				],
				"totalcpu": true
			},
			"disk": {
				"measurement": [
					"used_percent"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				]
			},
			"diskio": {
				"measurement": [
					"io_time",
					"write_bytes",
					"read_bytes",
					"writes",
					"reads"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				]
			},
			"mem": {
				"measurement": [
					"mem_used_percent"
				],
				"metrics_collection_interval": 60
			},
			"net": {
				"measurement": [
					"bytes_sent",
					"bytes_recv",
					"packets_sent",
					"packets_recv"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				]
			},
			"swap": {
				"measurement": [
					"swap_used_percent"
				],
				"metrics_collection_interval": 60
			}
		}
	}
}

```

W przypadku wykorzystania kreatora plik konfiguracyjny zostanie zapisany w katalogu `/opt/aws/amazon-cloudwatch-agent/bin` pod nazwą `config.json`.

W pliku `/opt/aws/amazon-cloudwatch-agent/etc/common-config.toml` musimy dokonać kliku zmian, jeśli agent ma działać na serwerach on-premise.
Usuwamy znaki komentarza przy sekcji `credentials` i parametrze `shared_credential_file` dodatkowo modyfikując ścieżkę do pliku credentials AWS.

```
[credentials]
#   shared_credential_profile = "{profile_name}"
    shared_credential_file = "/root/.aws/credentials"
```

Następnie uruchamiamy polecenie, które uruchomi agenta CloudWatch `AWS_REGION=eu-cetral-1 /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m onPremise -s -c file:/sciezka/do/pliku/konfiguracyjnego.json`

Wywołując polecenie `systemctl status amazon-cloudwatch-agent.service` potwierdzamy, że agent CloudWatch działa. Po paru minutach metryki i wpisy z pliku loga "/my/path/to/log/file.log" powinny się pojawić w konsoli CloudWatch.
