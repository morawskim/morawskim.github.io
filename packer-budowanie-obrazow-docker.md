# packer - budowanie obrazów docker

Podczas budowania obrazu docker z node 10 i chrome, chciałem otagowac obraz odpowiednią wersją przeglądarki chrome.
Tag tego obrazu zależy od zainstalowanej wersji chrome. Musimy więc wpierw zainstalować chrome, aby móc wyciągnąć wersję.

Postanowiłem, utworzyć dwa pliki szablonu packer.
Pierwszy plik `box.json` tworzy obraz kontenera i taguje go wersją `latest`.
Drugi plik szablonu `box-tag.json` oczekuje parametry `docker_tag`, który określa wersję przeglądarki chrome np. `77.0`.
Dodatkowo pracuje on na obrazie stworzonym przez szablon `box.json`.
Dzięki temu ten plik nie zawiera już provisioningu. Wystarczy tylko otagować obraz i przesłać go.
[Przykładowa implementacja](https://github.com/morawskim/packer-images/)

## An image does not exist locally with the tag: sha256

Ten błąd jest raczej częsty świadczy o tym kilka zgłoszeń:
[Docker-Push Returns Error After Docker-Tag #5526](https://github.com/hashicorp/packer/issues/5526)

[An image does not exist locally with the tag: sha256 #4017](https://github.com/hashicorp/packer/issues/4017)

Jednak rozwiązanie jest banalne. Trzeba uruchamiać post-processors w sekwencji.
[Przykład można pobrać z dokumentacji](https://www.packer.io/docs/builders/docker.html)


## docker-push post-processor
Podczas budowania obrazu dockera przez proces CI nie mogłem przesłać wynikowego obrazu do rejestru dockera.
Otrzymywałem błąd:
```
docker (docker-push): https://docs.docker.com/engine/reference/commandline/login/#credentials-store
docker (docker-push): Pushing: morawskim/node10-google-chrome:latest
docker (docker-push): The push refers to repository [docker.io/morawskim/node10-google-chrome]
docker (docker-push): 3711bbb7b96b: Preparing
docker (docker-push): e9dc98463cd6: Preparing
docker (docker-push): denied: requested access to the resource is denied
docker (docker-push): Logging out...
docker (docker-push): Removing login credentials for index.docker.io
```

Na lokalnej maszynie mogłem przesłać obraz. Na obu maszynach działał ta sama wersja `packer`, ale różne wersje `docker'a` (`docker --version`).
Na CI była to wersja `Docker version 18.09.7, build 2d0083d`. Zaś na mojej maszynie
```
Client:
 Version:           19.03.1
 API version:       1.40
 Go version:        go1.12.6
 Git commit:        74b1e89e8ac6
 Built:             Fri Jul 26 12:00:00 2019
 OS/Arch:           linux/amd64
 Experimental:      false
....
```

Dodatkowo ponieważ te zadanie w pliku `.gitlab-ci.yaml` miało ustawione ręczne wywoływanie (`when: manual`) problem z budowaniem takiego obrazu nie przerywał potoku i w konsekwencji nie dostajemy wiadomości email z błędem. W konfiguracji zadania musiałem ustawić jawnie opcje `allow_failure` na wartość `false`.

>Optional manual actions have allow_failure: true set by default and their Statuses do not contribute to the overall pipeline status. So, if a manual action fails, the pipeline will eventually succeed.

https://docs.gitlab.com/ee/ci/yaml/#whenmanual

W moim pliku szablonu jawnie wskazywałem na publiczny serwer rejestru zarządzany przez dockera `https://index.docker.io`.
Skasowałem opcję `login_server` z konfiguracji `post-processors` dla `docker-push`.
Po tej zmianie obrazy na serwerze zaczęły się poprawnie przesyłać do rejestru dockera.

