# AWS SAM, Go i GLIBC

Podczas wykonywania lokalnie funkcji lambda w środowisku go1.x otrzymywałem błąd z wersją biblioteki GLIBC.
> version `GLIBC_2.XX' not found (required by XXX)

Niektóre programy utworzone w Go wymagają odpowiedniej wersji biblioteki GLIBC - [Go programs and Linux glibc versioning](https://utcc.utoronto.ca/~cks/space/blog/programming/GoAndGlibcVersioning)

Istnieje [zgłoszenie](https://github.com/aws/aws-lambda-go/issues/340) i opis rozwiązania tego problemu - 
[GLIBC not found with AWS SAM and Golang](https://www.gaunt.dev/blog/2022/glibc-error-with-aws-sam-and-go/)

W moim przypadku korzystałem z Ubuntu 20.04 LTS.
Choć SAM posiada opcję budowania wykorzystując kontener,
to jednak nie jest to wspierane dla języka Go - [Bug: sam build --use-container doesn't correctly build golang containers #3894](https://github.com/aws/aws-sam-cli/issues/3894)

Musimy zmodyfikować plik szablonu SAM w celu zmiany mechanizmu budowania kodu. 
W pliku szablonu SAM `template.yaml` w sekcji naszej funkcji lambda dodajemy klucz 
`Metadata`, w nim tworzymy klucz `BuildMethod` i przypisujemy mu wartość `makefile`.
Tak jak poniżej:

```
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
# ...

Resources:
  HelloWorldFunction:
    Type: AWS::Serverless::Function # More info about Function Resource: https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#awsserverlessfunction
    Metadata:
      BuildMethod: makefile
    # ...
```

Tworzymy plik Dockerfile.
Do budowania kodu używamy Amazon Linux 1 (to na tej dystrybucji odpalany jest kod).

```
FROM amazonlinux:1

RUN yum install -y wget gcc && \
    wget -qO- https://dl.google.com/go/go1.20.2.linux-amd64.tar.gz | tar -C /usr/local -xz && \
    yum clean all

ENV PATH=/usr/local/go/bin:$PATH
```

Wykorzystując powyższy Dockerfile możemy zbudować obraz, który zawiera Go i kompilator gcc.
Wywołujemy polecenie do budowania `docker build -t nazwa-obrazu:dev -f Dockerfile .`

Następnie w katalogu kodu naszej funkcji tworzymy plik `Makefile`
Musimy utworzyć nowy target w Makefile korzystając z  konwencji `build-<NAZWA_ZASOBU_LAMBDA_Z_SZABLONU_SAM>`
W moim przypadku jest to `HelloWorldFunction`, więc target to `build-HelloWorldFunction`

```
build-HelloWorldFunction:
	@echo CURRENT_DIR: $(CURDIR)
	docker run --rm -v go-hello-world-cache:/root/go -v go-hello-world-build-cache:/root/.cache/go-build -v $(CURDIR):/app -w /app nazwa-obrazu:dev go build -gcflags='all=-N -l' -o hello-world ./main.go
	mv hello-world $(ARTIFACTS_DIR)
```

Mając to wszystko jesteśmy w stanie wywołać polecenie `sam build`

```
Starting Build use cache
Cache is invalid, running build and copying resources for following functions (HelloWorldFunction)
Building codeuri: /home/XXXXXXXXXXXXXXX/hello-world runtime: go1.x metadata: {'BuildMethod': 'makefile'} architecture: x86_64 functions: HelloWorldFunction
Running CustomMakeBuilder:CopySource
Running CustomMakeBuilder:MakeBuild
Current Artifacts Directory : /home/XXXXXXXXXXXXXXX/.aws-sam/build/HelloWorldFunction
CURRENT_DIR: /tmp/tmp00y2adz7
docker run --rm -v /tmp/tmp00y2adz7:/app -w /app thumbnailsdev go build -gcflags='all=-N -l' -o hello-world ./main.go
mv hello-world /home/XXXXXXXXXXXXXXX/.aws-sam/build/HelloWorldFunction

Build Succeeded

Built Artifacts  : .aws-sam/build
Built Template   : .aws-sam/build/template.yaml

Commands you can use next
=========================
[*] Validate SAM template: sam validate
[*] Invoke Function: sam local invoke
[*] Test Function in the Cloud: sam sync --stack-name {{stack-name}} --watch
[*] Deploy: sam deploy --guided

```

Możemy wywołać lokalnie naszą funkcje `sam local invoke .....` i tym razem problem z biblioteką glibc nie został zgłoszony.
