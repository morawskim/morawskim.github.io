# AWS lambda

* AWS zaleca umieszczenie funkcji Lambda w sieci VPC tylko wtedy, gdy jest to absolutne niezbędne do uzyskania dostępu do zasobu nieosiągalnego w inny sposób. Umieszczenie funkcji Lambda w sieci VPC powoduje wzrost złożoności, zwłaszcza przy potrzebie jednoczesnego uruchomienia dużej liczby kopii funkcji.

* Wdrożenie funkcji lambda w publicznej podsieci VPC nie daje jej dostępu do Internetu, ani publicznego adresu IP. W prywatnej podsieci dostęp do Internetu jest dostępny, jeśli podsieć zawiera bramę/instancję NAT. [How do I give internet access to a Lambda function that's connected to an Amazon VPC?](https://aws.amazon.com/premiumsupport/knowledge-center/internet-access-lambda-function/)

* Limit współbieżności (1000 jednocześnie działających funkcji lambda) jest na konto AWS, a nie na pojedynczą funkcję. Jedna funkcja może więc wykorzystać cały dostępny limit. Możemy ustawiać limity per funkcja, dodatkowo jeśli potrzebujemy większej współbieżności to możemy utworzyć zgłoszenie z prośbą o zwiększenie tego limitu.

* Każde wywołanie funkcji Lambda musi się zakończyć w ciągu maksymalnie 15 minut.

* Moc obliczeniowa procesora i wydajności sieci są przydzielane funkcji Lambda na podstawie aprowizacji pamięci. Więcej pamięci == lepszy procesor i sieć.

* Maksymalny rozmiar skompresowanego pakietu wdrożeniowego (pliku zip) wynosi domyślnie 50MB.

* Lista obsługiwanych [środowisk wykonawczych](https://github.com/boto/botocore/blob/develop/botocore/data/lambda/2015-03-31/service-2.json#L4791). Uwaga pozycja na liście mogą się zmieniać z biegiem czasu.

## Limity

Podczas fazy analizy i rozpatrywania lambdy jako rozwiązania warto wziąć pod uwagę jej [limity](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html).
Wielkość żądania i odpowiedzi wywołania synchronicznego nie może przekraczać 6MB. W przeciwnym przypadku otrzymamy błędy:

> {"Message":"6991583 byte payload is too large for the RequestResponse invocation type (limit 6291456 bytes)"}

> {
>   "errorMessage": "Response payload size exceeded maximum allowed payload size (6291556 bytes).",
>   "errorType": "Function.ResponseSizeTooLarge"
> }

Kolejnymi ograniczeniami jest liczba warstw (maks 5) czy też maksymalny czas wykonania skryptu (maks 15 min).
Dodatkowo niektóre ograniczenia mogą być znacznie niższe jeśli korzystamy z API Gateway czy ALB.

Funkcje lambda są uruchamiane domyślnie w oddzielnej sieci VPC. Uruchomienie funkcji lambda w naszym VPC to [dodatkowe ograniczenia](https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html#vpc-internet).

[Can the 1MB request payload limit for an ALB Lambda target be increased?](https://www.repost.aws/questions/QUPHFFlMKbT-urD9l3gHMdLQ/can-the-1-mb-request-payload-limit-for-an-alb-lambda-target-be-increased)

[3 years of lift-and-shift into AWS Lambda](https://blog.deleu.dev/lift-and-shift-aws-lambda/)

## Przykład Node.js

Tworzymy plik `index.js` z funkcją do obsługi żądania HTTP:

```
const AWS = require('aws-sdk');
// Uzywamy uslugi S3, wiec nasza funkcja musi miec przypisana odpowiednia role
const s3 = new AWS.S3()

exports.handler = async function(event) {
  return {
      statusCode: 200,
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        "requestEvent": event,
        "buckets": await s3.listBuckets().promise()
      }),
  };
}

```

Nie musimy instalować SDK AWS, ponieważ jest ono dostępne.
[Nadajemy uprawnienia do odczytu wszystkim użytkownikom](https://docs.aws.amazon.com/lambda/latest/dg/troubleshooting-deployment.html#troubleshooting-deployment-denied) - `chmod -R o+rX .`
Tworzymy plik zip z kodem i wszystkimi zależnościami `zip -r function.zip .`.
Wykorzystując aws-cli tworzymy funkcję:

```
aws lambda create-function \
--zip-file fileb://function.zip \
--function-name lambda-nodejs-example \
--runtime nodejs14.x \
--handler index.handler \
--role arn:aws:iam::account:role/nasz-rola-z-dostepem-do-s3-i-AWSLambdaBasicExecutionRole
```

Za pomocą polecenia `aws lambda get-function --function-name lambda-nodejs-example` możemy pobrać informacje o naszej funkcji "lambda-nodejs-example".

Funkcję wywołujemy za pomocą polecenia `aws lambda invoke --function-name lambda-nodejs-example --cli-binary-format raw-in-base64-out --payload '{"key": "value", "another_key": "foo" }' response.json`. W pliku "response.json` zostanie zapisany wynik działania naszej funkcji.

Chcąc opublikować nasza funkcje i mieć do niej publiczny dostęp przez protokół HTTP/HTTPS wywołujemy polecenie:

```
aws lambda create-function-url-config \
    --function-name lambda-nodejs-example \
    --auth-type NONE
```

Możemy także skorzystać z parametru `--qualifier prod`, aby opublikować nasza funkcje wskazywaną przez alias `prod`.
Otrzymamy URL do naszej funkcji. Jeśli z jakiegoś powodu nie zapisaliśmy adresu możemy go uzyskać ponownie wywołując polecenie `aws lambda get-function-url-config --function-name lambda-nodejs-example`.

Jeśli wywołując naszą opublikowana funkcje otrzymamy błąd `{"Message":"Forbidden"}` najprawdopodobniej nie nadaliśmy uprawnienia "lambda:invokeFunctionUrl" w "Resource-based policy"
> Your function URL auth type is NONE, but is missing permissions required for public access. To allow unauthenticated requests, choose the Permissions tab and and create a resource-based policy that grants lambda:invokeFunctionUrl permissions to all principals (*). Alternatively, you can update your function URL auth type to AWS_IAM to use IAM authentication.

Możemy także wysłać request POST: `curl -XPOST -d'{"foo":"bar"}' -H 'Content-Type: application/json' <url-naszej-funkcji-lambda>`

[Tutorial: Using an Amazon S3 trigger to create thumbnail images](https://docs.aws.amazon.com/lambda/latest/dg/with-s3-tutorial.html#s3-tutorial-events-adminuser-create-test-function-upload-zip-test-manual-invoke)

[How do I troubleshoot "permission denied" or "unable to import module" errors when uploading a Lambda deployment package?](https://aws.amazon.com/premiumsupport/knowledge-center/lambda-deployment-package-errors/)

## PHP i Bref

Choć lambda nie dostarcza natywnego środowiska wykonawczego dla PHP, to możemy za pomocą Lambda Runtime API i Bref wykorzystać PHP do budowy funkcji.

Tworzymy plik `lambdaPHPRole.json` o zawartości:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

Następnie tworzymy rolę za pomocą narzędzia aws-cli - `aws iam create-role --role-name lambda-php-demo --assume-role-policy-document file://lambdaPHPRole.json` i dołączamy zarządzaną politykę AWS, która zawiera minimalne uprawnienia do działania funkcji lambda `aws iam attach-role-policy --role-name lambda-php-demo --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole`.

Za pomocą polecenia `aws iam get-role --role-name lambda-php-demo --query Role.Arn --output text` możemy wyświetlić ARN utworzonej roli.

Zakładamy nowy projekt PHP - `composer init`.
Instalujemy pakiet `bref/bref` w wersji `^1.7`.
Tworzymy plik `index.php`:

```
<?php

require __DIR__ . '/vendor/autoload.php';

return static function ($event) {
    echo json_encode(['info' => 'This message will be logged to CloudWatch']);

    return [
        'statusCode' => 200,
        'headers' => ['Content-Type' => 'application/json'],
        'body' => json_encode([
            'requestEvent' => $event,
        ]),
    ];
};
```

Następnie tworzymy archiwum ZIP z kodem naszej prostej funkcji `zip -r9q ../function.zip .`.
Za pomocą polecenia `zipinfo function.zip` możemy wyświetlić listę plików wraz z uprawnieniami.

Wywołujemy polecenie do utworzenia funkcji w AWS:

```
aws lambda create-function \
--function-name lambda-php-bref-example \
--role $(aws iam get-role --role-name lambda-php-demo --query Role.Arn --output text) \
--handler index.php \
--runtime provided.al2 \
--layers "arn:aws:lambda:eu-central-1:209497400698:layer:php-81:28" \
--zip-file fileb://function.zip
```

Każda zmiana kodu wymaga ponownego zbudowania pliku ZIP i wywołania polecenia:
```
aws lambda update-function-code \
--function-name lambda-php-bref-example \
--zip-file fileb://function.zip
```

Na koniec możemy wywołać funkcję:

```
aws lambda invoke \
--function-name lambda-php-bref-example \
--invocation-type RequestResponse \
--cli-binary-format raw-in-base64-out \
--payload '{"name": "Marcin"}' \
output.json
```

Wynik działania zostanie zapisany w pliku "output.json", który możemy wyświetlić za pomocą polecenia `cat output.json`.
