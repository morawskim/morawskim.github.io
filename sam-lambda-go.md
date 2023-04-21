# AWS SAM & Lambda & Go

Wykorzystując AWS SAM zbudowałem funkcję lambda w Go, którą mogłem łatwo wgrać do AWS i ją testować.

Wykorzystywaliśmy istniejące zasoby działające w chmurze AWS dla środowiska produkcyjnego, ale nie korzystaliśmy z Infrastructure as Code.
Szablon z SAM nie był, więc dobrym wyborem. Istnieją jednak inne opcje deploymentu.

Jeśli utworzymy naszą funkcję przez konsole AWS, możemy wgrać nowy kod za pomocą narzędzia AWS CLI.

Musimy skompilować naszą funkcję za pomocą standardowego polecenia `go build`.
Jeśli potrzebujemy (tak jak w tym przypadku biblioteki GLIBC) to możemy wykorzystać poniższy szkic Dockerfile, który instaluje go w Amazon Linux 1.

```
FROM amazonlinux:1

RUN yum install -y wget gcc && \
    wget -qO- https://dl.google.com/go/go1.20.2.linux-amd64.tar.gz | tar -C /usr/local -xz && \
    yum clean all
```

Wykorzystując zbudowany obraz kompilujemy naszą funkcję - `docker run --rm -v go-thumbnails-cache:/root/go -v go-thumbnails-build-cache:/root/.cache/go-build -v $PWD:/app -w /app nazwa-zbudowanego-obrazu-z-Dockerfile go build -o thumbnails ./main.go`. W moiej konfiguracji funkcji, w sekcji Runtime, handler był ustawiony na `thumbnails` dlatego plik wynikowy ma taką nazwę.

Następnie tworzymy archiwum zip z naszym plikiem binarnym: `zip lambda.zip ./thumbnails`.

I finalnie wywołujemy polecenie, które wgra nowy kod.

```
aws lambda update-function-code \
    --function-name thumbnails-ThumbnailsFunction-XXXXXXXXXXXX \
    --region eu-central-1 \
    --zip-file fileb://lambda.zip
```

Jeśli chcemy opublikować nową wersję to do polecenia dodajemy flagę `--publish`.

[Deploy Go Lambda functions with .zip file archives](https://docs.aws.amazon.com/lambda/latest/dg/golang-package.html)
