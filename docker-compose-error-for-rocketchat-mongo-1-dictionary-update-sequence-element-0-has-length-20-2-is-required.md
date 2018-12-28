# docker-compose - ERROR: for rocketchat_mongo_1 dictionary update sequence element #0 has length 20; 2 is required

Podczas próby uruchomienia usługi mongo z pliku `docker-compose.yml` Rocket.Chat otrzymałem błąd:

```
docker-compose up -d mongo
Creating rocketchat_mongo_1 ...

ERROR: for rocketchat_mongo_1 dictionary update sequence element #0 has length 20; 2 is required

ERROR: for mongo dictionary update sequence element #0 has length 20; 2 is required
Traceback (most recent call last):
File "/usr/bin/docker-compose", line 9, in <module>
load_entry_point('docker-compose==1.17.0', 'console_scripts', 'docker-compose')()
File "/usr/lib/python2.7/site-packages/compose/cli/main.py", line 68, in main
command()
File "/usr/lib/python2.7/site-packages/compose/cli/main.py", line 121, in perform_command
handler(command, command_options)
File "/usr/lib/python2.7/site-packages/compose/cli/main.py", line 952, in up
start=not no_start
File "/usr/lib/python2.7/site-packages/compose/project.py", line 455, in up
get_deps,
File "/usr/lib/python2.7/site-packages/compose/parallel.py", line 70, in parallel_execute
raise error_to_reraise
ValueError: dictionary update sequence element #0 has length 20; 2 is required
```

Jak się okazało, musiałem zmienić notację `labels` w pliku `docker-compose.yml`.
Z
```
labels:
- "traefik.backend=rocketchat"
- "traefik.frontend.rule=Host: your.domain.tld"
```

Na
```
labels:
traefik.backend: "rocketchat"
traefik.frontend.rule: "Host: your.domain.tld"
```

Więcej informacji:
https://github.com/docker/compose/issues/5336#issuecomment-344823678
https://github.com/docker/compose/issues/5349
