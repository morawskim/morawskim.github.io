# docker-compose build - ERROR: Couldn't connect to Docker daemon

W projekcie zaktualizowałem plik `Dockerfile` i próbowałem ponownie zbudować obraz poleceniem `docker-compose build`.
Jednak otrzymałem błąd:
```
traefik uses an image, skipping
mysql uses an image, skipping
Building blog
ERROR: Couldn't connect to Docker daemon at http+docker://localunixsocket - is it running?
```

Oczywiście usługa dockerd była uruchomiona. Mogłem wywołać bez problemu polecenie `docker info`.

Wywołałem polecenie `docker-compose --verbose build`, ale nie otrzymałem przyczyny błędu:
```
compose.config.config.find: Using configuration files: ./docker-compose.yml
docker.auth.find_config_file: Trying paths: ['/home/marcin/.docker/config.json', '/home/marcin/.dockercfg']
docker.auth.find_config_file: Found file at path: /home/marcin/.docker/config.json
docker.auth.load_config: Found 'auths' section
docker.auth.parse_auth: Found entry (registry=u'XXXXXXXXXXX', username=u'YYYYYY')
docker.auth.load_config: Found 'HttpHeaders' section
urllib3.connectionpool._make_request: http://localhost:None "GET /v1.25/version HTTP/1.1" 200 567
compose.cli.command.get_client: docker-compose version 1.17.0, build unknown
docker-py version: 2.6.1
CPython version: 2.7.14
OpenSSL version: OpenSSL 1.1.0i-fips  14 Aug 2018
compose.cli.command.get_client: Docker base_url: http+docker://localunixsocket
compose.cli.command.get_client: Docker version: KernelVersion=4.12.14-lp150.12.48-default, Components=[{u'Version': u'18.09.1', u'Name': u'Engine', u'Details': {u'KernelVersion': u'4.12.14-lp150.12.48-default', u'Os': u'linux', u'BuildTime': u'2019-02-09T12:00:00.000000000+00:00', u'ApiVersion': u'1.39', u'MinAPIVersion': u'1.12', u'GitCommit': u'4c52b901c6cb', u'Arch': u'amd64', u'Experimental': u'false', u'GoVersion': u'go1.10.7'}}], Arch=amd64, BuildTime=2019-02-09T12:00:00.000000000+00:00, ApiVersion=1.39, Platform={u'Name': u''}, Version=18.09.1, MinAPIVersion=1.12, GitCommit=4c52b901c6cb, Os=linux, GoVersion=go1.10.7
compose.project.build: traefik uses an image, skipping
compose.project.build: mysql uses an image, skipping
compose.service.build: Building blog
compose.cli.verbose_proxy.proxy_callable: docker build <- (nocache=False, pull=False, labels=None, target=None, stream=True, cache_from=None, network_mode=None, tag=u'blog_blog', buildargs={}, forcerm=False, rm=True, path='/home/marcin/projekty/audyt/blog', dockerfile=None, shmsize=None)
docker.api.build._set_auth_headers: Looking for auth config
docker.api.build._set_auth_headers: Sending auth config (u'XXXXXXXXXXXXXX', 'HttpHeaders')
ERROR: compose.cli.errors.exit_with_error: Couldn't connect to Docker daemon at http+docker://localunixsocket - is it running?

If it's at a non-standard location, specify the URL with the DOCKER_HOST environment variable.
```

Postanowiłem wykorzystać polecenie `docker build` i sprawdzić czy otrzymam jakiś bardziej szczegółowy błąd.

```
docker build -tblog_blog   .
error checking context: 'no permission to read from '/home/marcin/projekty/audyt/blog/.r/mysqldata/auto.cnf''.
```

Tym razem błąd był jasny. Dodałem plik `.dockerignore` z regułą wykluczającą katalog `.r/`.
Dzięki temu mogłem znów zacząć budować obrazy za pomocą polecenia `docker-compose build`.
